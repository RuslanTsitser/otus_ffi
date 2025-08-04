import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  final dio = Dio();

  File? _image;
  Directory? _tempDir;

  Duration? _rustDuration;
  Duration? _rustDecodeDuration;
  Duration? _flutterDuration;
  Duration? _flutterDecodeDuration;

  String? _rustEncodedResult;
  String? _flutterEncodedResult;

  @override
  void initState() {
    super.initState();
    _initFile();
  }

  Future<void> _initFile() async {
    _tempDir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final file = File(
      '${_tempDir!.path}/image_${now.millisecondsSinceEpoch}.png',
    );
    if (!file.existsSync()) {
      final response = await dio.get(
        'https://picsum.photos/200/300',
        options: Options(responseType: ResponseType.bytes),
      );

      file.writeAsBytesSync(response.data as List<int>);
    }
    setState(() {
      _image = file;
    });
  }

  void _encodeBase64File() {
    if (_image == null) return;
    final stopwatch = Stopwatch()..start();
    final path = _image!.path;
    final now = DateTime.now();
    final newPath = '${_tempDir!.path}/image_${now.millisecondsSinceEpoch}.txt';
    encodeBase64File(path, newPath);
    stopwatch.stop();
    setState(() {
      _rustDuration = stopwatch.elapsed;
      _rustEncodedResult = newPath;
    });
  }

  void _decodeBase64File() {
    if (_rustEncodedResult == null) return;
    final stopwatch = Stopwatch()..start();
    final now = DateTime.now();
    final newPath = '${_tempDir!.path}/image_${now.millisecondsSinceEpoch}.png';
    decodeBase64File(_rustEncodedResult!, newPath);
    stopwatch.stop();
    setState(() {
      _rustDecodeDuration = stopwatch.elapsed;
      _image = File(newPath);
    });
  }

  void _encodeBase64FileWithFlutter() {
    if (_image == null) return;
    final stopwatch = Stopwatch()..start();
    final now = DateTime.now();
    final newPath = '${_tempDir!.path}/image_${now.millisecondsSinceEpoch}.txt';
    final bytes = _image!.readAsBytesSync();
    final base64 = base64Encode(bytes);
    File(newPath).writeAsStringSync(base64);
    stopwatch.stop();
    setState(() {
      _flutterDuration = stopwatch.elapsed;
      _flutterEncodedResult = newPath;
    });
  }

  void _decodeBase64FileWithFlutter() {
    if (_flutterEncodedResult == null) return;
    final stopwatch = Stopwatch()..start();
    final now = DateTime.now();
    final newPath = '${_tempDir!.path}/image_${now.millisecondsSinceEpoch}.txt';
    final base64 = File(_flutterEncodedResult!).readAsStringSync();
    final bytes = base64Decode(base64);
    File(newPath).writeAsBytesSync(bytes);
    stopwatch.stop();
    setState(() {
      _flutterDecodeDuration = stopwatch.elapsed;
      _image = File(newPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          FloatingActionButton.extended(
            heroTag: 'rust_encode',
            onPressed: () {
              _encodeBase64File();
            },
            label: const Text('Rust encode'),
          ),
          FloatingActionButton.extended(
            heroTag: 'flutter_encode',
            onPressed: () {
              _encodeBase64FileWithFlutter();
            },
            label: const Text('Flutter encode'),
          ),
          FloatingActionButton.extended(
            heroTag: 'rust_decode',
            onPressed: () {
              _decodeBase64File();
            },
            label: const Text('Rust decode'),
          ),
          FloatingActionButton.extended(
            heroTag: 'flutter_decode',
            onPressed: () {
              _decodeBase64FileWithFlutter();
            },
            label: const Text('Flutter decode'),
          ),
        ],
      ),
      body: Center(
        child: _image != null
            ? Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Image.file(_image!, key: UniqueKey()),
                  Positioned(
                    bottom: 40,
                    child: Column(
                      children: [
                        Text(
                          'Rust encode: ${_rustDuration?.inMicroseconds} μs',
                        ),
                        Text(
                          'Flutter encode: ${_flutterDuration?.inMicroseconds} μs',
                        ),
                        Text(
                          'Rust decode: ${_rustDecodeDuration?.inMicroseconds} μs',
                        ),
                        Text(
                          'Flutter decode: ${_flutterDecodeDuration?.inMicroseconds} μs',
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: Text('No image')),
      ),
    );
  }
}
