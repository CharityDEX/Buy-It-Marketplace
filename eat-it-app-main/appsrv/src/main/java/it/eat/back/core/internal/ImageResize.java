package it.eat.back.core.internal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.imageio.ImageIO;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.Color;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Image Resize internal class
 */
public class ImageResize {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    /**
     * resize image
     * @param imageIn byte[] base64 image
     * @param newSize new size image
     * @return byte[] base64 image in jpeg format
     * @throws IOException resize exception
     */
    public byte[] imageResize(final byte[] imageIn, final int newSize) throws IOException {
        if (imageIn == null) {
            return null;
        }
        InputStream is = new ByteArrayInputStream(imageIn);
        BufferedImage oldImage = ImageIO.read(is);
        int oldWidth = oldImage.getWidth();
        int oldHeight = oldImage.getHeight();
        int type = oldImage.getType() == 0 ? BufferedImage.TYPE_INT_ARGB : oldImage.getType();

        int imageSize = newSize <= 0 ? 1 : newSize;
        int maxOldSize = oldWidth > oldHeight ? oldWidth : oldHeight;
        imageSize = maxOldSize < imageSize ? maxOldSize : imageSize;
        int newWidth = imageSize;
        int newHeight = imageSize;
        if (oldWidth > oldHeight) {
            newHeight = newHeight * oldHeight / oldWidth;
        }
        if (oldWidth < oldHeight) {
            newWidth = newWidth * oldWidth / oldWidth;
        }

        BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, type);
//        for (String string: resizedImage.getPropertyNames()) {
//            logger.info(string);
//        }
        Graphics2D graphics2D = resizedImage.createGraphics();
        graphics2D.drawImage(oldImage, 0, 0, newWidth, newHeight, null);
        graphics2D.dispose();

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        BufferedImage result = new BufferedImage(
                resizedImage.getWidth(),
                resizedImage.getHeight(),
                BufferedImage.TYPE_INT_RGB);
        result.createGraphics().drawImage(resizedImage, 0, 0, Color.WHITE, null);
        ImageIO.write(result, "jpg", byteArrayOutputStream);
        byte[] imageOut = byteArrayOutputStream.toByteArray();
        return imageOut;
    }
}
