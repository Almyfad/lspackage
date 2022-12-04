extension DurationExtension on Duration {
  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  String get toHH => _twoDigits(inHours);
  String get remainingMinutes => _twoDigits(inMinutes.remainder(60));
  String get remainingSeconds => _twoDigits(inSeconds.remainder(60));
  String get toHHMM => "$toHH:$remainingMinutes";
  String get toHHMMSS => "$toHHMM:$remainingSeconds";
}
