package it.eat.back.web.models.off;


/**
 * AdjustmentItem model
 */
public class AdjustmentItem {
    private Integer value;
    private String status;
    private String text;
    private String header;
    private String imagePath;

    /**
     * class constructor
     * @param value item value
     * @param status status of item
     * @param text text of item
     * @param header header of item
     * @param imagePath path to image
     */
    public AdjustmentItem(final Integer value, final String status, final String text, final String header, final String imagePath) {
        this.value = value;
        this.status = status;
        this.text = text;
        this.header = header;
        this.imagePath = imagePath;
    }

    public Integer getValue() {
        return value;
    }

    public String getStatus() {
        return status;
    }

    public String getText() {
        return text;
    }

    public String getHeader() {
        return header;
    }

    public String getImagePath() {
        return imagePath;
    }
}
