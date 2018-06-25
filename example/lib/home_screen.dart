import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';
import 'app_state.dart';
import 'title_editor.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>((context, state) {
      // We can create a child state that modifies the title.
      //
      // By passing an `ImmutableManager<String>` pointing to this child state down the tree,
      // we can have child widgets access infinitely nested parts of a single
      // application state.
      var titleImmutable = state.property<String>(
        (state) => state.title,
        change: (state, title) => state.changeTitle(title),
      );

      return Scaffold(
        appBar: AppBar(
          title: Text(titleImmutable.current),
        ),
        body: Column(
          children: <Widget>[
            ImmutableManager(
              immutable: titleImmutable,
              child: TitleEditor(),
            ),
          ],
        ),
      );
    });
  }
}
