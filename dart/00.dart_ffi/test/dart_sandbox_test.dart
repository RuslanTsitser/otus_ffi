import 'package:dart_sandbox/dart_sandbox.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(sum(1, 2), 3);
    expect(multiply(5, 6), 30);
  });
}
