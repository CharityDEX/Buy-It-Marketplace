package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * ProductResponse model
 */
public class ProductResponse {

    @JsonProperty("product")
    private Product product;

    @JsonProperty("code")
    private String code;

    @JsonProperty("status")
    private boolean status;

    @JsonProperty("status_verbose")
    private String statusVerbose;


    public Product getProduct() {
        return product;
    }

    /**
     * validate product model
     * @return validation success
     */
    public boolean getValid() {
        if ((product.getEcoscoreData().getAdjustment().getProductionSystem() == null) ||
                (product.getEcoscoreData().getAdjustment().getPackaging() == null) ||
                (product.getEcoscoreData().getAdjustment().getOriginsOfIngredients() == null)) {
            return false;
        }
        return true;
    }

    public String getCode() {
        return code;
    }

}
