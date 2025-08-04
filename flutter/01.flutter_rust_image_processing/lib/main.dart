import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
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
  Duration? _flutterDuration;

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

  void _rotateImageWithRust() {
    if (_image == null) return;
    final stopwatch = Stopwatch()..start();
    final path = _image!.path;
    final now = DateTime.now();
    final newPath = '${_tempDir!.path}/image_${now.millisecondsSinceEpoch}.png';
    rotateImage90(path, newPath);
    setState(() {
      _image = File(newPath);
    });
    stopwatch.stop();
    setState(() {
      _rustDuration = stopwatch.elapsed;
    });
  }

  void _rotateImageWithFlutter() {
    if (_image == null) return;
    final stopwatch = Stopwatch()..start();
    final image = img.decodeImage(_image!.readAsBytesSync())!;
    final rotated = img.copyRotate(image, angle: 90);
    final bytes = img.encodeJpg(rotated);
    final now = DateTime.now();
    final newPath = '${_tempDir!.path}/image_${now.millisecondsSinceEpoch}.jpg';
    File(newPath).writeAsBytesSync(bytes);
    setState(() {
      _image = File(newPath);
    });
    stopwatch.stop();
    setState(() {
      _flutterDuration = stopwatch.elapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          FloatingActionButton.extended(
            heroTag: 'rust',
            onPressed: () {
              _rotateImageWithRust();
            },
            label: const Text('Rust'),
          ),
          FloatingActionButton.extended(
            heroTag: 'flutter',
            onPressed: () {
              _rotateImageWithFlutter();
            },
            label: const Text('Flutter'),
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
                        Text('Rust: ${_rustDuration?.inMilliseconds} ms'),
                        Text('Flutter: ${_flutterDuration?.inMilliseconds} ms'),
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
