import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';
import 'app_state.dart';

class DateFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>(
      builder: (context, immutable) {
        return FloatingActionButton(
          onPressed: () {
            immutable.change((state) {
              return state.changeDates(
                  new List.from(state.dates)..add(new DateTime.now()));
            });
          },
          child: Icon(Icons.add),
        );
      },
    );
  }
}
