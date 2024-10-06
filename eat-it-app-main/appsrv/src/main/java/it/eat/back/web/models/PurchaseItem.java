package it.eat.back.web.models;

/**
 * PurchaseItem model
 */
public class PurchaseItem {
    private String barcode;
    private int qnty;
    private int points;

    /**
     * class constructor
     * @param barcode code of item
     * @param qnty qnty of item
     * @param points point of item
     */
    public PurchaseItem(final String barcode, final int qnty, final int points) {
        this.barcode = barcode;
        this.qnty = qnty;
        this.points = points;
    }

    public String getBarcode() {
        return barcode;
    }

    public int getQnty() {
        return qnty;
    }

    public int getPoints() {
        return points;
    }

    /**
     * check purcheaseItem valid
     * @return true
     */
    public boolean isValid() {
        if (barcode == null) {
            return false;
        }
        return !(barcode.isEmpty() || qnty == 0);
    }
}
