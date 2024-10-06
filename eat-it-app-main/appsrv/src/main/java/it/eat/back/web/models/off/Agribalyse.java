package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonSetter;

//@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)

/**
 * Agribalyse model
 */
public class Agribalyse {
//    private double co2_agriculture;
//    private double co2_consumption;
//    private double co2_distribution;
//    private double co2_packaging;
//    private double co2_processing;
//    private double co2_transportation;
//    private double co2_total;

    @JsonSetter("ef_agriculture")
    private double efAgriculture;
    @JsonSetter("ef_consumption")
    private double efConsumption;
    @JsonSetter("ef_distribution")
    private double efDistribution;
    @JsonSetter("ef_packaging")
    private double efPackaging;
    @JsonSetter("ef_processing")
    private double efProcessing;
    @JsonSetter("ef_transportation")
    private double efTransportation;
    @JsonSetter("ef_total")
    private double efTotal;
    @JsonSetter
    private int score;
//    public String getCoAgriculture() {
//        if (co2_total == 0) {
//            return "0.0";
//        }
//        return String.format("%.1f", co2_agriculture * 100 / co2_total);
//    }

    /**
     * evaluate agriculture
     * @return value
     */
    public String getEfAgriculture() {
        if (efTotal == 0) {
            return "0.0";
        }
        return String.format("%.1f", efAgriculture * 100 / efTotal);
    }

    /**
     * evaluate consuption
     * @return value
     */
    public String getEfConsuption() {
        if (efTotal == 0) {
            return "0.0";
        }
        return String.format("%.1f", efConsumption * 100 / efTotal);
    }

    /**
     * evaluate distribution
     * @return value
     */
    public String getEfDistribution() {
        if (efTotal == 0) {
            return "0.0";
        }
        return String.format("%.1f", efDistribution * 100 / efTotal);
    }

    /**
     * evaluate packaging
     * @return value
     */
    public String getEfPackaging() {
        if (efTotal == 0) {
            return "0.0";
        }
        return String.format("%.1f", efPackaging * 100 / efTotal);
    }
    /**
     * evaluate processing
     * @return value
     */
    public String getEfProcessing() {
        if (efTotal == 0) {
            return "0.0";
        }
        return String.format("%.1f", efProcessing * 100 / efTotal);
    }

    /**
     * evaluate transportation
     * @return value
     */
    public String getEfTransportation() {
        if (efTotal == 0) {
            return "0.0";
        }
        return String.format("%.1f", efTransportation * 100 / efTotal);
    }
    @JsonIgnore
    public int getScore() {
        return score;
    }
}
