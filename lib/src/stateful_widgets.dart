import 'package:flutter/widgets.dart';
import 'package:flutter_state/flutter_state.dart';
import 'package:meta/meta.dart' hide Immutable;

/// A [StatefulWidget] that injects an [Immutable] wrapping the state of an application.
class ImmutableManager<T> extends StatefulWidget {
  /// An initial value for the state.
  ///
  /// Mutually exclusive with [immutable].
  final T initialValue;

  /// An existing immutable to inject.
  ///
  /// Mutually exclusive with [initialValue].
  final Immutable<T> immutable;

  final Widget child;

  ImmutableManager(
      {Key key, this.initialValue, this.immutable, @required this.child})
      : super(key: key) {
    assert(initialValue == null || immutable == null);
    assert(initialValue != null || immutable != null);
  }

  @override
  State<StatefulWidget> createState() {
    return new ImmutableManagerState<T>();
  }
}

/// The current state of an [ImmutableManager].
class ImmutableManagerState<T> extends State<ImmutableManager<T>> {
  final List<Immutable> toClose = [];
  T value;

  @override
  void initState() {
    super.initState();
    value = widget.immutable?.current ?? widget.initialValue;
  }

  @override
  void deactivate() {
    for (var immutable in toClose) {
      if (!immutable.isClosed) immutable.close();
    }

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) =>
      new InheritedImmutableState(this, widget.child);

  /// Triggers a state change.
  void change(T value) {
    setState(() {
      print('Got: $value');
      if (widget.immutable != null) {
        this.value = value;
        widget.immutable.change((_) => value);
      } else {
        this.value = value;
      }
    });
  }
}

class InheritedImmutableState<T> extends InheritedWidget {
  final ImmutableManagerState<T> state;
  final Widget child;

  InheritedImmutableState(this.state, this.child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedImmutableState<T> oldWidget) =>
      oldWidget.state.value != state.value;
}
