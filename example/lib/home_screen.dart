import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';
import 'app_state.dart';
import 'checked_view.dart';
import 'date_fab.dart';
import 'date_view.dart';
import 'title_editor.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImmutableView<AppState>(
      builder: (context, immutable) {
        return Scaffold(
          appBar: AppBar(
            title: Text(immutable.current.title),
          ),
          floatingActionButton: DateFab(),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TitleEditor(),
                CheckedView(),

                // We can create a child state that modifies the title.
                //
                // By passing an `ImmutableManager<String>` pointing to this child state down the tree,
                // we can have child widgets access infinitely nested parts of a single
                // application state.
                ImmutablePropertyManager<AppState, List<DateTime>>(
                  current: (state) => state.dates,
                  child: DateView(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
