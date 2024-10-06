package it.eat.back.core.models;

import java.util.UUID;

/**
 * User model for database
 */
public class UserDB {
    private final int userId;
    private final String userUID;
    private final String email;
    private final String userName;
    private String password;
    private final int points;

    private final String userText;
    private byte[] photo;

    /**
     * Object constructor
     * @param email email of user
     * @param password password of user
     * @param photo user photo
     * @param userId id of user
     * @param userUID user UUID from token
     * @param userName name of user
     * @param userText discription of user
     * @param points points of user
     */
    public UserDB(final int userId, final String userUID, final String email, final String userName, final String password,
                  final String userText, final byte[] photo, final int points) {
        this.userId = userId;
        this.userUID = userUID.length() == 0 ? UUID.randomUUID().toString() : userUID;
        this.email = email;
        this.userName = userName;
        this.password = password;
        this.photo = photo;
        this.userText = userText;
        this.points = points;
    }

    /**
     * object constructor for token service
     * @param userUID id of user
     */
    public UserDB(final String userUID) {
        userId = 0;
        this.userUID = userUID;
        this.points = 0;
        this.userText = null;
        this.userName = null;
        this.email = null;
        this.password = null;
    }

    public String getUserName() {
        return userName;
    }

    public String getPassword() {
        return password;
    }

    public String getUserUID() {
        return userUID;
    }

    public int getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }
    public byte[] getPhoto() {
        return photo;
    }

    public String getUserText() {
        return userText;
    }

    public int getPoints() {
        return points;
    }

    public void setPassword(final String password) {
        this.password = password;
    }
}
