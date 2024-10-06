package it.eat.back.web.models;

/**
 * new password request object
 */
public class NewPassword {
    private String login;
    private String password;
    private String code;

    /**
     * class cobstructor
     * @param login login of user
     * @param password password of user
     * @param code verify code
     */
    public NewPassword(final String login, final String password, final String code) {
        this.login = login;
        this.password = password;
        this.code = code;
    }

    public String getLogin() {
        return login.trim();
    }

    public String getPassword() {
        return password.trim();
    }

    public String getCode() {
        return code;
    }
}
