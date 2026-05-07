import 'package:babylog/pages/babylogauth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('requires email verification only for password auth users', () {
    expect(authProviderRequiresEmailVerification(['password']), isTrue);
    expect(authProviderRequiresEmailVerification(['google.com']), isFalse);
    expect(
      authProviderRequiresEmailVerification(['google.com', 'password']),
      isTrue,
    );
    expect(authProviderRequiresEmailVerification([]), isFalse);
  });
}
