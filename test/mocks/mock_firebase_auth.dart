import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
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

  @override
  Stream<User?> authStateChanges() {
    return Stream.value(MockUser());
  }

  @override
  Stream<User?> userChanges() {
    return Stream.value(MockUser());
  }

  @override
  FirebaseApp get app => MockFirebaseApp();
}

class MockFirebaseApp extends Mock implements FirebaseApp {
  @override
  String get name => 'mock_app';

  @override
  FirebaseOptions get options => MockFirebaseOptions();
}

class MockFirebaseOptions implements FirebaseOptions {
  @override
  String get apiKey => 'mock_api_key';

  @override
  String get appId => 'mock_app_id';

  @override
  String get messagingSenderId => 'mock_sender_id';

  @override
  String get projectId => 'mock_project_id';

  @override
  String? get authDomain => 'mock_auth_domain';

  @override
  String? get databaseURL => 'mock_database_url';

  @override
  String? get storageBucket => 'mock_storage_bucket';

  @override
  String? get measurementId => 'mock_measurement_id';

  @override
  String? get trackingId => 'mock_tracking_id';

  @override
  String? get deepLinkURLScheme => 'mock_deep_link_scheme';

  @override
  String? get androidClientId => 'mock_android_client_id';

  @override
  String? get iosClientId => 'mock_ios_client_id';

  @override
  String? get iosBundleId => 'mock_ios_bundle_id';

  @override
  String? get appGroupId => 'mock_app_group_id';

  @override
  FirebaseOptions copyWith({
    String? apiKey,
    String? appId,
    String? messagingSenderId,
    String? projectId,
    String? authDomain,
    String? databaseURL,
    String? storageBucket,
    String? measurementId,
    String? trackingId,
    String? deepLinkURLScheme,
    String? androidClientId,
    String? iosClientId,
    String? iosBundleId,
    String? appGroupId,
  }) {
    return MockFirebaseOptions();
  }

  @override
  Map<String, String?> get asMap => {
    'apiKey': apiKey,
    'appId': appId,
    'messagingSenderId': messagingSenderId,
    'projectId': projectId,
    'authDomain': authDomain,
    'databaseURL': databaseURL,
    'storageBucket': storageBucket,
    'measurementId': measurementId,
    'trackingId': trackingId,
    'deepLinkURLScheme': deepLinkURLScheme,
    'androidClientId': androidClientId,
    'iosClientId': iosClientId,
    'iosBundleId': iosBundleId,
    'appGroupId': appGroupId,
  };
}

class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => MockUser();

  @override
  AdditionalUserInfo? get additionalUserInfo => null;

  @override
  AuthCredential? get credential => null;
}

class MockUser extends Mock implements User {
  @override
  String get uid => 'mockUserId';

  @override
  String? get email => 'mockuser@example.com';

  @override
  String? get displayName => 'Mock User';

  @override
  bool get emailVerified => true;

  @override
  bool get isAnonymous => false;

  @override
  UserMetadata get metadata => MockUserMetadata();

  @override
  String? get phoneNumber => null;

  @override
  String? get photoURL => null;

  @override
  List<UserInfo> get providerData => [];

  @override
  String? get refreshToken => 'mock_refresh_token';

  @override
  String? get tenantId => null;

  @override
  Future<void> delete() async {}

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async {
    return 'mock_id_token';
  }

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async {
    return MockIdTokenResult();
  }

  @override
  Future<void> reload() async {}

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async {
    return MockUserCredential();
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    return MockUserCredential();
  }

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}

  @override
  Future<User> unlink(String providerId) async {
    return this;
  }

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updateEmail(String newEmail) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) async {}
}

class MockUserMetadata extends Mock implements UserMetadata {
  @override
  DateTime? get creationTime => DateTime.now();

  @override
  DateTime? get lastSignInTime => DateTime.now();
}

class MockIdTokenResult extends Mock implements IdTokenResult {
  @override
  String get token => 'mock_id_token';

  @override
  DateTime? get authTime => DateTime.now();

  @override
  Map<String, dynamic>? get claims => {};

  @override
  DateTime? get expirationTime => DateTime.now().add(const Duration(hours: 1));

  @override
  DateTime? get issuedAtTime => DateTime.now();

  @override
  String? get signInProvider => 'password';
}