package it.eat.back.web.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.temporal.TemporalAmount;

/**
 * setting class for token create and parsing
 */
@Configuration
public class JwtSettings {
    private final String tokenIssuer;
    private final String tokenSigningKey;
    private final int aTokenDuration;
    private final int refreshTokenDuration;

    /**
     * class constructor
     * @param tokenIssuer user of token creator
     * @param tokenSigningKey passphrase to token signing
     * @param aTokenDuration token generate duration
     * @param refreshTokenDuration refreshtoken generate duration
     */
    public JwtSettings(@Value("${jwt.issuer}") final String tokenIssuer,
                       @Value("${jwt.signingKey}") final String tokenSigningKey,
                       @Value("${jwt.aTokenDuration}") final int aTokenDuration,
                       @Value("${jwt.refreshTokenDuration}") final int refreshTokenDuration) {
        this.tokenIssuer = tokenIssuer;
        this.tokenSigningKey = tokenSigningKey;
        this.aTokenDuration = aTokenDuration;
        this.refreshTokenDuration = refreshTokenDuration;
    }

    public String getTokenIssuer() {
        return tokenIssuer;
    }

    public byte[] getTokenSigningKey() {
        return tokenSigningKey.getBytes(StandardCharsets.UTF_8);
    }

    public TemporalAmount getTokenExpiredIn() {
        return Duration.ofMinutes(aTokenDuration);
    }
    public TemporalAmount getRefreshTokenExpiredIn() {
        return Duration.ofMinutes(refreshTokenDuration);
    }

}
