import 'package:flutter/material.dart';

import 'ffi_lib.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Hello World!')),
        floatingActionButton: TestButton(),
      ),
    );
  }
}

class TestButton extends StatelessWidget {
  const TestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final result = sum(1, 2);
        print(result);
      },
      child: const Icon(Icons.add),
    );
  }
}
