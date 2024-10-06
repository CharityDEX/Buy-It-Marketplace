package it.eat.back.web.clientOFF;

import it.eat.back.core.service.LocaleService;
import it.eat.back.web.models.off.ProductResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;


/**
 * service to work with Open Food Facts
 */
public class OpenFoodFactsApiLowLevelClient {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private static final String API_URL = "https://world.openfoodfacts.org/api/v2";
    private static final String API_FIELDS = "&fields=ecoscore_data,categories,brands,product_name,quantity";
//    private static final String API_FIELDS = "";
    private RestTemplate restTemplate = new RestTemplateBuilder().setConnectTimeout(Duration.ofSeconds(30))
        .setReadTimeout(Duration.ofSeconds(30)).build();

    /**
     *  get object from Open Food Facts
     * @param code barcode of product
     * @param serverPath url from request
     * @param localeCode locale code
     * @param localeService LocaleService
     * @return object from apy
     */
    public Object fetchProductByCode(final String code,
                                     final String serverPath,
                                     final LocaleService localeService,
                                     final String localeCode) {
        ProductResponse response = restTemplate.getForObject(String.format("%s/product/%s%s", API_URL, code, API_FIELDS),
                ProductResponse.class);
//        if (response.getValid()) {
            response.getProduct().getEcoscoreData().setServerPath(serverPath);
            response.getProduct().getEcoscoreData().setService(localeService, localeCode);
            response.getProduct().setCode(response.getCode());
            return response;
//        }
//        return null;
    }
}
