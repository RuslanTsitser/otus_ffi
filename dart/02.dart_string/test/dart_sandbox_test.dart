import 'package:dart_sandbox/dart_sandbox.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(
      getStringLengthWithStatic('Hello, world!'),
      'Длина строки 13 символов',
    );
  });
}
