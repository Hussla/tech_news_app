import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return MockUserCredential();
  }

  @override
  Future<void> signOut() async {
    // Mock sign out
  }

  @override
  User? get currentUser {
    return MockUser();
  }
}

class MockUserCredential extends UserCredential {
  @override
  User? get user => MockUser();
}

class MockUser extends User {
  @override
  String? get uid => 'mockUserId';

  @override
  String? get email => 'mockuser@example.com';

  @override
  // Other User methods can be mocked as needed
}