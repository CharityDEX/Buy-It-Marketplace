package it.eat.back.web.models;

/**
 * User model
 */
public class User {
    private final String email;
    private final String userName;
    private final String userText;

    private final int points;
    /**
     * class constructor
     * @param email user email
     * @param userName user name
     * @param userText discription of user
     * @param points point of user
     */
    public User(final String email, final String userName, final String userText, final int points) {
        this.email = email;
        this.userName = userName;
        this.userText = userText;
        this.points = points;
    }

    public String getEmail() {
        return email.trim();
    }

    public String getUserName() {
        return userName.trim();
    }

    public String getUserText() {
        return userText;
    }

    public int getPoints() {
        return points;
    }
}
