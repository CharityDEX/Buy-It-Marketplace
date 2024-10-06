package it.eat.back.core.service;

import it.eat.back.core.dbinterface.IDBRepository;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * Database token service
 */
@Service
public class TokenService {
    private IDBRepository repository;

    /**
     * class constructor
     * @param repository Database repository
     */
    public TokenService(final IDBRepository repository) {
        this.repository = repository;
    }

    /**
     * Check is token contains in db
     * @param token string token
     * @return check result
     */
    public boolean isValidToken(final String token) {
        String userId = repository.getUserUIDByToken(token);
        if (userId == null) {
            userId = repository.getUserUIDByRefreshToken(token);
        }
        return (userId != null);
    }

    /**
     * Delete token on logout
     * @param userUID UID of user
     * @param token token string
     */
    public void deleteToken(final String userUID, final String token) {
        repository.deleteToken(userUID, token);
        repository.deleteOldTokens();
    }

    /**
     * insert token into db
     * @param userUID UID of user
     * @param token token of user
     * @param refreshToken refreshToken of user
     * @param date efresh token expired of user
     */
    public void setToken(final String userUID, final String token, final String refreshToken, final Date date) {
        repository.setToken(userUID, token, refreshToken, date);
        repository.deleteOldTokens();
    }

    /**
     * Update token in DB
     * @param userUID UID of user
     * @param currentToken old user id
     * @param token new token of user
     * @param refreshToken new refreshToken of user
     * @param date refresh token expired of user
     * @return status update
     */
    public boolean setUpdateToken(final String userUID, final String currentToken,
                                  final String token, final String refreshToken, final Date date) {
        if (repository.getUserUIDByRefreshToken(currentToken) != null) {
            repository.setToken(userUID, token, refreshToken, date);
            repository.deleteRefreshToken(userUID, currentToken);
            repository.deleteOldTokens();
            return true;
        }
        return false;
    }
}
