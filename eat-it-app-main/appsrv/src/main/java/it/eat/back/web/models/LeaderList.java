package it.eat.back.web.models;

import java.util.ArrayList;

/**
 * leader list model
 */
public class LeaderList {
    private ArrayList<LeaderItem> leaderItems;

    /**
     * class constructor
     * @param leaderItems list of leaders
     */
    public LeaderList(final ArrayList<LeaderItem> leaderItems) {
        this.leaderItems = leaderItems;
    }

    public ArrayList<LeaderItem> getLeaderItems() {
        return leaderItems;
    }
}
