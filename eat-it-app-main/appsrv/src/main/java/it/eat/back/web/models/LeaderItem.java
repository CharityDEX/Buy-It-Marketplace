package it.eat.back.web.models;

/**
 * Leader Item model for leader list
 */
public class LeaderItem {
    private String name;
    private int points;
    private byte[] photo;

    /**
     * class constructor
     * @param name user name
     * @param points user points
     * @param photo user photo
     */
    public LeaderItem(final String name, final int points, final byte[] photo) {
        this.name = name;
        this.points = points;
        this.photo = photo;
    }

    public String getName() {
        return name;
    }

    public int getPoints() {
        return points;
    }

    public byte[] getPhoto() {
        return photo;
    }
}
