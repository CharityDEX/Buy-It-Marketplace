package it.eat.back.core.database;

import it.eat.back.core.dbinterface.IDBRepository;
import it.eat.back.core.internal.ImageResize;
import it.eat.back.core.models.Locales;
import it.eat.back.core.models.PurchaseDB;
import it.eat.back.core.models.UserDB;
import it.eat.back.web.models.LeaderItem;
import it.eat.back.web.models.PurchaseItem;
import it.eat.back.web.models.SignUp;
import it.eat.back.web.models.VerifyCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcOperations;

import java.io.IOException;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

/**
 * Pastgres release of IDBUsersRepository
 */
public class PGRepository implements IDBRepository {

    private final JdbcOperations jdbcOperations;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * Class cjnstructor
     * @param jdbcOperations JdbcOperations object
     */
    public PGRepository(final JdbcOperations jdbcOperations) {
        this.jdbcOperations = jdbcOperations;
    }


    @Override
    public boolean setPurchase(final PurchaseDB purchaseDB) {

        jdbcOperations.update("BEGIN;");
        try {

            int purchaseId = jdbcOperations.queryForObject(
                    "INSERT INTO purchases (userId, points) VALUES (?, ?) returning id",
                    (resultSet, i) -> {
                        return resultSet.getInt("id");
                    },
                    purchaseDB.getUserId(), purchaseDB.getPoints()
            );
            for (PurchaseItem item : purchaseDB.getPurchase()) {
                jdbcOperations.update(
                        "INSERT INTO purchases_details (purchasesId, barcode, qnty, points) VALUES (?, ?, ?, ?)",
                        purchaseId, item.getBarcode(), item.getQnty(), item.getPoints()
                );
            }
            jdbcOperations.update(
                    "update users " +
                            "set points = points + ? " +
                            "where id = ?",
                    purchaseDB.getPoints(), purchaseDB.getUserId()
            );

            jdbcOperations.update("COMMIT;");
        } catch (Exception e) {
            jdbcOperations.update("ROLLBACK;");
            logger.error(e.toString());
            return false;
        }
        return true;
    }

    @Override
    public UserDB getUser(final String userUID) {
        try {
            UserDB user = jdbcOperations.queryForObject(
                    "SELECT * FROM users" +
                            " WHERE userUID = ?",
                    (resultSet, i) -> {
                        return new UserDB(resultSet.getInt("id"),
                                resultSet.getString("userUID"),
                                resultSet.getString("email"),
                                resultSet.getString("userName"),
                                resultSet.getString("password"),
                                resultSet.getString("userText"),
                                resultSet.getBytes("photo"),
                                resultSet.getInt("points"));
                    },
                    UUID.fromString(userUID)
            );
            return user;
        } catch (Exception e) {
//            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void updateUser(final UserDB user) {
        jdbcOperations.update("BEGIN;");
        try {
            int rows = jdbcOperations.update(
                "UPDATE users set userName = ?, " +
                        "userText = ?, " +
                        "photo = ? " +
                        "where id = ?",
                user.getUserName(), user.getUserText(), user.getPhoto(), user.getUserId());
            jdbcOperations.update("COMMIT;");
        } catch (Exception e) {
            jdbcOperations.update("ROLLBACK;");
            logger.error(e.toString());
        }
    }

    @Override
    public int getUserPosition(final int userId) {
        try {
            int position = jdbcOperations.queryForObject(
                    "select positions.rnum from " +
                            "(select *, row_number() over() as rnum " +
                            "from (select id,points from users order by points desc) as cj) as positions " +
                            "where positions.id = ?",
                    (resultSet, i) -> {
                        return resultSet.getInt("rNum");
                    },
                    userId
            );
            return position;
        } catch (Exception e) {
//            e.printStackTrace();
            logger.error(e.toString());
            return 0;
        }
    }

    @Override
    public ArrayList<LeaderItem> getLeader(final int count) {
        ArrayList<LeaderItem> leaderItems = new ArrayList<>();
        leaderItems.addAll(jdbcOperations.query(
                "SELECT userName, points, photo FROM users ORDER BY points desc limit ?",
                (resultSet, i) -> {
                    try {
                        return new LeaderItem(resultSet.getString("userName"), resultSet.getInt("points"),
                                new ImageResize().imageResize(resultSet.getBytes("photo"), 96));
                    } catch (IOException e) {
                        logger.error(e.toString());
                        return new LeaderItem(resultSet.getString("name"), resultSet.getInt("points"), null);
                    }
                }, count));
        return leaderItems;
    }

    @Override
    public ArrayList<Locales> getLocaleText(final String localeCode) {
        ArrayList<Locales> localesArrayList = new ArrayList<>();
        try {
            localesArrayList.addAll(jdbcOperations.query(
                    "select id, localeText from locales " +
                            "where localeCode in (?, '_default') " +
                            "order by localeCode asc",
                    (resultSet, i) -> {
                        return new Locales(resultSet.getString("id"), resultSet.getString("localeText"));
                    },
                    localeCode
            ));
            return localesArrayList;
        } catch (Exception e) {
            logger.error(e.toString());
//            e.printStackTrace();
            return null;
        }
    }

    @Override
    public ArrayList<String> getLocales() {
        ArrayList<String> localesArrayList = new ArrayList<>();
        try {
            localesArrayList.addAll(jdbcOperations.query(
                    "select distinct localeCode as code from locales ",
                    (resultSet, i) -> {
                        return resultSet.getString("code");
                    }
            ));
            return localesArrayList;
        } catch (Exception e) {
            logger.error(e.toString());
//            e.printStackTrace();
            return null;
        }
    }

    @Override
    public UserDB checkUserByName(final String userName, final String password) {
        try {
            UserDB user = jdbcOperations.queryForObject(
                    "select * from users " +
                            "where lower(userName) = lower(?) " +
                            "and (password = crypt( ? ,password))",
                    (resultSet, i) -> {
                        return new UserDB(resultSet.getInt("id"),
                                resultSet.getString("userUID"),
                                resultSet.getString("email"),
                                resultSet.getString("userName"),
                                resultSet.getString("password"),
                                resultSet.getString("userText"),
                                resultSet.getBytes("photo"),
                                resultSet.getInt("points"));
                        },
                    userName, password
            );
            return user;
        } catch (Exception e) {
//            e.printStackTrace();
            return null;
        }
    }

    @Override
    public UserDB checkUserByEmail(final String email, final String password) {
        try {
            UserDB user = jdbcOperations.queryForObject(
                    "select * from users " +
                            "where lower(email) = lower(?) " +
                            "and (password = crypt( ? ,password))",
                    (resultSet, i) -> {
                        return new UserDB(resultSet.getInt("id"),
                                resultSet.getString("userUID"),
                                resultSet.getString("email"),
                                resultSet.getString("userName"),
                                resultSet.getString("password"),
                                resultSet.getString("userText"),
                                resultSet.getBytes("photo"),
                                resultSet.getInt("points"));
                        },
                    email, password
            );
            return user;
        } catch (Exception e) {
//            e.printStackTrace();
            return null;
        }
    }


    @Override
    public void setToken(final String userUID, final String token, final String refreshToken, final Date expired) {
        int rows = jdbcOperations.update(
                "INSERT INTO tokens (userUID, token, refreshToken, exp) VALUES (?, ?, ?, ?)",
                UUID.fromString(userUID), token, refreshToken, expired.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
    }

    @Override
    public void deleteOldTokens() {
        int rows = jdbcOperations.update(
                "DELETE FROM tokens where exp < CURRENT_TIMESTAMP");
    }

    @Override
    public void deleteTokensByUser(final String userUID) {
        int rows = jdbcOperations.update(
                "DELETE FROM tokens where userUID = ?",
                UUID.fromString(userUID));

    }

    @Override
    public void deleteToken(final String userUID, final String token) {
        int rows = jdbcOperations.update(
                "DELETE FROM tokens " +
                        "where userUID = ? " +
                        "and token = ?",
                UUID.fromString(userUID), token);
    }

    @Override
    public void deleteRefreshToken(final String userUID, final String refreshToken) {
        int rows = jdbcOperations.update(
                "DELETE FROM tokens " +
                        "where userUID = ? " +
                        "and refreshToken = ?",
                UUID.fromString(userUID), refreshToken);
    }

    @Override
    public String getUserUIDByToken(final String token) {
        try {
            String userUID = jdbcOperations.queryForObject(
                    "select userUID from tokens " +
                            "where token = ? ",
                    (resultSet, i) -> {
                        return resultSet.getString("userUID");
                        },
                    token
            );
            return userUID;
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public String getUserUIDByRefreshToken(final String refreshToken) {
        try {
            String userUID = jdbcOperations.queryForObject(
                    "select userUID from tokens " +
                            "where refreshToken = ? ",
                    (resultSet, i) -> {
                        return resultSet.getString("userUID");
                    },
                    refreshToken
            );
            return userUID;
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public boolean checkUserByName(final SignUp signUp) {
        try {
            int count = jdbcOperations.queryForObject(
                    "select count(*) as mcount from users " +
                            "where lower(userName) = lower(?) " +
                            "or lower(email) = lower(?) " +
                            "or lower(userName) = lower(?)",
                    (resultSet, i) -> {
                        return resultSet.getInt("mcount");
                    },
                    signUp.getLogin(), signUp.getLogin(), signUp.getEmail()
            );
            return count == 1;
        } catch (Exception e) {
//            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean checkNewUserByName(final SignUp signUp) {
        try {
            int count = jdbcOperations.queryForObject(
                    "select count(*) as mcount from users_new " +
                            "where (lower(userName) = lower(?) " +
                            "or lower(email) = lower(?)) " +
                            "and lower(email) != lower(?)",
                    (resultSet, i) -> {
                        return resultSet.getInt("mcount");
                    },
                    signUp.getLogin(), signUp.getLogin(), signUp.getEmail()
            );
            return count == 1;
        } catch (Exception e) {
//            e.printStackTrace();
            return false;
        }
    }

    @Override
    public UserDB checkUserByEmail(final SignUp signUp) {
        try {
            UserDB user = jdbcOperations.queryForObject(
                    "select * from users " +
                            "where lower(email) = lower(?) ",
                    (resultSet, i) -> {
                        return new UserDB(resultSet.getInt("id"),
                                resultSet.getString("userUID"),
                                resultSet.getString("email"),
                                resultSet.getString("userName"),
                                resultSet.getString("password"),
                                resultSet.getString("userText"),
                                resultSet.getBytes("photo"),
                                resultSet.getInt("points"));
                    },
                    signUp.getEmail()
            );
            return user;
        } catch (Exception e) {
//            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void deleteOldRegistrationRequest(final int hoursInterval) {
        int rows = jdbcOperations.update(
                "DELETE FROM users_new " +
                        "where extract(epoch from (current_timestamp - date))/3600 > ? " +
                        "or attempt < 1",
                hoursInterval);
    }

    @Override
    public void addUserToNewList(final SignUp signUp, final String verifyCode, final int attemptCount) {
        int rows = jdbcOperations.update(
                "INSERT INTO users_new (userName, email, password, sendingCode, attempt) " +
                        "VALUES (?, ?, crypt(?, gen_salt('bf')), ?, ?)",
                signUp.getLogin(), signUp.getEmail(), signUp.getPassword(), verifyCode, attemptCount);
    }

    @Override
    public boolean isValidCode(final VerifyCode verifyCode) {
        try {
            int count = jdbcOperations.queryForObject(
                    "select count(*) as mcount from users_new " +
                            "where lower(userName) = lower(?) " +
                            "and lower(email) = lower(?) " +
                            "and sendingCode = ?",
                    (resultSet, i) -> {
                        return resultSet.getInt("mcount");
                    },
                    verifyCode.getLogin(), verifyCode.getEmail(), verifyCode.getCode()
            );
            return count == 1;
        } catch (Exception e) {
//            e.printStackTrace();
            return false;
        }
    }

    @Override
    public UserDB getNewUser(final VerifyCode verifyCode) {
        try {
            UserDB user = jdbcOperations.queryForObject(
                    "select * from users_new " +
                            "where lower(userName) = lower(?) " +
                            "and lower(email) = lower(?)",
                    (resultSet, i) -> {
                        return new UserDB(resultSet.getInt("id"),
                                "",
                                resultSet.getString("email"),
                                resultSet.getString("userName"),
                                resultSet.getString("password"),
                                "",
                                null,
                                0);
                    },
                    verifyCode.getLogin(), verifyCode.getEmail()
            );
            return user;
        } catch (Exception e) {
//            e.printStackTrace();
            return null;
        }
    }

    @Override
    public void addUser(final UserDB userDB) {
        int rows = jdbcOperations.update(
                "INSERT INTO users (userUID, userName, email, password) " +
                        "VALUES (?, ?, ?, ?)",
                UUID.fromString(userDB.getUserUID()), userDB.getUserName(), userDB.getEmail(), userDB.getPassword());
    }

    @Override
    public void deleteNewUserByEmail(final String email) {
        int rows = jdbcOperations.update(
                "DELETE FROM users_new " +
                        "where lower(email) = lower(?)",
                email
        );
    }

    @Override
    public int getAttempt(final VerifyCode verifyCode) {
        try {
            int attempt = jdbcOperations.queryForObject(
                    "select attempt from users_new " +
                            "where lower(userName) = lower(?) " +
                            "and lower(email) = lower(?)",
                    (resultSet, i) -> {
                        return resultSet.getInt("attempt");
                    },
                    verifyCode.getLogin(), verifyCode.getEmail()
            );
            return attempt;
        } catch (Exception e) {
//            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public void setAttempt(final VerifyCode verifyCode, final int attempt) {
        try {
            int rows = jdbcOperations.update(
                    "UPDATE users_new set attempt = ? " +
                            "where lower(userName) = lower(?) " +
                            "and lower(email) = lower(?)",
                    attempt, verifyCode.getLogin(), verifyCode.getEmail());
        } catch (Exception e) {
            logger.error(e.toString());
        }
    }

    @Override
    public UserDB getUserForRestore(final String login) {
        try {
            UserDB user = jdbcOperations.queryForObject(
                    "SELECT * FROM users " +
                            "WHERE lower(userName) = lower(?) " +
                            "or lower(email) = lower(?)",
                    (resultSet, i) -> {
                        return new UserDB(resultSet.getInt("id"),
                                resultSet.getString("userUID"),
                                resultSet.getString("email"),
                                resultSet.getString("userName"),
                                resultSet.getString("password"),
                                resultSet.getString("userText"),
                                resultSet.getBytes("photo"),
                                resultSet.getInt("points"));
                    },
                    login, login
            );
            return user;
        } catch (Exception e) {
//            e.printStackTrace();

            return null;
        }
    }

    @Override
    public void deleteRestore(final int userId) {
        int rows = jdbcOperations.update(
                "DELETE FROM restore_password " +
                        "where userId = ? ",
                userId);
    }

    @Override
    public void addUserToRestore(final int userId, final String verifyCode, final int attemptCount) {
        int rows = jdbcOperations.update(
                "INSERT INTO restore_password (userId, sendingCode, attempt) " +
                        "VALUES (?, ?, ?)",
                userId, verifyCode, attemptCount);
    }

    @Override
    public void deleteOldRestoreRequest(final int validHours) {
        int rows = jdbcOperations.update(
                "DELETE FROM restore_password " +
                        "where extract(epoch from (current_timestamp - date))/3600 > ? " +
                        "or attempt < 1",
                validHours);
    }

    @Override
    public boolean isValidRestoreCode(final int userId, final String code) {
        try {
            int count = jdbcOperations.queryForObject(
                    "select count(*) as mcount from restore_password " +
                            "where userId = ? " +
                            "and sendingCode = ?",
                    (resultSet, i) -> {
                        return resultSet.getInt("mcount");
                    },
                    userId, code
            );
            return count == 1;
        } catch (Exception e) {
//            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getRestoreAttempt(final int userId) {
        try {
            int attempt = jdbcOperations.queryForObject(
                    "select attempt from restore_password " +
                            "where userId = ?",
                    (resultSet, i) -> {
                        return resultSet.getInt("attempt");
                    },
                    userId
            );
            return attempt;
        } catch (Exception e) {
//            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public void setRestoreAttempt(final int userId, final int attempt) {
        try {
            int rows = jdbcOperations.update(
                    "UPDATE restore_password set attempt = ? " +
                            "where userId = ?",
                    attempt, userId);
        } catch (Exception e) {
            logger.error(e.toString());
        }
    }

    @Override
    public void setPassword(final UserDB userDB) {
        try {
            int rows = jdbcOperations.update(
                    "UPDATE users set password = crypt(?, gen_salt('bf')) " +
                            "where id = ? ",
                    userDB.getPassword(), userDB.getUserId());
        } catch (Exception e) {
            logger.error(e.toString());
//            e.printStackTrace();
        }
    }

    @Override
    public boolean checkWithAnotherUser(final UserDB userDB) {
        try {
            int count = jdbcOperations.queryForObject(
                    "select count(*) as mcount from users " +
                            "where (lower(userName) = lower(?) " +
                            "or lower(email) = lower(?) " +
                            "or lower(userName) = lower(?) " +
                            "or lower(email) = lower(?)) " +
                            "and id != ?",
                    (resultSet, i) -> {
                        return resultSet.getInt("mcount");
                    },
                    userDB.getEmail(), userDB.getEmail(), userDB.getUserName(), userDB.getUserName(), userDB.getUserId()
            );
            return count == 1;
        } catch (Exception e) {
            logger.error(e.toString());
//            e.printStackTrace();
            return false;
        }
    }

    @Override
    public void deleteUserPurchases(final int userId) {
        int rows = jdbcOperations.update(
                "DELETE FROM purchases " +
                        "where userId = ? ",
                userId);
    }

    @Override
    public void deleteUser(final int userId) {
        int rows = jdbcOperations.update(
                "DELETE FROM users " +
                        "where Id = ? ",
                userId);

    }

}
