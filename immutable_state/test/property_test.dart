import 'package:immutable_state/immutable_state.dart';
import 'package:test/test.dart';

void main() {
  Immutable<AppState> appState;
  Immutable<TitleState> titleState;

  setUp(() {
    appState = Immutable(
      AppState(
        titleState: TitleState(
          title: 'Hello!',
        ),
      ),
    );

    titleState = appState.property(
      (state) => state.titleState,
      change: (state, titleState) => state.changeTitleState(titleState),
    );
  });

  tearDown(() {
    appState.close();
  });

  test('current reflects parent current', () {
    expect(titleState.current, appState.current.titleState);
  });

  test('onChange is listened to by parent', () {
    expect(() => titleState.onChange.listen(print), throwsStateError);
  });

  test('change propagates to parent', () {
    titleState.change((state) => state.changeTitle('world'));
    expect(
      appState.onChange.first,
      completion(
        AppState(
          titleState: TitleState(
            title: 'world',
          ),
        ),
      ),
    );
  });

  test('can have properties as well', () async {
    int newLength;

    var lengthState = titleState.property(
      (state) => newLength ?? state.title.length,
    );

    expect(lengthState.current, titleState.current.title.length);
  });
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
