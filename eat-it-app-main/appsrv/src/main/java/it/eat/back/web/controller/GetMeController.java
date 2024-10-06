package it.eat.back.web.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.eat.back.core.models.UserDB;
import it.eat.back.core.service.LocaleService;
import it.eat.back.core.service.UserService;
import it.eat.back.web.models.ErrorResponse;
import it.eat.back.web.models.GetMe;
import it.eat.back.web.models.OkResponse;
import it.eat.back.web.models.Position;
import it.eat.back.web.models.UpdateMe;
import it.eat.back.web.models.User;
import it.eat.back.web.models.UserPhoto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;


/**
 * Me controller
 */
@Controller
public class GetMeController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
    private final UserService userService;
    private final LocaleService localeService;


    /**
     * class constructor
     * @param userService UserService
     * @param localeService locale
     */
    public GetMeController(final UserService userService,
                           final LocaleService localeService) {
        this.userService = userService;
        this.localeService = localeService;
    }

    /**
     * return current user information
     * @param userUID current user UID
     * @return User object
     */
    public ResponseEntity<?> getMe(final String userUID) {

        try {
            UserDB userDB = userService.getMe(userUID);
            User user = new User(userDB.getEmail(), userDB.getUserName(), userDB.getUserText(), userDB.getPoints());
            return new ResponseEntity<>(user, HttpStatus.OK);
        } catch (Exception e) {
//            e.printStackTrace();
            logger.error(e.toString());
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * return photo in base64 for current user
     * @param requestObject request from front
     * @param userUID current user UID
     * @return base64 resized photo
     */
    public ResponseEntity<?> getMePhoto(final Object requestObject, final String userUID) {
        GetMe getMe = gson.fromJson(gson.toJson(requestObject), GetMe.class);

        try {
            UserDB userDB = userService.getMe(userUID);
//            UserPhoto userPhoto = new UserPhoto(new ImageResize().imageResize(userDB.getPhoto(), getMe.getSizePhoto()));
            UserPhoto userPhoto = new UserPhoto(userDB.getPhoto());

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);

            return new ResponseEntity<>(userPhoto, HttpStatus.OK);
//            return new ResponseEntity(userPhoto.getPhoto(), headers, HttpStatus.OK);
        } catch (Exception e) {
//            e.printStackTrace();
            logger.error(e.toString());
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * return position in leaderboard
     * @param userUID user UID
     * @return user position
     */
    public ResponseEntity<?> getMePosition(final String userUID) {

        try {
            Position position = new Position(userService.getMePosition(userUID));
            return new ResponseEntity<>(position, HttpStatus.OK);
        } catch (Exception e) {
//            e.printStackTrace();
            logger.error(e.toString());
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * update user information
     * @param requestObject request params
     * @param userUID user UID
     * @param localeCode Locale
     * @return status
     */
    public ResponseEntity<?> updateMe(final Object requestObject, final String userUID, final String localeCode) {
        UpdateMe updateMe = gson.fromJson(gson.toJson(requestObject), UpdateMe.class);
        try {
            UserDB userDB = userService.getMe(userUID);
            String userName = updateMe.getUserName() == null ? userDB.getUserName() : updateMe.getUserName();
            String userText = updateMe.getUserText() == null ? userDB.getUserText() : updateMe.getUserText();
            if (!userService.isValidUserParams(userDB, false)) {
                return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username_err"),
                        localeService.getTextByCode(localeCode, "err:m:username_err")), HttpStatus.NOT_ACCEPTABLE);
            }
            byte[] photo = updateMe.getPhoto() == null ? userDB.getPhoto() : updateMe.getPhoto();
            UserDB userDBNew = new UserDB(userDB.getUserId(), userUID, userDB.getEmail(), userName, "", userText, photo, 0);
            if (userService.updateMe(userDBNew)) {
                return new ResponseEntity<>(new OkResponse("Ok"), HttpStatus.OK);
            }
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username_err"),
                    localeService.getTextByCode(localeCode, "err:m:username")), HttpStatus.BAD_REQUEST);

        } catch (Exception e) {
//            e.printStackTrace();
            logger.error(e.toString());
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * delete current user
     * @param userUID UUID of user
     * @return status
     */
    public ResponseEntity<?> deleteMe(final String userUID) {
        try {
            UserDB userDB = userService.getMe(userUID);
            if (userDB == null) {
                return new ResponseEntity<>(new ErrorResponse("Unauthorized", "User unauthorized"),
                        HttpStatus.UNAUTHORIZED);
            }
            if (userService.deleteMe(userDB)) {
                return new ResponseEntity<>(new OkResponse("Ok"), HttpStatus.OK);
            }
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
//            e.printStackTrace();
            logger.error(e.toString());
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
}
