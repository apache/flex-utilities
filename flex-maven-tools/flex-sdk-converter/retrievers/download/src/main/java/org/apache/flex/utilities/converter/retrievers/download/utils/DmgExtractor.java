package org.apache.flex.utilities.converter.retrievers.download.utils;

import org.apache.commons.compress.compressors.bzip2.BZip2CompressorInputStream;
import org.apache.commons.io.input.NullInputStream;
import org.apache.flex.utilities.converter.retrievers.download.utils.utils.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.bind.DatatypeConverter;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Tool to read and unpack a dmg image. Based upon the format description at:
 * http://newosxbook.com/DMG.html
 *
 * HFSleuth> fs flashplayer_20_sa_debug.dmg
 * KOLY header found at 14457517:
 *         UDIF version 4, Header Size: 512
 *         Flags:1
 *         Rsrc fork: None
 *         Data fork: from 0, spanning 14444891 bytes
 *         XML plist: from 14444891, spanning 12626 bytes (to 14457517)
 *         Segment #: 1, Count: 1
 *         Segment UUID: 8a7e1df1-6648ad9f-78cb06a4-2c5be967
 *         Running Data fork offset 0
 *         Sectors: 70816
 * Apple_HFS detected
 * Found Terminator in last block. Good
 * decompression done - Writing to /tmp/decompressed.dmg..
 * processBTree: Node kind 0, 0 records - should be kind 1, 3 records - but it isn't!
 * node is 0
 * RC was 0
 *
 * Created by christoferdutz on 24.02.16.
 */
public class DmgExtractor {

    // Hex for "koly", which are the DMG magic bytes.
    private static final byte[] DMG_TRAILER_MAGIC_BYTES = {0x6B, 0x6F, 0x6C, 0x79};

    public File extract(File inputFile) {
        try {
            // Try to find the DMG trailer.
            // (A header containing the metadata, but located at the end)
            DmgTrailer dmgTrailer = findDmgTrailer(inputFile);
            if(dmgTrailer != null) {
                float sizeInMegabytes = dmgTrailer.getDataForkLength() / (1024 * 1024);
                System.out.println(" - Preparing to extract " + sizeInMegabytes + " MB");

                // Read the property-list Xml document in the DMG file.
                List<DmgPropertyListMishBlock> mishBlocks = getPropertyList(inputFile, dmgTrailer);

                byte[] buffer = new byte[1024];
                int blockCounter = 0;
                for(DmgPropertyListMishBlock mishBlock : mishBlocks) {
                    System.out.println("   - Processing block: " + blockCounter + " - " + mishBlock.getBlockName());
                    int chunkCounter = 0;
                    for(DmgBlockChunkEntry blockChunkEntry : mishBlock.getBlockChunkEntries()) {
                        System.out.println("     - Processing chunk: " + chunkCounter + " - " + blockChunkEntry.toString());
                        FileInputStream fis = new FileInputStream(inputFile);

                        try {
                            // Position the read head at the beginning of this entry.
                            fis.skip(mishBlock.getDataOffset() + blockChunkEntry.getCompressedOffset());

                            // Depending on the chunk entry type, process the input data.
                            InputStream is = null;
                            switch (blockChunkEntry.getEntryType()) {
                                case 0x00000000:
                                    //entryTypeName = "Zero-Fill";
                                    is = new NullInputStream(blockChunkEntry.getCompressedLength());
                                    break;
                                case 0x00000001:
                                    //entryTypeName = "UDRW/UDRO - RAW or NULL compression (uncompressed)";
                                    is = fis;
                                    break;
                                case 0x00000002:
                                    //entryTypeName = "Ignored/unknown";
                                    // TODO: Implement
                                    break;
                                case 0x80000004:
                                    //entryTypeName = "UDCO - Apple Data Compression (ADC)";
                                    // TODO: Implement
                                    break;
                                case 0x80000005:
                                    //entryTypeName = "UDZO - zLib data compression";
                                    // TODO: Implement
                                    break;
                                case 0x80000006:
                                    //entryTypeName = "UDBZ - bz2lib data compression";
                                    is = new BZip2CompressorInputStream(fis);
                                    break;
                                case 0x7ffffffe:
                                    //entryTypeName = "No blocks - Comment: +beg and +end";
                                    // TODO: Implement
                                default:
                            }

                            if (is != null) {
                                // Read the data into a byte-buffer.
                                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                int n;
                                while ((n = is.read(buffer)) != -1) {
                                    baos.write(buffer, 0, n);
                                }

                                System.out.println("        - Number of sectors: " + blockChunkEntry.getSectorCount() +
                                        " sector size: " + (baos.size() / blockChunkEntry.getSectorCount()));

                                ByteArrayInputStream bis = new ByteArrayInputStream(baos.toByteArray());
                                DataInputStream dis = new DataInputStream(bis);
                                // Depending on the type, process the data in the buffer.
                                if (mishBlock.getBlockName().contains("Driver Descriptor Map")) {
                                    DriverDescriptorMap driverDescriptorMap = new DriverDescriptorMap(dis);
                                    System.out.println("        - " + driverDescriptorMap.toString());
                                }
                                if (mishBlock.getBlockName().contains("Apple_partition_map")) {
                                    List<ApplePartitionMap> partitionMaps =
                                            new ArrayList<ApplePartitionMap>((int) blockChunkEntry.getSectorCount());
                                    for(int i = 0; i < blockChunkEntry.getSectorCount(); i++) {
                                        try {
                                            ApplePartitionMap partitionMap = new ApplePartitionMap(dis);
                                            System.out.println("        - Partition " + i + " - " +
                                                    partitionMap.getTypeOfPartition() + " - " +
                                                    partitionMap.toString());
                                            partitionMaps.add(partitionMap);
                                        } catch(Exception e) {
                                            break;
                                        }
                                    }
                                }
                                // See: https://en.wikipedia.org/wiki/Hierarchical_File_System
                                else if (mishBlock.getBlockName().contains("Apple_HFS")) {
                                    // Block 0 and 1 contain the boot blocks (each 512 bytes)
                                    // We need to skip these.
                                    // TODO: Eventually implement.
                                    dis.skipBytes(1024);
                                    System.out.println("        - Skipped boot block (0 and 1)");
                                    // Block 2 contains the master directory block
                                    // TODO: Actually this could also be a normal HFS volume ...
                                    IHFSVolumeHeader iHfsVolumeHeader = HFSVolumeFactory.readHfsVolumeHeader(dis);
                                    System.out.println("        - " + iHfsVolumeHeader.toString());
                                    // In the old HFS format the third block contains the volume
                                    // bitmap, in HFS+ this is located as a normal file in the volume.
                                    if(iHfsVolumeHeader instanceof HFSVolumeHeader) {
                                        HFSVolumeHeader hfsVolumeHeader = (HFSVolumeHeader) iHfsVolumeHeader;
                                        // Block 3 contains the volume bitmap
                                        // (one bit represents the usage of one block)
                                        // https://en.wikipedia.org/wiki/Hierarchical_File_System
                                        /*int volumeBitmapSize = hfsVolumeHeader.getTotalBlocks() / 8;
                                        byte[] volumeBitmap = new byte[volumeBitmapSize];
                                        dis.read(volumeBitmap);
                                        System.out.println(volumeBitmap);*/
                                    }
                                    else if(iHfsVolumeHeader instanceof HFSPlusVolumeHeader) {
                                        HFSPlusVolumeHeader hfsPlusVolumeHeader =
                                                (HFSPlusVolumeHeader) iHfsVolumeHeader;
                                        // https://en.wikipedia.org/wiki/HFS_Plus
                                        // http://pages.cs.wisc.edu/~legault/miniproj-736.pdf
                                    }
                                }
                                chunkCounter++;
                            }
                        } catch(IOException ioe) {
                            ioe.printStackTrace();
                        } finally {
                            try {
                                fis.close();
                            } catch(IOException e) {
                                // Ignore
                            }
                        }
                    }
                    blockCounter++;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (XPathExpressionException e) {
            e.printStackTrace();
        }
        return null;
    }

    private DmgTrailer findDmgTrailer(File inputFile) throws IOException {
        long startTime = new Date().getTime();

        RandomAccessFile raf = new RandomAccessFile(inputFile, "r");
        // The size of the DMG trailer is 512 bytes. As it's located at the
        // end of the file there is no use starting to search for it from the
        // beginning. So we read a block that's slightly bigger than the
        // trailer and search for the magic words in this block.
        long curBlockStartPosition = raf.length() - 600;
        long dmgTrailerPosition = -1;
        do {
            // Position the read "head".
            raf.seek(curBlockStartPosition);

            // Read a block of 600 bytes.
            byte[] curBlock = new byte[600];
            raf.read(curBlock);

            // Scan the current block for the magic bytes.
            int curMagicWordPosition = 0;
            for (int curBlockPosition = 0; curBlockPosition < 600; curBlockPosition++) {
                if (curBlock[curBlockPosition] == DMG_TRAILER_MAGIC_BYTES[curMagicWordPosition]) {
                    curMagicWordPosition++;
                } else {
                    curMagicWordPosition = 0;
                }
                if (curMagicWordPosition == 4) {
                    // We are just comparing the last byte of the magic word
                    // so we only have to go back 3 bytes.
                    dmgTrailerPosition = curBlockStartPosition + (long) curBlockPosition - 3;
                    break;
                }
            }

            // If we were in the first block, quit searching.
            if(curBlockStartPosition == 0) {
                break;
            }
            // We shift the search box back, but keep 4 bytes of overlap
            // just in case the magic word was at the boundary of the block.
            // This way we will be able to read it in the next pass.
            curBlockStartPosition = Math.max(0, curBlockStartPosition - 596);
        } while(dmgTrailerPosition == -1);
        long endTime = new Date().getTime();
        System.out.println("Found DMG trailer at position " + dmgTrailerPosition + " in " + (endTime - startTime) + "ms");

        // Read and parse the trailer data.
        if(dmgTrailerPosition != -1) {
            raf.seek(dmgTrailerPosition);
            byte[] dmgTrailerData = new byte[512];
            raf.read(dmgTrailerData);
            return new DmgTrailer(dmgTrailerData);
        }

        return null;
    }

    private List<DmgPropertyListMishBlock> getPropertyList(File inputFile, DmgTrailer dmgTrailer) throws IOException,
            ParserConfigurationException, SAXException, XPathExpressionException {
        // Read the block of bytes containing the property list data.
        byte[] propertyListData = new byte[(int) dmgTrailer.getXmlLength()];
        RandomAccessFile raf = new RandomAccessFile(inputFile, "r");
        raf.seek(dmgTrailer.getXmlOffset());
        raf.read(propertyListData);

        // Parse the xml document data.
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document propertyListDoc = builder.parse(new ByteArrayInputStream(propertyListData));

        try {
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            transformer.setOutputProperty(OutputKeys.METHOD, "xml");
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");

            transformer.transform(new DOMSource(propertyListDoc),
                    new StreamResult(new OutputStreamWriter(System.out, "UTF-8")));
        } catch(Exception e) {
            // Ignore ...
        }

        List<DmgPropertyListMishBlock> mishBlocks = new ArrayList<DmgPropertyListMishBlock>();
        XPath xPath = XPathFactory.newInstance().newXPath();
        NodeList nodes = (NodeList) xPath.evaluate("//array/dict[key='CFName']/data",
                propertyListDoc.getDocumentElement(), XPathConstants.NODESET);
        for (int i = 0; i < nodes.getLength(); ++i) {
            Element dataElement = (Element) nodes.item(i);
            Element nameElement = (Element) dataElement.getPreviousSibling().getPreviousSibling()
                    .getPreviousSibling().getPreviousSibling();
            byte[] dataBlock = DatatypeConverter.parseBase64Binary(dataElement.getTextContent());
            DmgPropertyListMishBlock mishBlock = new DmgPropertyListMishBlock(nameElement.getTextContent(), dataBlock);
            mishBlocks.add(mishBlock);
        }
        return mishBlocks;
    }

    public static void main(String[] args) throws Exception {
        File input = new File("/Users/christoferdutz/Downloads/flashplayer_20_sa_debug.dmg");
        DmgExtractor dmgExtractor = new DmgExtractor();
        dmgExtractor.extract(input);
    }

    public static String getStringFromZeroTerminatedByteArray(byte[] data) {
        int i;
        for (i = 0; i < data.length && data[i] != 0; i++) { }
        return new String(data, 0, i);
    }

}
