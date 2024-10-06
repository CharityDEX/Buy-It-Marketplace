package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;

/**
 * ThreatenedSpecies model
 */
public class ThreatenedSpecies {
    @JsonProperty
    private String ingredient;
    @JsonSetter
    private int value;

    private String status;
    public void setStatus(final String status) {
        this.status = status;
    }
    @JsonGetter("status")
    public String getStatus() {
        return status;
    }

    @JsonIgnore
    public int getValue() {
        return value;
    }


}
