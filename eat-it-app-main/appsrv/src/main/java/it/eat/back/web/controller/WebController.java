package it.eat.back.web.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.eat.back.core.internal.Version;
import it.eat.back.core.service.LocaleService;
import it.eat.back.web.models.Chain;
import it.eat.back.web.models.ErrorResponse;
import it.eat.back.web.models.LocaleCode;
import it.eat.back.web.security.UserCredentials;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;


/**
 * Web controller
 */
@Controller
public class WebController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final GetProductController getProductController;
    private final PurchaseController purchaseController;
    private final GetMeController getMeController;
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
    private final LoginController loginController;
    private final LeaderController leaderController;
    private final HttpServletRequest httpServletRequest;
    private final LocaleService localeService;

    /**
     * Web controller initializer
     * @param request HTTPServlet
     * @param loginController LoginController
     * @param getMeController GetMeController
     * @param getProductController GetProductController
     * @param leaderController LeaderController
     * @param purchaseController PurchaseController
     * @param localeService  LocaleService
     */
    public WebController(final HttpServletRequest request,
                         final LoginController loginController,
                         final GetMeController getMeController,
                         final GetProductController getProductController,
                         final LocaleService localeService,
                         final PurchaseController purchaseController,
                         final LeaderController leaderController
                         ) {
        this.httpServletRequest = request;
        this.loginController = loginController;
        this.purchaseController = purchaseController;
        this.getMeController = getMeController;
        this.leaderController = leaderController;
        this.getProductController = getProductController;
        this.localeService = localeService;
    }

    /**
     * home response
     * @param requestObject request object from front
     * @param userCredentials user token
     * @return response of request
     */
    @RequestMapping(value = "/", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> home(@RequestBody final Object requestObject,  final UserCredentials userCredentials) {
        Chain chain = gson.fromJson(gson.toJson(requestObject), Chain.class);
        LocaleCode localeCode = gson.fromJson(gson.toJson(requestObject), LocaleCode.class);
        String requestObjectString = gson.toJson(requestObject).toLowerCase();
        requestObjectString = requestObjectString.replaceAll("\"password\":\".*?\"", "\"password\":\"******\"");
        logger.info(this.httpServletRequest.getRemoteAddr() + " - " + requestObjectString);
        String userId = "";
//        userId = "04425351-f389-454d-9849-00d2f63a4633";
        if (userCredentials != null) {
            userId = userCredentials.getUserId();
        }
        String header = this.httpServletRequest.getHeader(HttpHeaders.AUTHORIZATION);
        String currentToken = "";
        if (header != null && header.startsWith("Bearer ")) {
            currentToken = header.substring(7);
        }
        String requestURL = this.httpServletRequest.getRequestURL().toString();

        StringBuilder url = new StringBuilder();
        url.append("https://").append(this.httpServletRequest.getServerName()).append("/");

//      TODO передавать картинки лучше с относительным путем, а не абсолютным

        requestURL = url.toString();

        String versionString = chain.getVersion();
        Version version = new Version(versionString);

//        logger.info(String.valueOf(version.compareTo("1.0.1")));
//        logger.info(String.valueOf(version.compareTo("09.0.0")));
//        logger.info(String.valueOf(version.compareTo("1.0.2")));
        switch (chain.getChain().toLowerCase()) {
            case "get-product":
                return getProductController.getFromOFF(requestObject, requestURL, localeCode.getLocale());
            case "set-purchase":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return purchaseController.setPurchase(requestObject, userId);
            case "get-me":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return getMeController.getMe(userId);
            case "get-me-photo":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return getMeController.getMePhoto(requestObject, userId);
            case "get-me-position":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return getMeController.getMePosition(userId);
            case "update-me":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return getMeController.updateMe(requestObject, userId, localeCode.getLocale());
            case "remove-me":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return getMeController.deleteMe(userId);
            case "get-leader":
                return leaderController.getLeader(requestObject);
            case "login":
                return loginController.login(requestObject, localeCode.getLocale());
            case "logout":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return loginController.logout(userId, currentToken, localeCode.getLocale());
            case "refresh-token":
                if (userId.length() == 0) {
                    return new ResponseEntity<>(chain, HttpStatus.UNAUTHORIZED);
                }
                return loginController.refreshToken(userId, currentToken, localeCode.getLocale());
            case "signup":
                return loginController.signUp(requestObject, localeCode.getLocale());
            case "verify-code":
                return loginController.verifyCode(requestObject, localeCode.getLocale());
            case "restore-password":
                return loginController.restorePassword(requestObject, localeCode.getLocale());
            case "restore-verify-code":
                return loginController.restoreVerifyCode(requestObject, localeCode.getLocale());
            case "set-new-password":
                return loginController.setNewPassword(requestObject, localeCode.getLocale());
            default:
                return new ResponseEntity<>(new ErrorResponse(localeService.getTextByCode(localeCode.getLocale(), "err:t:chain"),
                        localeService.getTextByCode(localeCode.getLocale(), "err:m:chain")), HttpStatus.NOT_FOUND);

        }
//        if (chain.getChain().toString().equals("test12")) {
//            OpenFoodFactsApiLowLevelClient openFoodFactsApiLowLevelClient = new OpenFoodFactsApiLowLevelClient();
//            ProductResponse productResponse = openFoodFactsApiLowLevelClient.fetchProductByCode("80135463");
//            return ResponseEntity.ok(productResponse);
//        } else {
////            MailSender mailSender = new MailSender();
////            mailSender.send();
//
//
//
//            return ResponseEntity.ok(testRepository.findAll());
//
//        }


//        return ResponseEntity.ok(testRepository.findAll());
//        return "It`s work ! :))))))";
    }
}
