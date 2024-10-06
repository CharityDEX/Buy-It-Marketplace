package it.eat.back.web.models;

/**
 * Attempt response model
 */
public class Attempt {
    private String text;
    private int attempt;

    /**
     * class constructor
     * @param text attempt text
     * @param attempt attempt count
     */
    public Attempt(final String text, final int attempt) {
        this.text = text;
        this.attempt = attempt;
    }

    public String getText() {
        return text;
    }

    public int getAttempt() {
        return attempt;
    }
}
