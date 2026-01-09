import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  ConfirmationResult? _webConfirmationResult;
  bool isLoading = false;

  User? get currentUser => _auth.currentUser;

  /// Send OTP (Android, iOS, Web)
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required VoidCallback onCodeSent,
    required void Function(FirebaseAuthException e) onFailed,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      if (kIsWeb) {
         final confirmationResult =
          await FirebaseAuth.instance.signInWithPhoneNumber(
            phoneNumber
          );
          _webConfirmationResult = confirmationResult;

        isLoading = false;
        notifyListeners();
        onCodeSent();
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            isLoading = false;
            notifyListeners();
          },
          verificationFailed: (FirebaseAuthException e) {
            isLoading = false;
            notifyListeners();
            onFailed(e);
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            isLoading = false;
            notifyListeners();
            onCodeSent();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Verify OTP (Android, iOS, Web)
  Future<UserCredential> verifyOTP(String smsCode) async {
    if (kIsWeb) {
      if (_webConfirmationResult == null) {
        throw Exception("No web confirmation result found");
      }
      return await _webConfirmationResult!.confirm(smsCode);
    }

    if (_verificationId == null) {
      throw Exception("No verification ID found");
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    return await _auth.signInWithCredential(credential);
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
