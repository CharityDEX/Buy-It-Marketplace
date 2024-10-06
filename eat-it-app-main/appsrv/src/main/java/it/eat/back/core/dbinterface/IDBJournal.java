package it.eat.back.core.dbinterface;

/**
 * Interface of journal
 */
public interface IDBJournal {

    /**
     * add to sendmail journal
     * @param template template of email
     * @param userName name of user
     * @param email email of user
     * @param code verify code
     */
    void addToJournalMail(String template, String userName, String email, String code);

    /**
     * add to SignUp journal
     * @param userName name of user
     * @param email email of user
     */
    void addToJournalSignUp(String userName, String email);

    /**
     * Add to restore password journal
     * @param login login of user
     */
    void addToJournalRestore(String login);

}
