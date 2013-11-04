package common;

import java.io.File;
import java.util.*;

/**
 * Created by cdutz on 01.11.13.
 */
public class ConversionPlan {

    private final Set<String> versions;
    private final Map<String, File> directories;
    private final Map<String, Boolean> apacheFlags;

    public ConversionPlan() {
        final Comparator<String> versionComparator = new Comparator<String>() {
            public int compare(String o1, String o2) {
                final String[] versionSegments1 = o1.split("\\.");
                final String[] versionSegments2 = o2.split("\\.");
                final int length = Math.min(versionSegments1.length, versionSegments2.length);
                // Compare each of the segments.
                for(int i = 0; i < length; i++) {
                    final int result = new Integer(versionSegments1[i]).compareTo(Integer.parseInt(versionSegments2[i]));
                    if(result != 0) {
                        return result;
                    }
                }
                // If all segments were equal, the string that has more segments wins.
                return Integer.valueOf(versionSegments1.length).compareTo(versionSegments2.length);
            }
        };
        versions = new TreeSet<String>(versionComparator);
        directories = new HashMap<String, File>();
        apacheFlags = new HashMap<String, Boolean>();
    }

    public void addVersion(String version, File directory, Boolean apacheFlag) {
        if(!versions.contains(version)) {
            versions.add(version);
            directories.put(version, directory);
            apacheFlags.put(version, apacheFlag);
        }
    }

    public Set<String> getVersionIterator() {
        return versions;
    }

    public File getDirectory(String version) {
        return directories.get(version);
    }

    public Boolean getApacheFlag(String version) {
        return apacheFlags.get(version);
    }

}
