package otel;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public class Dice {

  private int min;
  private int max;

  public Dice(int min, int max) {
    this.min = min;
    this.max = max;
  }

  public List<Integer> rollTheDice(int rolls) {
    List<Integer> results = new ArrayList<Integer>();
    for (int i = 0; i < rolls; i++) {
      results.add(this.rollOnce());
    }
    return results;
  }

  private int rollOnce() {
    return ThreadLocalRandom.current().nextInt(this.min, this.max + 1);
  }
}
