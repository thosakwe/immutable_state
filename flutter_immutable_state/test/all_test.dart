import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// These tests *only* test the functionality of the Flutter widgets.
///
/// The tests for the actual immutable functionality are in `package:immutable_state`.
void main() {
  var initialValue = AppState(
    titleState: TitleState(
      title: 'Hello!',
    ),
  );

  testWidgets(
      'ImmutableManager sends down current and ImmutableView can read it',
      (WidgetTester tester) async {
    var key = new UniqueKey();
    await tester.pumpWidget(ImmutableManager<AppState>(
      initialValue: initialValue,
      child: MaterialApp(
        home: TitleText(
          textKey: key,
        ),
      ),
    ));

    var text = tester.firstWidget<Text>(find.byKey(key));
    expect(text.data, initialValue.titleState.title);
  });

  testWidgets('ImmutablePropertyManager injects state from parent',
      (WidgetTester tester) async {
    var key = new UniqueKey();
    await tester.pumpWidget(ImmutableManager<AppState>(
      initialValue: initialValue,
      child: MaterialApp(
        home: ImmutablePropertyManager<AppState, TitleState>(
          current: (state) => state.titleState,
          child: PropertyTitleText(
            textKey: key,
          ),
        ),
      ),
    ));

    var text = tester.firstWidget<Text>(find.byKey(key));
    expect(text.data, initialValue.titleState.title);
  });

  testWidgets('Data changes update widgets in the tree',
      (WidgetTester tester) async {
    var key = new UniqueKey(), buttonKey = new UniqueKey();
    await tester.pumpWidget(ImmutableManager<AppState>(
      initialValue: initialValue,
      child: MaterialApp(
        home: ImmutablePropertyManager<AppState, TitleState>(
          current: (state) => state.titleState,
          change: (state, titleState) => state.changeTitleState(titleState),
          child: Column(
            children: <Widget>[
              PropertyTitleText(
                textKey: key,
              ),
              TitleChanger(
                buttonKey: buttonKey,
              ),
            ],
          ),
        ),
      ),
    ));

    await tester.tap(find.byKey(buttonKey));

    // Wait 5 seconds. By then, the UI should have updated for sure.
    await tester.pump(const Duration(seconds: 5));

    var text = tester.firstWidget<Text>(find.byKey(key));
    expect(text.data, 'world');
  });
}

class TitleText extends StatelessWidget {
  final Key textKey;

  const TitleText({Key key, this.textKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>.readOnly(
      builder: (context, state) {
        return Text(
          state.titleState.title,
          key: textKey,
        );
      },
    );
  }
}

class PropertyTitleText extends StatelessWidget {
  final Key textKey;

  const PropertyTitleText({Key key, this.textKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImmutableView<TitleState>.readOnly(
      builder: (context, state) {
        return Text(
          state.title,
          key: textKey,
        );
      },
    );
  }
}

class TitleChanger extends StatelessWidget {
  final Key buttonKey;

  const TitleChanger({Key key, this.buttonKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImmutableView<TitleState>(
      builder: (context, state) {
        return FlatButton(
          key: buttonKey,
          child: const Text('CLICK ME'),
          onPressed: () => state.change((state) => state.changeTitle('world')),
        );
      },
    );
  }
}

class AppState {
  final TitleState titleState;

  AppState({this.titleState});

  @override
  int get hashCode => titleState.hashCode;

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
  int get hashCode => title.hashCode;

  @override
  bool operator ==(other) => other is TitleState && other.title == title;

  TitleState changeTitle(String title) => new TitleState(title: title);
}
