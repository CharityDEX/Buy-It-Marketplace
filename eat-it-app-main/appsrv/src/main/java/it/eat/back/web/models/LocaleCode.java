package it.eat.back.web.models;

/**
 * LocaleCode model
 */
public class LocaleCode {
    private String locale;

    /**
     * get locale from request
     * @return get locale from response
     */
    public String getLocale() {
        if ((locale == null) || (locale.length() == 0)) {
            return "_default";
        }
        return locale;
    }
}
