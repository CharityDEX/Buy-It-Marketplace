package it.eat.back.core.database;

import it.eat.back.core.dbinterface.IDBJournal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcOperations;

/**
 * journal repository
 */
public class PGJournal implements IDBJournal {
    private final JdbcOperations jdbcOperations;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());


    /**
     * class constructor
     * @param jdbcOperations jdbc
     */
    public PGJournal(final JdbcOperations jdbcOperations) {
        this.jdbcOperations = jdbcOperations;
    }

    @Override
    public void addToJournalMail(final String template, final String userName, final String email, final String code) {
        try {
            int rows = jdbcOperations.update(
                    "INSERT INTO journal_mail(template, userName, email, code) VALUES (?, ?, ?, ?)",
                    template, userName, email, code);
        } catch (Exception e) {
            logger.error(e.toString());
        }
    }

    @Override
    public void addToJournalSignUp(final String userName, final String email) {
        try {
            int rows = jdbcOperations.update(
                    "INSERT INTO journal_signup(userName, email) VALUES (?, ?)",
                    userName, email);
        } catch (Exception e) {
            logger.error(e.toString());
        }
    }

    @Override
    public void addToJournalRestore(final String login) {
        try {
            int rows = jdbcOperations.update(
                    "INSERT INTO journal_restore(login) VALUES (?)",
                    login);
        } catch (Exception e) {
            logger.error(e.toString());
        }

    }
}
