package it.eat.back.core.models;

import it.eat.back.web.models.PurchaseItem;

import java.util.ArrayList;

/**
 * object to insert into database
 */
public class PurchaseDB {
    private int userId;
    private ArrayList<PurchaseItem> purchase;
    private int points;


    /**
     * PurchaseDB constructor
     * @param purchase list of PurchaseItem
     * @param userId current user
     * @param points current point of purchase
     */
    public PurchaseDB(final ArrayList<PurchaseItem> purchase, final int userId, final int points) {
        this.purchase = purchase;
        this.points = points;
        this.userId = userId;
    }

    public int getUserId() {
        return userId;
    }

    public int getPoints() {
        return points;
    }

    public ArrayList<PurchaseItem> getPurchase() {
        return purchase;
    }
}
