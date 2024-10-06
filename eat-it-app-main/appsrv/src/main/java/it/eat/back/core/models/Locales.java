package it.eat.back.core.models;

/**
 * Locales model
 */
public class Locales {
    private String id;
    private String localeText;

    /**
     * class constructor
     * @param id id text
     * @param localeText localized text
     */
    public Locales(final String id, final String localeText) {
        this.id = id;
        this.localeText = localeText;
    }

    public String getId() {
        return id;
    }


    public String getLocaleText() {
        return localeText;
    }
}
