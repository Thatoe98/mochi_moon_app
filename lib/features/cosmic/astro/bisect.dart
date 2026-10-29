/// The instant between [before] and [after] where [reached] flips from false
/// to true, found by bisection to within [tolerance].
///
/// [reached] must be false at [before] and true at [after].
DateTime bisectInstant({
  required DateTime before,
  required DateTime after,
  required bool Function(DateTime utc) reached,
  required Duration tolerance,
}) {
  var low = before;
  var high = after;
  while (high.difference(low) > tolerance) {
    final middle = low.add(high.difference(low) ~/ 2);
    if (reached(middle)) {
      high = middle;
    } else {
      low = middle;
    }
  }
  return low.add(high.difference(low) ~/ 2);
}
