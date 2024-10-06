package it.eat.back.web.models;

/**
 * user position model
 */
public class Position {
    private int position;

    /**
     * class constructor
     * @param position user position
     */
    public Position(final int position) {
        this.position = position;
    }

    public int getPosition() {
        return position;
    }
}
