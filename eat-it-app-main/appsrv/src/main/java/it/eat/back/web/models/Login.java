package it.eat.back.web.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * login model
 */
public class Login {
    private final String login;
    private final String password;

    /**
     * class creator
     * @param login email or name of user
     * @param password password of user
     */
    @JsonCreator
    public Login(
            @JsonProperty("login") final String login,
            @JsonProperty("password") final String password
    ) {
        this.login = login;
        this.password = password;
    }

    public String getLogin() {
        return login.trim();
    }

    public String getPassword() {
        return password.trim();
    }
}
