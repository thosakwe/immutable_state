import 'package:flutter/material.dart';
import 'app_state.dart';
import 'example_app.dart';

void main() {
  runApp(ExampleApp(
    initialValue: new AppState(
      title: 'Hello, immutables!',
      checked: false,
      dates: [],
    ),
  ));
}
