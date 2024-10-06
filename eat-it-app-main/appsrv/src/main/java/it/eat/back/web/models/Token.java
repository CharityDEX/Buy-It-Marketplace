package it.eat.back.web.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Token model
 */
public class Token {
    private final String accessToken;

    private final String refreshToken;
    /**
     * class constructor
     * @param accessToken string of token
     * @param refreshToken string of refreshToken
     */
    @JsonCreator
    public Token(@JsonProperty("token") final String accessToken, @JsonProperty("refreshToken") final String refreshToken) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }
}
