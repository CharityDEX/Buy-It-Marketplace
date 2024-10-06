package it.eat.back.config;

import it.eat.back.core.service.TokenService;
import it.eat.back.web.security.JwtAuthInterceptor;
import it.eat.back.web.security.JwtTokenService;
import it.eat.back.web.security.UserCredentialsResolver;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

/**
 * Web configuration for project
 */
@Configuration
public class WebConfiguration implements WebMvcConfigurer {

    private final JwtTokenService jwtTokenService;
    private final TokenService tokenService;

    /**
     * class constructor
     * @param jwtTokenService JwtTokenService object
     * @param tokenService TokenService object
     */
    public WebConfiguration(
            final JwtTokenService jwtTokenService,
            final TokenService tokenService
    ) {
        this.jwtTokenService = jwtTokenService;
        this.tokenService = tokenService;
    }


    @Override
    public void addArgumentResolvers(final List<HandlerMethodArgumentResolver> argumentResolvers) {
        argumentResolvers.add(new UserCredentialsResolver());
    }

    @Override
    public void addInterceptors(final InterceptorRegistry registry) {
        registry.addInterceptor(
                new JwtAuthInterceptor(jwtTokenService, tokenService)
        );
    }

}
