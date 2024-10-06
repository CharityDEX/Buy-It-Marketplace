package it.eat.back.web.security;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;


/**
 * UserCredentials implementation
 */
public class UserCredentialsImpl  implements UserCredentials {

    @JsonProperty("userId")
    private final String userId;

    /**
     * class constructor
     * @param userId id of user
     */
    @JsonCreator
    public UserCredentialsImpl(final String userId) {
        this.userId = userId;
    }

    public String getUserId() {
        return userId;
    }

}
