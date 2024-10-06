package it.eat.back.web.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.eat.back.core.models.UserDB;
import it.eat.back.core.service.LocaleService;
import it.eat.back.core.service.TokenService;
import it.eat.back.core.service.UserService;
import it.eat.back.web.models.Attempt;
import it.eat.back.web.models.ErrorResponse;
import it.eat.back.web.models.Login;
import it.eat.back.web.models.NewPassword;
import it.eat.back.web.models.OkResponse;
import it.eat.back.web.models.SignUp;
import it.eat.back.web.models.Token;
import it.eat.back.web.models.VerifyCode;
import it.eat.back.web.security.JwtTokenService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import java.util.Date;

/**
 * Login SignUp controller
 */
@Controller
public class LoginController {
    private final JwtTokenService tokenService;
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    private final TokenService dbTokenService;

    private final UserService userService;

    private final LocaleService localeService;

    /**
     * class creator
     * @param tokenService token create service
     * @param dbTokenService database token service
     * @param userService database user service
     * @param localeService  LocaleService
     */
    public LoginController(final JwtTokenService tokenService,
                           final TokenService dbTokenService, final UserService userService,
                           final LocaleService localeService) {
        this.tokenService = tokenService;
        this.dbTokenService = dbTokenService;
        this.userService = userService;
        this.localeService = localeService;
    }


    /**
     * login user and create new token for user
     * @param requestObject request from client
     * @param localeCode locale
     * @return Token object
     */
    public ResponseEntity<?> login(final Object requestObject, final String localeCode) {
        Login login = gson.fromJson(gson.toJson(requestObject), Login.class);
        UserDB user = null;
        if (login.getLogin() != null) {
            user = userService.getUserByLogin(login.getLogin(), login.getPassword());
        }
        if (user == null) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                    localeService.getTextByCode(localeCode, "err:m:user_not_found")), HttpStatus.UNAUTHORIZED);
        }
        String token = tokenService.createToken(user);
        String refreshToken = tokenService.createRefreshToken(user);
        Date date = tokenService.dateExpired(refreshToken);
        dbTokenService.setToken(user.getUserUID(), token, refreshToken, date);
        return ResponseEntity.ok(new Token(token, refreshToken));
    }

    /**
     * Logout user
     * @param userId user id from token
     * @param token token of user
     * @param localeCode locale
     * @return status logout
     */
    public ResponseEntity<?> logout(final String userId, final String token, final String localeCode) {
        try {
            dbTokenService.deleteToken(userId, token);
            return ResponseEntity.ok(new OkResponse("Ok"));
        } catch (Exception e) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                    localeService.getTextByCode(localeCode, "err:m:user_not_found")), HttpStatus.NOT_FOUND);
        }
    }

    /**
     * get pair token by refreshToken
     * @param userId id os user
     * @param currentToken current refreshToken
     * @param localeCode locale
     * @return Response
     */
    public ResponseEntity<?> refreshToken(final String userId, final String currentToken, final String localeCode) {
        try {
            UserDB user = new UserDB(userId);
            String token = tokenService.createToken(user);
            String refreshToken = tokenService.createRefreshToken(user);
            Date date = tokenService.dateExpired(refreshToken);
            if (!dbTokenService.setUpdateToken(user.getUserUID(), currentToken, token, refreshToken, date)) {
                return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                        localeService.getTextByCode(localeCode, "err:m:user_auth")), HttpStatus.UNAUTHORIZED);
            }
            return ResponseEntity.ok(new Token(token, refreshToken));
        } catch (Exception e) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                    localeService.getTextByCode(localeCode, "err:m:user_other")), HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * get request for singUp
     * @param requestObject request from front
     * @param localeCode locale
     * @return response status
     */
    public ResponseEntity<?> signUp(final Object requestObject, final String localeCode) {
        try {
            SignUp signUp = gson.fromJson(gson.toJson(requestObject), SignUp.class);
            if (userService.isValidNewUser(signUp)) {
                return new ResponseEntity<>(new OkResponse("Ok"), HttpStatus.OK);
            } else {
                return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username_err"),
                        localeService.getTextByCode(localeCode, "err:m:username")), HttpStatus.PRECONDITION_FAILED);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username_err"),
                    localeService.getTextByCode(localeCode, "err:m:user_other")), HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * check verify code
     * @param requestObject request with code from front
     * @param localeCode locale
     * @return status response
     */
    public ResponseEntity<?> verifyCode(final Object requestObject, final String localeCode) {
        try {
            VerifyCode verifyCode = gson.fromJson(gson.toJson(requestObject), VerifyCode.class);
            if (userService.isValidCodeNewUser(verifyCode)) {
                userService.addNewUser(verifyCode);
                return login(verifyCode, localeCode);
//                return new ResponseEntity(new OkResponse("Ok"), HttpStatus.OK);
            } else {
                int attempt = userService.decreaseAttemptNewUser(verifyCode);
                if (attempt > 0) {
                    return new ResponseEntity<>(new Attempt("Code is not valid", attempt), HttpStatus.BAD_REQUEST);
                } else {
                    return new ResponseEntity<>(new Attempt("Code is not valid. Attempt count is 0", attempt), HttpStatus.BAD_REQUEST);
                }
            }
        } catch (Exception e) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                    localeService.getTextByCode(localeCode, "err:m:user_other")), HttpStatus.BAD_REQUEST);

        }
    }

    /**
     * Restore password request
     * @param requestObject request from front
     * @param localeCode locale
     * @return status request
     */
    public ResponseEntity<?> restorePassword(final Object requestObject, final String localeCode) {
        try {
            NewPassword newPassword = gson.fromJson(gson.toJson(requestObject), NewPassword.class);
            userService.restorePassword(newPassword);
            return new ResponseEntity<>(new OkResponse("Ok"), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                    localeService.getTextByCode(localeCode, "err:m:user_other")), HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * check verify code to restore
     * @param requestObject request from front
     * @param localeCode locale
     * @return status
     */
    public ResponseEntity<?> restoreVerifyCode(final Object requestObject, final String localeCode) {
        try {
            NewPassword newPassword = gson.fromJson(gson.toJson(requestObject), NewPassword.class);
            if (userService.isValidRestore(newPassword)) {
//                userService.setNewPassword(newPassword);
                return new ResponseEntity<>(new OkResponse("Ok"), HttpStatus.OK);
            } else {
                int attempt = userService.decreaseAttemptRestore(newPassword);
                if (attempt > 0) {
                    return new ResponseEntity<>(new Attempt("Code is not valid", attempt), HttpStatus.BAD_REQUEST);
                } else {
                    return new ResponseEntity<>(new Attempt("Code is not valid. Attempt count is 0", attempt), HttpStatus.BAD_REQUEST);
                }
            }
        } catch (Exception e) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                    localeService.getTextByCode(localeCode, "err:m:user_other")), HttpStatus.BAD_REQUEST);

        }
    }

    /**
     * Set new password
     * @param requestObject requesy from front
     * @param localeCode locale
     * @return response
     */
    public ResponseEntity<?> setNewPassword(final Object requestObject, final String localeCode) {
        try {
            NewPassword newPassword = gson.fromJson(gson.toJson(requestObject), NewPassword.class);
            if (userService.isValidRestore(newPassword)) {
                userService.setNewPassword(newPassword);
                return login(newPassword, localeCode);
//                return new ResponseEntity(new OkResponse("Ok"), HttpStatus.OK);
            } else {
                int attempt = userService.decreaseAttemptRestore(newPassword);
                if (attempt > 0) {
                    return new ResponseEntity<>(new Attempt("Code is not valid", attempt), HttpStatus.BAD_REQUEST);
                } else {
                    return new ResponseEntity<>(new Attempt("Code is not valid. Attempt count is 0", attempt), HttpStatus.BAD_REQUEST);
                }
            }
        } catch (Exception e) {
            return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode, "err:t:username"),
                    localeService.getTextByCode(localeCode, "err:m:user_other")), HttpStatus.BAD_REQUEST);

        }
    }
}
