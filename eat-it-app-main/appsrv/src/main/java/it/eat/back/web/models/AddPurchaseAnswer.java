package it.eat.back.web.models;

/**
 * AddPurchaseAnswer model
 */
public class AddPurchaseAnswer {
    private boolean status;

    private int code;

    /**
     * class constructor
     * @param status boolean status from add purchase
     * @param code int code from add purchase
     */
    public AddPurchaseAnswer(final boolean status, final int code) {
        this.status = status;
        this.code = code;
    }

    public boolean isStatus() {
        return status;
    }

    public int getCode() {
        return code;
    }
}
