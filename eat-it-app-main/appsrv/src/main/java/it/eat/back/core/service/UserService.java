package it.eat.back.core.service;

import it.eat.back.core.dbinterface.IDBJournal;
import it.eat.back.core.dbinterface.IDBRepository;
import it.eat.back.core.models.UserDB;
import it.eat.back.web.models.NewPassword;
import it.eat.back.web.models.SignUp;
import it.eat.back.web.models.VerifyCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.concurrent.ThreadLocalRandom;


/**
 * User Service class
 */
@Service
public class UserService {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final IDBJournal journal;


    @Value("${registration.validHours}")
    private int validHours;

    @Value("${registration.attemptCount}")
    private int attemptCount;

    private final IDBRepository repository;

    private final MailService mailService;
    /**
     * UserService constructor
     * @param repository db repository
     * @param mailService MailService
     * @param journal  journal repository
     */
    public UserService(final IDBRepository repository,
                       final MailService mailService,
                       final IDBJournal journal) {
        this.repository = repository;
        this.mailService = mailService;
        this.journal = journal;
    }

    /**
     * get current user
     * @param userUID user UID
     * @return User class object
     */
    public UserDB getMe(final String userUID) {
        return repository.getUser(userUID);
    }

    /**
     * get position of user
     * @param userUID user UID
     * @return position
     */
    public int getMePosition(final String userUID) {
        return repository.getUserPosition(getMe(userUID).getUserId());
    }

    /**
     * update user info
     * @param user UserDB object
     * @return status update
     */
    public boolean updateMe(final UserDB user) {
        try {
            if (repository.checkWithAnotherUser(user)) {
                return false;
            }
            repository.updateUser(user);
            return true;
        } catch (Exception e) {
            logger.error(e.toString());
            return false;
        }
    }

    /**
     * check user params
     * @param user UserDB
     * @param checkPassword check password param
     * @return true if ok
     */
    public boolean isValidUserParams(final UserDB user, final boolean checkPassword) {
        if ((user.getUserName().length() > 50) || (user.getUserName().length() < 1)) {
            return false;
        }
        if ((user.getEmail().length() > 50) || (user.getEmail().length() < 5)) {
            return false;
        }
        if ((checkPassword) && ((user.getPassword().length() > 50) || (user.getPassword().length() < 6))) {
            return false;
        }
        return true;
    }
    /**
     * get user by login
     * @param login login user
     * @param password password user
     * @return UserDB object or null if not found
     */
    public UserDB getUserByLogin(final String login, final String password) {
        UserDB userDB = repository.checkUserByEmail(login, password);
        if (userDB == null) {
            userDB = repository.checkUserByName(login, password);
        }
        return userDB;
    }

    /**
     * check new user with existing user
     * @param signUp NewUser param
     * @return status check
     */
    public boolean isValidNewUser(final SignUp signUp) {
        repository.deleteOldRegistrationRequest(validHours);
        if ((repository.checkUserByName(signUp)) ||
                (repository.checkNewUserByName(signUp))) {
            return false;
        }
        UserDB userDB = repository.checkUserByEmail(signUp);
        if (userDB != null) {
            mailService.send("youHack", signUp.getEmail(), userDB.getUserName());
            return true;
        }
        String verifyCode = generateCode();
        mailService.send("newRegistration", signUp.getEmail(), signUp.getLogin(), verifyCode);
        repository.deleteNewUserByEmail(signUp.getEmail());
        repository.addUserToNewList(signUp, verifyCode, attemptCount);
        journal.addToJournalSignUp(signUp.getLogin(), signUp.getEmail());
        return true;
    }

    private String generateCode() {
        StringBuilder sb = new StringBuilder();
        int randomNum;
        for (int i = 0; i < 4; i++) {
            randomNum = ThreadLocalRandom.current().nextInt(0, 10);
            sb.append(randomNum);
        }
        return sb.toString();
    }

    /**
     * Verify code with sending
     * @param verifyCode VerifyCode object
     * @return status
     */
    public boolean isValidCodeNewUser(final VerifyCode verifyCode) {
        repository.deleteOldRegistrationRequest(validHours);
        return repository.isValidCode(verifyCode);
    }

    /**
     * Add new user from usersNew
     * @param verifyCode VerifyCode contains current user params
     */
    public void addNewUser(final VerifyCode verifyCode) {
        UserDB userDB = repository.getNewUser(verifyCode);
        repository.addUser(userDB);
        repository.deleteNewUserByEmail(userDB.getEmail());
    }

    /**
     * decrease attempt verify code for user
     * @param verifyCode VerifyCode object
     * @return attempt with decreased for current user
     */
    public int decreaseAttemptNewUser(final VerifyCode verifyCode) {
        int attempt = repository.getAttempt(verifyCode);
        if (attempt > 0) {
            attempt = attempt - 1;
            repository.setAttempt(verifyCode, attempt);
            repository.deleteOldRegistrationRequest(validHours);
        }
        return attempt;
    }

    /**
     * Restore password request
     * @param newPassword new password with login and code object
     */
    public void restorePassword(final NewPassword newPassword) {
        try {
            UserDB userDB = repository.getUserForRestore(newPassword.getLogin());
            if (userDB != null) {
                repository.deleteOldRestoreRequest(validHours);
                repository.deleteRestore(userDB.getUserId());
                String verifyCode = generateCode();
                mailService.send("restorePassword", userDB.getEmail(), userDB.getUserName(), verifyCode);
                repository.addUserToRestore(userDB.getUserId(), verifyCode, attemptCount);
                journal.addToJournalRestore(newPassword.getLogin());
            }
        } catch (Exception e) {
            logger.error(e.toString());
//            e.printStackTrace();
        }
    }

    /**
     * check is restore code valid
     * @param newPassword new password with login and code object
     * @return status
     */
    public boolean isValidRestore(final NewPassword newPassword) {
        repository.deleteOldRestoreRequest(validHours);
        UserDB userDB = repository.getUserForRestore(newPassword.getLogin());
        if (userDB == null) {
            return false;
        }
        return repository.isValidRestoreCode(userDB.getUserId(), newPassword.getCode());
    }

    /**
     * decrease atttempt to restore
     * @param newPassword new password with login and code object
     * @return new attempt count
     */
    public int decreaseAttemptRestore(final NewPassword newPassword) {
        UserDB userDB = repository.getUserForRestore(newPassword.getLogin());
        if (userDB == null) {
            return 0;
        }
        int attempt = repository.getRestoreAttempt(userDB.getUserId());
        if (attempt > 0) {
            attempt = attempt - 1;
            repository.setRestoreAttempt(userDB.getUserId(), attempt);
            repository.deleteOldRestoreRequest(validHours);
        }
        return attempt;
    }

    /**
     * Set new password after restore
     * @param newPassword new password with login and code object
     */
    public void setNewPassword(final NewPassword newPassword) {
        UserDB userDB = repository.getUserForRestore(newPassword.getLogin());
        userDB.setPassword(newPassword.getPassword());
        repository.setPassword(userDB);
        repository.deleteRestore(userDB.getUserId());
    }

    /**
     * delete current user
     * @param user current user
     * @return status delete
     */
    public boolean deleteMe(final UserDB user) {
        try {
            repository.deleteTokensByUser(user.getUserUID());
            repository.deleteUserPurchases(user.getUserId());
            repository.deleteUser(user.getUserId());
            return true;
        } catch (Exception e) {
            logger.error(e.toString());
            return false;
        }
    }
}
