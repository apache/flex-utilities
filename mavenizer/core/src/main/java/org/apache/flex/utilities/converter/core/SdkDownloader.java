package org.apache.flex.utilities.converter.core;

import org.apache.flex.utilities.converter.air.AirConverter;
import org.apache.flex.utilities.converter.flash.FlashConverter;
import org.apache.flex.utilities.converter.flex.FlexConverter;
import org.apache.flex.utilities.converter.fontkit.FontkitConverter;
import org.apache.flex.utilities.converter.retrievers.download.DownloadRetriever;
import org.apache.flex.utilities.converter.retrievers.types.PlatformType;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;

import java.io.File;

/**
 * Created by christoferdutz on 07.04.15.
 */
public class SdkDownloader {

    public static void main(String[] args) throws Exception {
        File mavenTarget = new File("temp/maven");
        mavenTarget.mkdirs();

        DownloadRetriever downloadRetriever = new DownloadRetriever();

        // Download and convert Flex
        File flexDir = downloadRetriever.retrieve(SdkType.FLEX, "4.14.1");
        FlexConverter flexConverter = new FlexConverter(flexDir, mavenTarget);
        flexConverter.convert();

        // Download and convert Air
        File airDir = downloadRetriever.retrieve(SdkType.AIR, "17.0", PlatformType.MAC);
        AirConverter airConverter = new AirConverter(airDir, mavenTarget);
        airConverter.convert();

        // Download and convert Flash
        File flashDir = downloadRetriever.retrieve(SdkType.FLASH, "17.0");
        FlashConverter flashConverter = new FlashConverter(flashDir, mavenTarget);
        flashConverter.convert();

        // Download and convert Fontkit
        File fontkitDir = downloadRetriever.retrieve(SdkType.FONTKIT);
        FontkitConverter fontkitConverter = new FontkitConverter(fontkitDir, mavenTarget);
        fontkitConverter.convert();
    }

}
