import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';

/// TLDR; Use `ImmutableManager`, `ImmutablePropertyManager`, and `ImmutableView`.
void main() {
  var initialValue = AppState(
    titleState: TitleState(
      title: 'Hello!',
    ),
  );

  runApp(ImmutableManager<AppState>(
    initialValue: initialValue,
    child: MaterialApp(
      home: TitleText(),
    ),
  ));
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
