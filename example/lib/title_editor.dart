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
