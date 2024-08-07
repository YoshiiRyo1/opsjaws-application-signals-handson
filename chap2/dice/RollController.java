// RollController.java
package otel;

import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import otel.Dice;

@RestController
public class RollController {
  private static final Logger logger = LoggerFactory.getLogger(RollController.class);

  @GetMapping("/rolldice")
  public List<Integer> index(@RequestParam("player") Optional<String> player,
      @RequestParam("rolls") Optional<Integer> rolls) {

    if (!rolls.isPresent()) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Missing rolls parameter", null);
    }

    List<Integer> result = new Dice(1, 6).rollTheDice(rolls.get());

    if (player.isPresent()) {
      logger.info("{} is rolling the dice: {}", player.get(), result);
    } else {
      logger.info("Anonymous player is rolling the dice: {}", result);
    }
    return result;
  }
}
