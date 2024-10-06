package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Missing model
 */
public class Missing {
    @JsonProperty
    private int origins;
    @JsonProperty
    private int packagings;

    public int getOrigins() {
        return origins;
    }

    public int getPackagings() {
        return packagings;
    }
}
