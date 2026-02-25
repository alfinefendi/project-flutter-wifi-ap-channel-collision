import 'package:uuid/uuid.dart';

String generateUuid() {
  return Uuid().v1();
}

int? calculateFreqChannel(int? freq) {

  if (freq == null) return null;

  const freqDivideBy = 5;
  const freq2GhzMin = 2412;
  const freq2GhzMax = 2472;
  const freq2GhzJapan = 2484;
  const freq5GhzMin = 5180;
  const freq5GhzMax = 5825;
  const freq2GhzBaseLine = 2407;
  const freq5GhzBaseLine = 5000;

  late int channel;

  if (freq >= freq2GhzMin && freq <= freq2GhzMax) {
    channel = (freq - freq2GhzBaseLine) ~/ freqDivideBy;
  } else if (freq == freq2GhzJapan) {
    channel = 14;
  } else if (freq >= freq5GhzMin && freq <= freq5GhzMax) {
    channel = (freq - freq5GhzBaseLine) ~/ freqDivideBy;
  } else {
    channel = -1;
  }

  return channel;
}
