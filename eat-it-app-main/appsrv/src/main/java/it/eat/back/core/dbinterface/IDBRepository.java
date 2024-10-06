package it.eat.back.core.dbinterface;

import it.eat.back.core.models.Locales;
import it.eat.back.core.models.PurchaseDB;
import it.eat.back.core.models.UserDB;
import it.eat.back.web.models.LeaderItem;
import it.eat.back.web.models.SignUp;
import it.eat.back.web.models.VerifyCode;

import java.util.ArrayList;
import java.util.Date;

/**
 * Interface to database
 */
public interface IDBRepository {

    /**
     * set purchase into database
     * @param purchaseDB list of purchaseItem
     * @return status insert
     */
    boolean setPurchase(PurchaseDB purchaseDB);

    /**
     * get user by id
     * @param userUID user UUID
     * @return User object
     */
    UserDB getUser(String userUID);

    /**
     * update user info in database
     * @param user UserDB object
     */
    void updateUser(UserDB user);

    /**
     * get user position
     * @param userId user id
     * @return user position
     */
    int getUserPosition(int userId);

    /**
     * return leader
     * @param count list count
     * @return list of leaders
     */
    ArrayList<LeaderItem> getLeader(int count);

    /**
     * get text by id and locale
     * @param localeCode locale id
     * @return text by id
     */
    ArrayList<Locales> getLocaleText(String localeCode);

    /**
     * Get all locales
     * @return list of locales
     */
    ArrayList<String> getLocales();
    /**
     * Check user by name and password
     * @param userName user name
     * @param password user password
     * @return UserDB object
     */
    UserDB checkUserByName(String userName, String password);

    /**
     * Check user by email and password
     * @param email user email
     * @param password user password
     * @return UserDB object
     */
    UserDB checkUserByEmail(String email, String password);

    /**
     * insert token to database
     * @param userId user id
     * @param token user token
     * @param refreshToken refreshToken of user
     * @param expired token expired
     */
    void setToken(String userId, String token, String refreshToken, Date expired);

    /**
     * delete all expirations token
     */
    void deleteOldTokens();

    /**
     * delete all token by user
     * @param userId user id
     */
    void deleteTokensByUser(String userId);

    /**
     * delete all token by user
     * @param userId id of user
     * @param token string token
     */
    void deleteToken(String userId, String token);

    /**
     * delete refreshToken from database
     * @param userId id of user
     * @param refreshToken refreshToken of user
     */
    void deleteRefreshToken(String userId, String refreshToken);

    /**
     * get user by token
     * @param token token string
     * @return userId if token valid or null if token deleted
     */
    /**
     * get user by token
     * @param token token of user
     * @return id of user
     */
    String getUserUIDByToken(String token);

    /**
     * get user by refreshToken
     * @param refreshToken refreshToken of user
     * @return id of user
     */
    String getUserUIDByRefreshToken(String refreshToken);

    /**
     * check user by name of create
     * @param signUp new user model
     * @return true if user exists
     */
    boolean checkUserByName(SignUp signUp);

    /**
     * check user by name or email in newUserTable of create
     * @param signUp new user model
     * @return true if user exists
     */
    boolean checkNewUserByName(SignUp signUp);

    /**
     * check user by email in UserTable of create
     * @param signUp new user model
     * @return true if user exists
     */
    UserDB checkUserByEmail(SignUp signUp);

    /**
     * delete od records in NewUserTable
     * @param hours count hours before delete
     */
    void deleteOldRegistrationRequest(int hours);

    /**
     * Add new user in usersNew table
     * @param signUp new user
     * @param verifyCode code in email
     * @param attemptCount count of attempt
     */
    void addUserToNewList(SignUp signUp, String verifyCode, int attemptCount);

    /**
     * check validation code for user
     * @param verifyCode new user with code
     * @return status validation
     */
    boolean isValidCode(VerifyCode verifyCode);

    /**
     * create UserDB object from usersNew table for current new user
     * @param verifyCode New user object
     * @return UserDB object
     */
    UserDB getNewUser(VerifyCode verifyCode);

    /**
     * add new user into users table
     * @param userDB UserDB object
     */
    void addUser(UserDB userDB);

    /**
     * delete user from userNew table
     * @param email email of new user
     */
    void deleteNewUserByEmail(String email);

    /**
     * get attempt count for current user
     * @param verifyCode user with code
     * @return attemp count for user
     */
    int getAttempt(VerifyCode verifyCode);

    /**
     * set attempt count for user
     * @param verifyCode user with code
     * @param attempt new attempt value
     */
    void setAttempt(VerifyCode verifyCode, int attempt);

    /**
     * get user for restore by login
     * @param login login user
     * @return UserDB object
     */
    UserDB getUserForRestore(String login);

    /**
     * delete restore code for user
     * @param userId id of user
     */
    void deleteRestore(int userId);

    /**
     * add to user restore password table
     * @param userId id of user
     * @param verifyCode code to restore
     * @param attemptCount attempts
     */
    void addUserToRestore(int userId, String verifyCode, int attemptCount);

    /**
     * delete all restore request after time
     * @param validHours time do delete
     */
    void deleteOldRestoreRequest(int validHours);

    /**
     * check restore code for user
     * @param userId id of user
     * @param code restore code
     * @return status
     */
    boolean isValidRestoreCode(int userId, String code);

    /**
     * get restore attempt of user
     * @param userId id of user
     * @return attempt
     */
    int getRestoreAttempt(int userId);

    /**
     * set new restore password attempt
     * @param userId id of user
     * @param attempt new attempt
     */
    void setRestoreAttempt(int userId, int attempt);

    /**
     * set new password in database
     * @param userDB User object
     */
    void setPassword(UserDB userDB);

    /**
     * chech new user params with existing users
     * @param userDB user object
     * @return status check
     */
    boolean checkWithAnotherUser(UserDB userDB);

    /**
     * delete purchases by user
     * @param userId id of user
     */
    void deleteUserPurchases(int userId);

    /**
     * delete user
     * @param userId id of user
     */
    void deleteUser(int userId);
}
