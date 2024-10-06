package it.eat.back.web.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import it.eat.back.core.service.LeaderService;
import it.eat.back.web.models.GetLeader;
import it.eat.back.web.models.LeaderList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;


/**
 * Me controller
 */
@Controller
public class LeaderController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
    private final LeaderService leaderService;

    /**
     * class constructor
     * @param leaderService LeaderService
     */
    public LeaderController(final LeaderService leaderService) {
        this.leaderService = leaderService;
    }

    /**
     * return leaders leaderboard
     * @param requestObject request from front
     * @return List od leaders
     */
    public ResponseEntity<?> getLeader(final Object requestObject) {
        GetLeader getLeader = gson.fromJson(gson.toJson(requestObject), GetLeader.class);

        try {
            LeaderList leaderList = new LeaderList(leaderService.getLeader(getLeader.getCount()));
//            ArrayList<LeaderItem> leaderItems = leaderService.getLeader(getLeader.getCount());
            return new ResponseEntity<>(leaderList, HttpStatus.OK);
        } catch (Exception e) {
//            e.printStackTrace();
            logger.error(e.toString());
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
}
