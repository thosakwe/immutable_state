# flutter_state

🦋 A lightweight framework for stateless UI in Flutter, and an alternative to Redux.

**Marked as beta until tests are published, and Travis is set up.**

# Why?
UI state management in complex applications is a solved problem. Immutable application state,
combined with asynchronous, functional updates, is generally the way to go.

Perhaps the most common implementation of such a pattern is Redux, which is commonly used with
React.

Redux, though, comes with a lot of boilerplate, in addition to not being well-suited for an
object-oriented language like Dart.

The solution outlined in `flutter_state` is simple - to use built-in functionality from
`dart:async` to handle updates, and to use the `InheritedWidget` pattern to inject application
state everywhere.

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