package it.eat.back.web.models;

/**
 * OkResponse model
 */
public class OkResponse {
    private String status;

    /**
     * class constructor
     * @param text text response
     */
    public OkResponse(final String text) {
        this.status = text;
    }

    public String getStatus() {
        return status;
    }
}
