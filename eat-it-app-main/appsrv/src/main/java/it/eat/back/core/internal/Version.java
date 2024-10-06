package it.eat.back.core.internal;

/**
 * Version comparator
 */
public class Version implements Comparable {
    private String versionString;

    /**
     * class constructor
     * @param versionString version on string
     */
    public Version(final String versionString) {
        this.versionString = versionString;
    }

    @Override
    public int compareTo(final Object o) {
        String strCompare = (String) o;
        String[] leftList = versionString.split("\\.");
        String[] rightList = strCompare.split("\\.");
        for (int i = 0; i < leftList.length; i++) {
            if (i == rightList.length) {
                return -1;
            }
            if (leftList[i].compareTo(rightList[i]) != 0) {
                return Integer.valueOf(leftList[i]).compareTo(Integer.valueOf(rightList[i]));
            }
        }
        if (leftList.length < rightList.length) {
            return 1;
        }
        return 0;
    }

    @Override
    public String toString() {
        return versionString;
    }
}
