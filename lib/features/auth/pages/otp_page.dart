import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_todo_app/common/utils/constants.dart';
import 'package:riverpod_todo_app/common/widgets/appstyle.dart';
import 'package:riverpod_todo_app/common/widgets/reusable_text.dart';
import 'package:riverpod_todo_app/features/auth/controllers/auth_controller.dart';

class OTPPage extends ConsumerWidget {
  const OTPPage({super.key, required this.smsCodeId, required this.phone});

  final String smsCodeId;
  final String phone;

  void verifyOtpCode(BuildContext context, WidgetRef ref, String smsCode) {
    ref.read(authControllerProvider).verifyOtpCode(
        context: context,
        smsCodeId: smsCodeId,
        smsCode: smsCode,
        mounted: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Image.asset(
                  "assests/images/todo.png",
                  width: 200,
                ),
              ),
              SizedBox(
                height: 26,
              ),
              ReusableText(
                text: "Enter Your OTP Code",
                style: appstyle(18, AppConst.kLight, FontWeight.bold),
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (value) {
                  if (value.length == 6) {
                    return verifyOtpCode(context, ref, value);
                  }
                },
                onSubmitted: (value) {
                  if (value.length == 6) {
                    return verifyOtpCode(context, ref, value);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
