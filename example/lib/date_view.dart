import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';

class DateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImmutableView<List<DateTime>>(
      builder: (context, immutable) {
        if (immutable.current.isEmpty) {
          return Text('No dates yet... Hit the "+"!');
        }

        return Column(
            children: immutable.current
                .map((dateTime) => Text(dateTime.toIso8601String()))
                .toList()
                .reversed
                .take(25)
                .toList());
      },
    );
  }
}
