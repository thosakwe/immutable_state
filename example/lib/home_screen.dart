import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';
import 'app_state.dart';
import 'title_editor.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>((context, state) {
      // We can create a child state that modifies the title.
      var titleState = state.property<String>(
        (state) => state.title,
        change: (state, title) => state.changeTitle(title),
      );


      return Scaffold(
        appBar: AppBar(
          title: Text(titleState.current),
        ),
        body: new Column(
          children: <Widget>[

          ],
        ),
      );
    });
  }
}
