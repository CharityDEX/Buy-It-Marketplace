package it.eat.back.core.service;

import it.eat.back.core.dbinterface.IDBRepository;
import it.eat.back.web.models.LeaderItem;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

/**
 * User Service class
 */
@Service
public class LeaderService {
    private final IDBRepository repository;

    /**
     * UserService constructor
     * @param repository db repository
     */
    public LeaderService(final IDBRepository repository) {
        this.repository = repository;
    }

    /**
     * get leader list
     * @param count list count
     * @return User class object
     */
    public ArrayList<LeaderItem> getLeader(final int count) {
        return repository.getLeader(count);
    }

}
