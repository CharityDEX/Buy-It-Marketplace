package it.eat.back.web.security;

import it.eat.back.core.models.UserDB;

import java.util.Date;

/**
 * interface to create and parsing token
 */
public interface JwtTokenService {
    /**
     * Parses the token
     * @param token the token string to parse
     * @return authenticated data
     */
    UserCredentials parseToken(String token);

    /**
     * Creates new Token for user.
     * @param user contains User to be represented as token
     * @return signed token
     */
    String createToken(UserDB user);

    /**
     * Create new refresh token
     * @param user User object
     * @return String of new token
     */
    String createRefreshToken(UserDB user);

    /**
     * get date of expire token
     * @param token token string
     * @return date
     */
    Date dateExpired(String token);
}
