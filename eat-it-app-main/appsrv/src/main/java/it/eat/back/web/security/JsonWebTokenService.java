package it.eat.back.web.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import it.eat.back.core.models.UserDB;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Configuration;

import java.time.Instant;
import java.util.Date;

/**
 * JwtTokenService implementation
 */
@Configuration
public class JsonWebTokenService  implements JwtTokenService {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final JwtSettings settings;

    /**
     * class constructor
     * @param settings setting to create and parsing token
     */
    public JsonWebTokenService(final JwtSettings settings) {
        this.settings = settings;
    }

    @Override
    public String createToken(final UserDB user) {
        logger.debug("Generating token for {}", user.getUserId());

        Instant now = Instant.now();

        Claims claims = Jwts.claims()
                .setIssuer(settings.getTokenIssuer())
                .setIssuedAt(Date.from(now))
                .setSubject(user.getUserUID())
                .setExpiration(Date.from(now.plus(settings.getTokenExpiredIn())));
//        claims.put(EMAIL, user.getEmail());
//        System.out.println(settings.getRefreshTokenExpiredIn());

        return Jwts.builder()
                .setClaims(claims)
                .signWith(SignatureAlgorithm.HS512, settings.getTokenSigningKey())
                .compact();
    }

    @Override
    public String createRefreshToken(final UserDB user) {
        logger.debug("Generating refresh token for {}", user.getUserId());

        Instant now = Instant.now();

        Claims claims = Jwts.claims()
                .setIssuer(settings.getTokenIssuer())
                .setIssuedAt(Date.from(now))
                .setSubject(user.getUserUID())
                .setExpiration(Date.from(now.plus(settings.getRefreshTokenExpiredIn())));
//        claims.put(EMAIL, user.getEmail());

        return Jwts.builder()
                .setClaims(claims)
                .signWith(SignatureAlgorithm.HS512, settings.getTokenSigningKey())
                .compact();    }

    @Override
    public Date dateExpired(final String token) {
        Jws<Claims> claims = Jwts.parser().setSigningKey(settings.getTokenSigningKey()).parseClaimsJws(token);
        return (claims.getBody().getExpiration());
    }

    @Override
    @SuppressWarnings("unchecked")
    public UserCredentials parseToken(final String token) {
//        logger.debug("Parsing token {}", token);

        Jws<Claims> claims = Jwts.parser().setSigningKey(settings.getTokenSigningKey()).parseClaimsJws(token);

        String subject = claims.getBody().getSubject();

        return new UserCredentialsImpl(subject);
    }

}
