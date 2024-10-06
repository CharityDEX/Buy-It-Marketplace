package it.eat.back.web.security;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation for check by one of roles existence
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface AuthRoleRequired {

    /**
     * Returns a role which is required to access the method
     * @return the role name
     */
    String value();

}
