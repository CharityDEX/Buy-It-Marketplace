package it.eat.back.web.models.off;

/**
 * AgribalyseItem model
 */
public class AgribalyseItem {
    private String name;
    private String value;

    /**
     * class constructor
     * @param name name of AgribalyseItem
     * @param value value of AgribalyseItem
     */
    public AgribalyseItem(final String name, final String value) {
        this.name = name;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public String getValue() {
        return value;
    }
}
