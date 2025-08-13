import 'package:dart_sandbox/dart_sandbox.dart' as dart_sandbox;

void main(List<String> arguments) {
  print(dart_sandbox.getStringLengthWithStatic('Hello, world!'));
  print(dart_sandbox.getStringLengthWithMalloc('Goodbye, world!'));
}
