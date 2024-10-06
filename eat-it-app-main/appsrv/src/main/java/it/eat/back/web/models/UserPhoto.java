package it.eat.back.web.models;

/**
 * UserPhoto model
 */
public class UserPhoto {
    private final byte[] photo;

    /**
     * class constructor
     * @param photo photo in base64
     */
    public UserPhoto(final byte[] photo) {
        this.photo = photo;
    }

    public byte[] getPhoto() {
        return photo;
    }

}
