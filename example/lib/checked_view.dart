import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';
import 'app_state.dart';

class CheckedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>(
      builder: (context, immutable) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Checked: '),
            Switch(
              value: immutable.current.checked,
              onChanged: (checked) =>
                  immutable.change((s) => s.changeChecked(checked)),
            ),
          ],
        );
      },
    );
  }
}
