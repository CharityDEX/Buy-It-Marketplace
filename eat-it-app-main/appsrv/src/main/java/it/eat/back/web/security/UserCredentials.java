package it.eat.back.web.security;


/**
 * Token information interface
 */
public interface UserCredentials {
    /**
     * get user id from token
     * @return user id
     */
    String getUserId();

}
