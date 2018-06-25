import 'package:flutter/material.dart';
import 'package:flutter_state/flutter_state.dart';
import 'app_state.dart';
import 'home_screen.dart';

class ExampleApp extends StatelessWidget {
  final AppState initialValue;

  const ExampleApp({Key key, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImmutableManager<AppState>(
      initialValue: initialValue,
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
