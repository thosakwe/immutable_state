import 'package:meta/meta.dart';

/// A simple immutable application state.
class AppState {
  final String title;
  final bool checked;
  final List<DateTime> dates;

  AppState(
      {@required this.title, @required this.checked, @required this.dates});

  AppState changeTitle(String newTitle) =>
      new AppState(title: newTitle, checked: checked, dates: dates);

  AppState changeChecked(bool newChecked) =>
      new AppState(title: title, checked: newChecked, dates: dates);

  AppState changeDates(List<DateTime> newDates) =>
      new AppState(title: title, checked: checked, dates: newDates);

  @override
  String toString() {
    return 'AppState($title, $checked, $dates)';
  }
}

