package it.eat.back.web.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.eat.back.core.service.LocaleService;
import it.eat.back.web.models.ErrorResponse;
import it.eat.back.web.models.GetProduct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import it.eat.back.web.clientOFF.OpenFoodFactsApiLowLevelClient;
import org.springframework.stereotype.Controller;

/**
 * Product controller
 */
@Controller
public class GetProductController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    private final LocaleService localeService;

    /**
     * class constructor
     * @param localeService LocaleService
     */
    public GetProductController(final LocaleService localeService) {
        this.localeService = localeService;
    }

    /**
     * return information for product from OFF
     * @param requestObject request object
     * @param serverPath string of URL server request
     * @param localeCode locale id
     * @return ProductResponse class
     */
    public ResponseEntity<?> getFromOFF(final Object requestObject, final String serverPath, final String localeCode) {
        GetProduct getProduct = gson.fromJson(gson.toJson(requestObject), GetProduct.class);
        if (getProduct.getCode().isEmpty()) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        try {
            OpenFoodFactsApiLowLevelClient openFoodFactsApiLowLevelClient = new OpenFoodFactsApiLowLevelClient();
            Object productResponse = openFoodFactsApiLowLevelClient.fetchProductByCode(getProduct.getCode(),
                    serverPath, localeService, localeCode);
            if (productResponse == null) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
            return ResponseEntity.ok(productResponse);
        } catch (Exception e) {
            logger.error(e.toString());
            return new ResponseEntity<>(new ErrorResponse("", ""), HttpStatus.BAD_REQUEST);
        }

    }
}
