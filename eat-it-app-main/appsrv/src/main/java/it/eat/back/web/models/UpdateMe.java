package it.eat.back.web.models;

import it.eat.back.core.internal.ImageResize;
import org.apache.tomcat.util.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * UpdateNe model
 */
public class UpdateMe {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final String userName;
    private final String userText;
    private final String photo;

    /**
     * class constructor
     * @param userName name of user
     * @param userText discription of user
     * @param photo photo of user
     */
    public UpdateMe(final String userName, final String userText, final String photo) {
        this.userName = userName;
        this.userText = userText;
        this.photo = photo;
    }

    public String getUserName() {
        return userName.trim();
    }

    public String getUserText() {
        return userText;
    }

    /**
     * get user photo from update request
     * @return byte[] photo with size 130
     */
    public byte[] getPhoto() {
        try {
            if (photo == null) {
                return null;
            }
            return new ImageResize().imageResize(Base64.decodeBase64(photo), 520);
//            new ImageResize().imageResize(Base64.decodeBase64(photo), 260);
//            return Base64.decodeBase64(photo);
        } catch (IOException e) {
            logger.error(e.getMessage());
            return null;
        }
    }
}
