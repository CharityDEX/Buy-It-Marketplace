package it.eat.back.web.controller;

import it.eat.back.web.security.AuthRoleRequired;
import it.eat.back.web.security.UserCredentials;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Controller to display the current user.
 */
@Controller
@RequestMapping("/whoami")
public class WhoamiController {
    /**
     * get current user information from user token
     * @param userCredentials user token
     * @return token information
     */
    @GetMapping
    @ResponseBody
    @AuthRoleRequired("USER")
    public ResponseEntity<UserCredentials> get(
            final UserCredentials userCredentials
    ) {
        return ResponseEntity.ok(userCredentials);
    }

}
