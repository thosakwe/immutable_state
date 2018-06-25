# flutter_immutable_state

[![Pub](https://img.shields.io/pub/v/flutter_immutable_state.svg)](https://pub.dartlang.org/packages/flutter_immutable_state)
[![build status](https://travis-ci.org/thosakwe/immutable_state.svg)](https://travis-ci.org/thosakwe/immutable_state)

🦋 A lightweight framework for stateless UI in Flutter, and an alternative to Redux.

# Why?
View the rationale, along with the documentation for the underlying
`package:immutable_state` library at the homepage:
https://github.com/thosakwe/immutable_state

This package is useless without understanding of the purpose thereof.

# Usage
To inject an application state into the tree, simply use the `ImmutableManager<T>` widget.

For example:

```dart
import 'package:flutter/material.dart';
import 'app_state.dart';
import 'example_app.dart';

void main() {
  runApp(ExampleApp(
    initialValue: new AppState(
      title: 'Hello, immutables!',
      checked: false,
      dates: [],
    ),
  ));
}
```

Where your `ExampleApp` might look like:

```dart
class ExampleApp extends StatelessWidget {
  final AppState initialValue;

  const ExampleApp({Key key, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImmutableManager<AppState>(
      initialValue: initialValue,
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
```

To access the current value of the state, you simply need an `ImmutableView<T>`.
The `builder` callback can be used to query the current state and render a view:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';
import 'app_state.dart';

class TitleEditor extends StatelessWidget {
  const TitleEditor();

  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>(
      builder: (context, immutable) {
        return TextField(
          onChanged: (title) => immutable.change((s) => s.changeTitle(title)),
          controller: new TextEditingController(text: immutable.current.title),
        );
      },
    );
  }
}
```

By using the `Immutable<T>.change` method, you can update the state with a modified version of
the current one. However, there are often cases where you need read-only access only, and writing
data is unnecessary. For such a case, call `ImmutableView<T>.readOnly`:

```dart
Widget build(BuildContext contet) {
  return new ImmutableView<AppState>.readOnly(
    builder: (context, state) {
      return Text(state.title);
    },
  );
}
```

# Nesting and Properties
Redux is nice, in part because of its `combineReducers` functionality, which allows
you to split application logic into smaller units. In Dart, this doesn't map so well,
as objects need to have specific type, and the language has no concept of a
spread operator.

For this, the `Immutable<T>` class has a method `property` that produces a child immutable
that points to a property of the main state. This child state can also process updates, thereby
triggering a change in the parent. Through the use of `Immutable<T>.property`, you can build
infinitely-nested trees of immutable application state.

Because of how often this is used, the `ImmutablePropertyManager<T>` class exists:

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>(
      builder: (context, immutable) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TitleEditor(),
                CheckedView(),

                // We can create a child state that modifies the title.
                //
                // By passing an `ImmutableManager<String>` pointing to this child state down the tree,
                // we can have child widgets access infinitely nested parts of a single
                // application state.
                ImmutablePropertyManager<AppState, List<DateTime>>(
                  current: (state) => state.dates,
                  child: DateView(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```