package it.eat.back.web.security;

import it.eat.back.core.service.TokenService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.lang.NonNull;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;

/**
 * HandlerInterceptor implementation
 */
public class JwtAuthInterceptor  implements HandlerInterceptor {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final String userCredentials = "userCredentialsAttr";

    private final JwtTokenService jwtService;

    private final TokenService tokenService;

    /**
     * class constructor
     * @param jwtService Token Service
     * @param tokenService Database Token service
     */
    public JwtAuthInterceptor(
            final JwtTokenService jwtService,
            final TokenService tokenService
    ) {
        this.jwtService = jwtService;
        this.tokenService = tokenService;
    }

    @Override
    public boolean preHandle(@NonNull final HttpServletRequest request,
                             @NonNull final HttpServletResponse response,
                             @NonNull final Object handler) {
        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            Method method = handlerMethod.getMethod();
            return checkAuthorization(method, request, response);
        }
        return true;
    }

    private UserCredentials getUserCredentials(final HttpServletRequest request) {
        try {
            String header = request.getHeader(HttpHeaders.AUTHORIZATION);
//            logger.debug(header);
            if (header == null || !header.startsWith("Bearer ")) {
                return null;
            }

            String token = header.substring(7);
            if (!tokenService.isValidToken(token)) {
                return null;
            }
            UserCredentials credentials = jwtService.parseToken(token);
            logger.debug("Found credentials in Authorization header: {}", credentials.getUserId());
            request.setAttribute(userCredentials, credentials);

            return credentials;
        } catch (Exception e) {
            return null;
        }
    }

    public String getUserCredentials() {
        return userCredentials;
    }

    private boolean checkAuthorization(
            final Method method,
            final HttpServletRequest request,
            final HttpServletResponse response
    ) {
        try {
            UserCredentials userCredentials = getUserCredentials(request);

//            if (method.isAnnotationPresent(AuthRoleRequired.class)) {
//                if (userCredentials == null) {
//                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
//                    return false;
//                }
//                AuthRoleRequired annotation = method.getAnnotation(AuthRoleRequired.class);
//                String requiredRole = annotation.value();
//                Set<String> userRoles = new HashSet<>();
//                boolean isAuthorized = userRoles.contains(requiredRole);
//                if (!isAuthorized) {
//                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Not enough permissions");
//                    return false;
//                }
//            }

            return true;
        } catch (Exception e) {
            return false;
        }

    }
}
