enum ScoreBand { low, medium, high }

ScoreBand determineScoreBand(score) {
  if (score <= 33) {
    return ScoreBand.low;
  }
  if (score <= 66) {
    return ScoreBand.medium;
  }
  return ScoreBand.high;
}
