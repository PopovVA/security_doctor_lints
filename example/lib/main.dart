// Every Dart-side security_doctor rule fires in this file. Open it in
// an IDE with custom_lint enabled to see the squiggles.
import 'dart:developer';

// sd001 — hardcoded secret.
const awsAccessKey = 'AKIAIOSFODNN7RE4LKEY';

// sd002 — cleartext URL (comes with a "Use https://" quick fix).
const apiBase = 'http://api.example.com/v1';

Future<void> persist(dynamic prefs, String authToken) async {
  // sd003 — sensitive key in SharedPreferences.
  await prefs.setString('authToken', authToken);
}

void hash(dynamic md5, List<int> bytes) {
  // sd004 — weak cryptography.
  md5.convert(bytes);
}

void dump(String password) {
  // sd008 — credentials in log output.
  log('password: $password');
}
