package it.eat.back.web.models;

/**
 * ErrorResponse model
 */
public class ErrorResponse {
    private String title;
    private String message;

    /**
     * class constructor
     * @param message message text
     * @param title message title
     */
    public ErrorResponse(final String title, final String message) {
        this.title = title;
        this.message = message;
    }

    public String getTitle() {
        return title;
    }

    public String getMessage() {
        return message;
    }
}
