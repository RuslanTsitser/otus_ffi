import 'package:dart_sandbox/dart_sandbox.dart' as dart_sandbox;

void main(List<String> arguments) {
  print(dart_sandbox.sum(1, 2));
  print(dart_sandbox.multiply(3, 4));
  print(dart_sandbox.getStringLength('Hello, world!'));
  final stopwatch = Stopwatch()..start();
  print(dart_sandbox.factorialsOfIntArray([1, 2, 3, 4, 5]));
  stopwatch.reset();
  print(stopwatch.elapsed);
  stopwatch.start();
  print(dart_sandbox.factorialsOfIntArrayDart([1, 2, 3, 4, 5]));
  stopwatch.stop();
  print(stopwatch.elapsed);
}
