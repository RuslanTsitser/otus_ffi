import 'package:flutter/material.dart';

import 'ffi_lib.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textController = TextEditingController();
  String result = '';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _executePythonCode() {
    try {
      final output = executePythonCodeWithOutput(textController.text);
      setState(() {
        result = output;
      });
    } catch (e) {
      setState(() {
        result = 'Ошибка: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Execution via Rust FFI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'rust_execute',
        onPressed: _executePythonCode,
        label: const Text('Выполнить Python'),
        icon: const Icon(Icons.play_arrow),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Python код',
                hintText: 'print("Hello from Python!")',
              ),
            ),
            const SizedBox(height: 16),
            if (result.isNotEmpty)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: result.contains('Ошибка')
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: result.contains('Ошибка')
                          ? Colors.red.shade300
                          : Colors.green.shade300,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      result,
                      style: TextStyle(
                        color: result.contains('Ошибка')
                            ? Colors.red.shade800
                            : Colors.green.shade800,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
