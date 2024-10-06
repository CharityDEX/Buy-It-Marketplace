package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * OriginsValues model
 */
public class OriginsValues {
    @JsonProperty
    private Integer uk;
    @JsonProperty
    private Integer world;

    public Integer getUk() {
        return uk;
    }

    public Integer getWorld() {
        return world;
    }
}
