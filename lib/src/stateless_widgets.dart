import 'package:flutter/material.dart';
import 'immutable.dart';
import 'stateful_widgets.dart';

/// A "functional" [Widget] that produces a view of an [Immutable] object.
class ImmutableView<T> extends StatelessWidget {
  final Widget Function(BuildContext, Immutable<T>) builder;

  const ImmutableView(this.builder, {Key key}) : super(key: key);

  /// Creates an [ImmutableView] that only accesses the current value, and is guaranteed to never update the [Immutable].
  factory ImmutableView.readOnly(Widget Function(BuildContext, T) builder,
          {Key key}) =>
      new ImmutableView<T>((context, state) => builder(context, state.current),
          key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, Immutable.of<T>(context));
  }
}
