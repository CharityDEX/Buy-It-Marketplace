package it.eat.back.core.service;

import it.eat.back.core.dbinterface.IDBRepository;
import it.eat.back.core.models.Locales;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * locale model
 */
@Service
public class LocaleService {

    private IDBRepository repository;
    private Map<String, Map<String, String>> localeMap = new HashMap<>();

    /**
     * class constructor
     * @param repository database repository
     */
    public LocaleService(final IDBRepository repository) {
        this.repository = repository;
        ArrayList<String> locales = repository.getLocales();
        for (String localeCode: locales) {
            ArrayList<Locales> localesArrayList = repository.getLocaleText(localeCode);
            Map<String, String> localeText = new HashMap<>();
            if (localesArrayList != null) {
                for (Locales locale : localesArrayList) {
                    localeText.put(locale.getId(), locale.getLocaleText());
                }
            }
            localeMap.put(localeCode, localeText);
        }
    }
    //    public LocaleService(final IDBRepository repository, final String localeCode) {
//        ArrayList<Locales> localesArrayList = repository.getLocaleText(localeCode);
//        if (localesArrayList != null) {
//            for (Locales locales : localesArrayList) {
//                localeMap.put(locales.getId(), locales.getLocaleText());
//            }
//        }
//    }

    /**
     * get text to front by textId
     * @param id id of text
     * @param localeCode locale
     * @return text by locale and id
     */
    public String getTextByCode(final String localeCode, final String id) {
        if (localeMap.containsKey(localeCode)) {
            if (localeMap.get(localeCode).containsKey(id)) {
                return localeMap.get(localeCode).get(id);
            }
        } else if (localeMap.containsKey("_default")) {
            if (localeMap.get("_default").containsKey(id)) {
                return localeMap.get("_default").get(id);
            }
        }
        return id;
    }
}
