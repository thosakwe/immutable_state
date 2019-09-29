import 'package:immutable_state/immutable_state.dart';

void main() {
  var appState = Immutable(
    AppState(
      titleState: TitleState(
        title: 'Hello!',
      ),
    ),
  );

  var titleState = appState.property(
    (state) => state.titleState,
    change: (state, TitleState titleState) =>
        state.changeTitleState(titleState),
  );

  // Changes propagate to the parent...
  titleState.change((state) => state.changeTitle('world'));
}

class AppState {
  final TitleState titleState;

  AppState({this.titleState});

  @override
  bool operator ==(other) =>
      other is AppState && other.titleState == titleState;

  AppState changeTitleState(TitleState titleState) =>
      AppState(titleState: titleState);
}

class TitleState {
  final String title;

  TitleState({this.title});

  @override
  bool operator ==(other) => other is TitleState && other.title == title;

  TitleState changeTitle(String title) => TitleState(title: title);
}
