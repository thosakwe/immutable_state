import 'package:flutter/material.dart';
import 'package:immutable_state/immutable_state.dart';
import 'package:meta/meta.dart' hide Immutable;
import 'stateful_widgets.dart';

/// A "functional" [Widget] that produces a view of an [Immutable] object.
class ImmutableView<T> extends StatelessWidget {
  final Widget Function(BuildContext, Immutable<T>) builder;

  const ImmutableView({@required this.builder, Key key}) : super(key: key);

  /// Creates an [ImmutableView] that only accesses the current value, and is guaranteed to never update the [Immutable].
  factory ImmutableView.readOnly(
          {@required Widget Function(BuildContext, T) builder, Key key}) =>
      new ImmutableView<T>(
          builder: (context, state) => builder(context, state.current),
          key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, InheritedImmutableState.of<T>(context));
  }
}

/// A wrapper around [ImmutableManager] that maps to a property.
class ImmutablePropertyManager<T, U> extends StatelessWidget {
  final U Function(T) current;
  final T Function(T, U) change;
  final Widget child;

  //final Widget Function(BuildContext, Immutable<U>) builder;

  const ImmutablePropertyManager(
      {Key key, @required this.current, @required this.child, this.change})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ImmutableView<T>(
      builder: (context, state) {
        return new ImmutableManager(
          immutable: state.property(current, change: change),
          child: child,
        );
      },
    );
  }
}
