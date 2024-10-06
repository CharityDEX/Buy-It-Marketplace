package it.eat.back.core.service;

import it.eat.back.core.dbinterface.IDBRepository;
import it.eat.back.core.models.PurchaseDB;
import it.eat.back.core.models.UserDB;
import it.eat.back.web.models.AddPurchaseAnswer;
import it.eat.back.web.models.PurchaseItem;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

/**
 * Purchase Service
 */
@Service
public class PurchaseService {
    private final IDBRepository repository;

    /**
     * Service constructor
     * @param repository database repositiry
     */
    public PurchaseService(final IDBRepository repository) {
        this.repository = repository;
    }

    /**
     * Add purchase to database
     * @param purchase list of PurchaseItem
     * @param userUID user
     * @return adding status
     */
    public AddPurchaseAnswer addPurchase(final ArrayList<PurchaseItem> purchase, final String userUID) {
        boolean status;
        int code = 0;
        int points = 0;
        for (PurchaseItem item: purchase) {
            points = points + (item.getPoints() * item.getQnty());
        }
        UserDB userDB = repository.getUser(userUID);
//        TODO: Проверка на изменение характеристик товара
        PurchaseDB purchaseDB = new PurchaseDB(purchase, userDB.getUserId(), points);
        status = repository.setPurchase(purchaseDB);

        return new AddPurchaseAnswer(status, code);
    }
}
