import 'package:immutable_state/immutable_state.dart';
import 'package:test/test.dart';

void main() {
  Immutable<AppState> appState;
  Immutable<TitleState> titleState;

  setUp(() {
    appState = new Immutable(
      new AppState(
        titleState: new TitleState(
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
        new AppState(
          titleState: new TitleState(
            title: 'world',
          ),
        ),
      ),
    );
  });

  test('can have properties as well', () async {
    int newLength;

    var lengthState = titleState.property(
      (state) => state.title.length,
      change: (state, length) {
        newLength = length;
      },
    );

    expect(lengthState.current, titleState.current.title.length);
    lengthState.replace(-12345678);
    await appState.onChange.first;
    expect(newLength, -12345678);
  });
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
