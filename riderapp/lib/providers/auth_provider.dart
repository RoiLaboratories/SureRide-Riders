import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart' as _firebaseAuth;

/// Riverpod provider
final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier {
  final _firebaseAuth.FirebaseAuth _auth = _firebaseAuth.FirebaseAuth.instance;

  String? verificationId;
  bool isLoading = false;

  /// Send verification code to phone
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(_firebaseAuth.FirebaseAuthException e) onFailed,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (_firebaseAuth.PhoneAuthCredential credential) async {
          // Auto verification (Android only)
          await _auth.signInWithCredential(credential);
          isLoading = false;
          notifyListeners();
        },
        verificationFailed: (_firebaseAuth.FirebaseAuthException e) {
          isLoading = false;
          notifyListeners();
          onFailed(e);
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          isLoading = false;
          notifyListeners();
          onCodeSent(verId);
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Verify OTP
  Future<_firebaseAuth.UserCredential> verifyOTP(String smsCode) async {
    if (verificationId == null) {
      throw Exception("Verification ID is null");
    }

    final credential = _firebaseAuth.PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );

    return await _auth.signInWithCredential(credential);
  }

  /// Current user
  _firebaseAuth.User? get currentUser => _auth.currentUser;

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
