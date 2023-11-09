import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dates_provider.g.dart';

@riverpod
class DatesState extends _$DatesState {
  @override
  String build() {
    return "";
  }

  void setDate(String newState) {
    state = newState;
  }
}

@riverpod
class StartTimeState extends _$StartTimeState {
  @override
  String build() {
    return "";
  }

  void setStartTime(String newState) {
    state = newState;
  }

  List<int> dates(DateTime startDate) {
    DateTime now = DateTime.now();
    Duration difference = startDate.difference(now);
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;
    return [days, hours, minutes, seconds];
  }
}

@riverpod
class FinishTimeState extends _$FinishTimeState {
  @override
  String build() {
    return "";
  }

  void setStartTime(String newState) {
    state = newState;
  }
}
