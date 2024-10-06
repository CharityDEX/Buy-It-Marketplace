package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * OriginsOfIngredients model
 */
public class OriginsOfIngredients {
    @JsonProperty("value")
    private int value;

    @JsonProperty("values")
    private OriginsValues originsValues;

    private String status;

    public void setStatus(final String status) {
        this.status = status;
    }
    @JsonGetter("status")
    public String getStatus() {
        return status;
    }


    /**
     * evaluate value
     * @return value from values.uk or values.world or value
     */
    @JsonIgnore
    public int getValue() {
        if (originsValues.getUk() != null) {
            return originsValues.getUk();
        }
        if (originsValues.getWorld() != null) {
            return originsValues.getWorld();
        }
        return value;
    }

}
