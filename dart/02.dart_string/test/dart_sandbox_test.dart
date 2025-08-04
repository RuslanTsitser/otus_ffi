import 'package:dart_sandbox/dart_sandbox.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(getStringLength('Hello, world!'), 'Длина строки 13 символов');
  });
}
