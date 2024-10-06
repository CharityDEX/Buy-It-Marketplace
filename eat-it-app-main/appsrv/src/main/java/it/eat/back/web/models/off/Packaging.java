package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Packaging model
 */
public class Packaging {
    @JsonProperty("score")
    private int score;
    @JsonProperty("value")
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
