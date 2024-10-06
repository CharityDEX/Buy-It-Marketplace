package it.eat.back.web.models;

/**
 * get leader model
 */
public class GetLeader {
    private int count;

    /**
     * get count leader for list
     * @return if count < 1 then return 20
     */
    public int getCount() {
        if (count < 1) {
            return 20;
        }
        return count;
    }
}
