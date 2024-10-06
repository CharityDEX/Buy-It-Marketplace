package it.eat.back.web.models.off;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import it.eat.back.core.service.LocaleService;

import java.util.ArrayList;

/**
 * EcoScore model
 */
public class EcoscoreData {
    @JsonSetter("adjustments")
    private Adjustment adjustment;

    @JsonProperty("grade")
    private String grade;

    @JsonSetter("score")
    private Integer score;

    @JsonProperty("missing")
    private Missing missing;

    @JsonSetter("agribalyse")
    private Agribalyse agribalyse;

    @JsonIgnore
    private String serverPath;
    @JsonIgnore
    private LocaleService localeService;

    @JsonIgnore
    private String localeCode;

    @JsonIgnore
    public void setServerPath(final String serverPath) {
        this.serverPath = serverPath;
    }

    /**
     * set Locale Service
     * @param localeService LocaleService
     * @param localeCode locale code
     */
    @JsonIgnore
    public void setService(final LocaleService localeService, final String localeCode) {
        this.localeService = localeService;
        this.localeCode = localeCode;
    }

    /**
     * get agribalyse score
     * @return point by product
     */
    public Integer getScore() {
        if (this.agribalyse != null) {
            return this.agribalyse.getScore();
        }
        return null;
    }

    /**
     * get total points
     * @return points by product
     */
    @JsonGetter("total")
    public Integer getTotal() {
        ArrayList<AdjustmentItem> adjustmentItems = getAdjustments();
        Integer total = getScore();
        if (total == null) {
            return null;
        }
        for (AdjustmentItem adjustmentItem : adjustmentItems) {
            total = total + adjustmentItem.getValue();
        }
        return total;
    }

    /**
     * return status of adjustments by missing.origins and ingrdedients.value
     * @return status
     */
//    @JsonGetter("adjustments2")
//    public Adjustment getAdjustment() {
//        if ((missing != null) && (missing.getOrigins() == 1)) {
//            adjustment.getOriginsOfIngredients().setStatus("missing");
//        } else if (adjustment.getOriginsOfIngredients().getValue() < 0) {
//            adjustment.getOriginsOfIngredients().setStatus("high");
//        } else if (adjustment.getOriginsOfIngredients().getValue() > 10) {
//            adjustment.getOriginsOfIngredients().setStatus("low");
//        } else {
//            adjustment.getOriginsOfIngredients().setStatus("medium");
//        }
//        adjustment.getPackaging().setStatus("missing");
//        adjustment.getProductionSystem().setStatus("missing");
//        adjustment.getThreatenedSpecies().setStatus("missing");
//        return adjustment;
//    }

    @JsonIgnore
    public Adjustment getAdjustment() {
        return adjustment;
    }

    /**
     * generate ArrayList<AdjustmentItem>
     * @return list of AdjustmentItem
     */
    @JsonGetter("adjustments")
    public ArrayList<AdjustmentItem> getAdjustments() {
        ArrayList<AdjustmentItem> adjustmentItems = new ArrayList<>();
        String status;
        String text;
        int value;
        if (adjustment.getOriginsOfIngredients() != null) {
            value = adjustment.getOriginsOfIngredients().getValue();
            if ((missing != null) && (missing.getOrigins() == 1)) {
                status = "missing";
                text = localeService.getTextByCode(localeCode, "adj:ing:missing");
            } else if (value < 0) {
                status = "high";
                text = localeService.getTextByCode(localeCode, "adj:ing:high");
            } else if (value > 10) {
                status = "low";
                text = localeService.getTextByCode(localeCode, "adj:ing:low");
            } else {
                status = "medium";
                text = localeService.getTextByCode(localeCode, "adj:ing:medium");
            }
            AdjustmentItem adjustmentItem = new AdjustmentItem(value, status, text,
                    localeService.getTextByCode(localeCode, "adj:ing:header"),
                    serverPath + "static/ingredients.svg");
            adjustmentItems.add(adjustmentItem);
        }
        if (adjustment.getPackaging() != null) {
            value = adjustment.getPackaging().getValue();
//        if ((missing != null) && (missing.getPackagings() == 1)) {
//            status = "missing";
//            text = "Unknown packaging information";
//        } else
            if (value < -20) {
                status = "high";
                text = localeService.getTextByCode(localeCode, "adj:pck:high");
            } else if (value > -5) {
                status = "low";
                text = localeService.getTextByCode(localeCode, "adj:pck:low");

            } else {
                status = "medium";
                text = localeService.getTextByCode(localeCode, "adj:pck:medium");
            }

            AdjustmentItem adjustmentItem = new AdjustmentItem(value, status, text,
                    localeService.getTextByCode(localeCode, "adj:pck:header"),
                    serverPath + "static/packaging.svg");
            adjustmentItems.add(adjustmentItem);
        }
        if (adjustment.getProductionSystem() != null) {
            value = adjustment.getProductionSystem().getValue();
            if (value > 0) {
                status = "low";
                text = localeService.getTextByCode(localeCode, "adj:lbl:low");

                AdjustmentItem adjustmentItem = new AdjustmentItem(value, status, text,
                        localeService.getTextByCode(localeCode, "adj:lbl:header"),
                        serverPath + "static/benefits.svg");
                adjustmentItems.add(adjustmentItem);
            }
        }
        if (adjustment.getThreatenedSpecies() != null) {
            value = adjustment.getThreatenedSpecies().getValue();
            if (value < 0) {
                status = "high";
                text = localeService.getTextByCode(localeCode, "adj:hrm:high");
            } else {
                status = "low";
                text = localeService.getTextByCode(localeCode, "adj:hrm:low");
            }
            AdjustmentItem adjustmentItem = new AdjustmentItem(value, status, text,
                    localeService.getTextByCode(localeCode, "adj:hrm:header"),
                    serverPath + "static/harmed.svg");
            adjustmentItems.add(adjustmentItem);
        }

        return adjustmentItems;
    }

    /**
     * generete list of AgribalyseItem
     * @return list of AgribalyseItem from agribalyse
     */
    @JsonGetter("agribalyse")
    public ArrayList<AgribalyseItem> getAgribalyse() {
        ArrayList<AgribalyseItem> agribalyseItems = new ArrayList<>();
        if (agribalyse != null) {
            agribalyseItems.add(new AgribalyseItem(localeService.getTextByCode(localeCode, "agb:agr"), agribalyse.getEfAgriculture()));
            agribalyseItems.add(new AgribalyseItem(localeService.getTextByCode(localeCode, "agb:prc"), agribalyse.getEfProcessing()));
            agribalyseItems.add(new AgribalyseItem(localeService.getTextByCode(localeCode, "agb:pck"), agribalyse.getEfPackaging()));
            agribalyseItems.add(new AgribalyseItem(localeService.getTextByCode(localeCode, "agb:trn"), agribalyse.getEfTransportation()));
            agribalyseItems.add(new AgribalyseItem(localeService.getTextByCode(localeCode, "agb:dst"), agribalyse.getEfDistribution()));
            agribalyseItems.add(new AgribalyseItem(localeService.getTextByCode(localeCode, "agb:cns"), agribalyse.getEfConsuption()));
        }
        return agribalyseItems;
    }
}
