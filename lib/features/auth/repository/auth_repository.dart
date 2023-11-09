import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_todo_app/common/helpers/db_helper.dart';
import 'package:riverpod_todo_app/common/widgets/showDialogue.dart';

import '../../../common/routes/routes.dart';

final AuthRepositoryProvider = Provider((ref) {
  return AuthRepository(auth: FirebaseAuth.instance);
});

class AuthRepository {
  final FirebaseAuth auth;
  AuthRepository({required this.auth});
  void verifyOTP({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: smsCodeId, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      if (!mounted) {
        return;
      }
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    } on FirebaseAuth catch (e) {
      showAlertDialg(context: context, message: e.toString());
    }
  }

  void sendOtp({
    required BuildContext context,
    required String phone,
  }) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            showAlertDialg(context: context, message: e.toString());
          },
          codeSent: (smsCodeId, resendCodeId) {
            DbHelper.createUser(1);
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.otp, (route) => false,
                arguments: {'phone': phone, 'smsCodeId': smsCodeId});
          },
          codeAutoRetrievalTimeout: (String smsCodeId) {});
    } on FirebaseAuth catch (e) {
      showAlertDialg(context: context, message: e.toString());
    }
  }
}
