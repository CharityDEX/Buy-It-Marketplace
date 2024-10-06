package it.eat.back.web.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * SignUp model
 */
public class SignUp {
    private final String login;
    private final String email;
    private final String password;

    /**
     * class creator
     * @param login name of user
     * @param email email of user
     * @param password password of user
     */
    @JsonCreator
    public SignUp(
            @JsonProperty("login") final String login,
            @JsonProperty("email") final String email,
            @JsonProperty("password") final String password
    ) {
        this.login = login;
        this.password = password;
        this.email = email;
    }

    public String getLogin() {
        return login.trim();
    }

    public String getPassword() {
        return password.trim();
    }

    public String getEmail() {
        return email.trim();
    }
}
