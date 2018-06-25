import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';

class TitleEditor extends StatelessWidget {
  const TitleEditor();

  @override
  Widget build(BuildContext context) {
    return ImmutableView<String>((context, state) {
      return TextField(
        onChanged: state.replace,
        controller: new TextEditingController(text: state.current),
      );
    });
  }
}
