import 'package:dart_sandbox/dart_sandbox.dart';
import 'package:test/test.dart';

void main() {
  test('sum', () {
    expect(sum(1, 2), 3);
  });

  test('multiply', () {
    expect(multiply(3, 4), 12);
  });

  test('getStringLength', () {
    expect(getStringLength('Hello, world!'), 'Длина строки 13 символов');
  });
}
