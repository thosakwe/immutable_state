# immutable_state

[![Pub](https://img.shields.io/pub/v/immutable_state.svg)](https://pub.dartlang.org/packages/immutable_state)
[![build status](https://travis-ci.org/thosakwe/immutable_state.svg)](https://travis-ci.org/thosakwe/immutable_state)

🎯 A lightweight framework for UI state management in Flutter and Dart, and an alternative to Redux.

`package:immutable_state` can be used by itself easily, or with ready-made integrations like
`package:flutter_immutable_state`.

# Why?
UI state management in complex applications is a solved problem. Immutable application state,
combined with asynchronous, functional updates, is generally the way to go.

Perhaps the most common implementation of such a pattern is Redux, which is commonly used with
React.

Redux, though, comes with a lot of boilerplate, in addition to not being well-suited for an
object-oriented language like Dart.

The solution outlined in `immutable_state` is simple - to use built-in functionality from
`dart:async` to handle atomic updates.

# Usage
The root of functionality in this package is the `Immutable<T>` class. It is a single-use-only,
immutable wrapper around an arbitrary Dart object that fires an event when its value is updated. As one
can imagine, this works well with value classes (immutable classes that override the `==` operator),
whether hand-written, or generated through libraries like `angel_serialize` or `built_value`.

```dart
main() async {
  var imm = new Immutable<int>(2);
  
  print(imm.current); // Prints '2'
  
  imm.change((n) => n * 2);
  print(await imm.onChange.first); // Prints `4`
  
  imm.replace(4); // Shorthand for writing an entirely new value.
}
```

## Properties and Nesting
The real value of `package:immutable_state` is the ability of `Immutable<T>` to create infinitely-nested
wrappers over smaller parts of an overall application state. This is analogous to `combineReducers` from
the ever-popular Redux.

For example, if you have an `AppState` class as follows:

```dart
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
```

You will likely have components/widgets in your UI that solely deal with `AppState.titleState`, and
therefore don't need access to the rest of the application state.

By calling `Immutable<T>.property`, you can create a scoped state that propagates changes to its parent:

```dart
main() async {
    var appState = new Immutable<AppState>(
      new AppState(
        titleState: new TitleState(
          title: 'Hello!',
        ),
      ),
    );
    
    titleState = appState.property<TitleState>(
      (state) => state.titleState,
    );
    
    // By default, property states are read-only, for convenience.
    //
    // To handle changes, simply provide a `change`
    // callback that updates the parent state.
    titleState = appState.property<TitleState>(
      (state) => state.titleState,
      change: (state, titleState) => state.changeTitleState(titleState),
    );
}
```

The returned value in the above example is an `Immutable<TitleState>`, and UI elements can use
it without even knowing about the existence of the entire `AppState`. This separation of concerns
can be very beneficial in complex applications with many parts of its application state.