package it.eat.back.web.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.eat.back.core.service.PurchaseService;
import it.eat.back.web.models.AddPurchaseAnswer;
import it.eat.back.web.models.Purchase;
import it.eat.back.web.models.PurchaseItem;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;

/**
 * Purchase controller class
 */
@Controller
public class PurchaseController {
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
    private final PurchaseService purchaseService;

    /**
     * Purchase controller initializer
     * @param purchaseService PurchaseService
     */
    public PurchaseController(final PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }

    /**
     * insert purchase in database
     * @param requestObject object with params request
     * @param userUID userUID from token
     * @return status add purchase
     */
    public ResponseEntity<?> setPurchase(final Object requestObject, final String userUID) {

        Purchase purchase = gson.fromJson(gson.toJson(requestObject), Purchase.class);
        ArrayList<PurchaseItem> purchaseList = purchase.getPurchase();

        for (PurchaseItem item: purchaseList) {
            if (!item.isValid()) {
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }
        }
        try {
            AddPurchaseAnswer addPurchaseAnswer = purchaseService.addPurchase(purchaseList, userUID);
            return ResponseEntity.ok(addPurchaseAnswer);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
//        return ResponseEntity.ok("");
    }
}
