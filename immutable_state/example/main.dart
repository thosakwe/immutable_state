import 'package:immutable_state/immutable_state.dart';

void main() {
  var appState = new Immutable(
    new AppState(
      titleState: new TitleState(
        title: 'Hello!',
      ),
    ),
  );

  var titleState = appState.property(
    (state) => state.titleState,
    change: (state, titleState) => state.changeTitleState(titleState),
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
      new AppState(titleState: titleState);
}

class TitleState {
  final String title;

  TitleState({this.title});

  @override
  bool operator ==(other) => other is TitleState && other.title == title;

  TitleState changeTitle(String title) => new TitleState(title: title);
}
