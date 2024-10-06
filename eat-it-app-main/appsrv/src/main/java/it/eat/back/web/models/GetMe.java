package it.eat.back.web.models;

/**
 * GetMe model
 */
public class GetMe {
    private int sizePhoto;

    /**
     * get size of user photo
     * @return size default 100
     */
    public int getSizePhoto() {
        if (sizePhoto < 1) {
            return 260;
        }
        return sizePhoto;
    }
}
