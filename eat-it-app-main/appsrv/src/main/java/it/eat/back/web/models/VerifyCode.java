package it.eat.back.web.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * SignUp model
 */
public class VerifyCode {
    private final String login;
    private final String email;

    private final String password;

    private final String code;

    /**
     * class creator
     * @param login name of user
     * @param email email of user
     * @param password password of user
     * @param code verifyCode of user
     */
    @JsonCreator
    public VerifyCode(
            @JsonProperty("login") final String login,
            @JsonProperty("email") final String email,
            @JsonProperty("password") final String password,
            @JsonProperty("code") final String code
    ) {
        this.login = login;
        this.password = password;
        this.code = code;
        this.email = email;
    }

    public String getLogin() {
        return login.trim();
    }

    public String getEmail() {
        return email.trim();
    }

    public String getCode() {
        return code;
    }

    public String getPassword() {
        return password.trim();
    }
}
