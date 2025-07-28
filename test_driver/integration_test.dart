import 'package:flutter_test/flutter_test.dart';
import '../test/test_config.dart';
import '../test/mocks/mock_firebase_auth.dart';

void main() {
  TestConfig testConfig;

  setUp(() {
    testConfig = TestConfig();
    testConfig.setupMocks();
  });

  test('Integration test example', () async {
    final result = await testConfig.someFunctionality();
    expect(result, isNotNull);
  });
}