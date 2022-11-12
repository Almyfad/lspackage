class LSDuration extends Duration {
  Duration duration;
  LSDuration({
    required this.duration,
  });
  int toMap() => duration.inMilliseconds;
  factory LSDuration.fromDuration(Duration m) => LSDuration(duration: m);
  factory LSDuration.fromMap(dynamic m) =>
      LSDuration(duration: Duration(milliseconds: m));
}
