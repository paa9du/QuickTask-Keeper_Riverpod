import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todo_app/common/utils/constants.dart';
import 'package:riverpod_todo_app/common/widgets/appstyle.dart';
import 'package:riverpod_todo_app/common/widgets/custom_otn_btn.dart';
import 'package:riverpod_todo_app/common/widgets/reusable_text.dart';
import 'package:riverpod_todo_app/common/widgets/showDialogue.dart';
import 'package:riverpod_todo_app/features/auth/controllers/auth_controller.dart';

import '../../../common/widgets/custome_text.dart';
import '../controllers/code_provider.dart';
import 'otp_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phone = TextEditingController();
  Country country = Country(
      phoneCode: "+91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  sendCodeToUser() {
    if (phone.text.isEmpty) {
      return showAlertDialg(
          context: context, message: "Please Enter Your Phone Number");
    } else if (phone.text.length < 8) {
      return showAlertDialg(
          context: context, message: "Your number is Too Short");
    } else {
      print('${country.phoneCode}${phone.text}');
      ref.read(authControllerProvider).sendSms(
          context: context, phone: '${country.phoneCode}${phone.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Image.asset(
                  "assests/images/todo.png",
                  width: 200,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16.w),
                child: ReusableText(
                    text: "Please Enter Your Phone Number",
                    style: appstyle(17, AppConst.kLight, FontWeight.w500)),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: CustomTextField(
                  controller: phone,
                  prefixIcon: Container(
                    padding: EdgeInsets.all(14),
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryListTheme: CountryListThemeData(
                              backgroundColor: AppConst.kGreyLight,
                              bottomSheetHeight: AppConst.height * 0.6,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppConst.kRadius),
                                topRight: Radius.circular(AppConst.kRadius),
                              ),
                            ),
                            onSelect: (code) {
                              setState(() {
                                country = code;
                              });
                              // ref
                              //     .read(codeStateProvider.notifier)
                              //     .setState(code.phoneCode);
                              print(ref.read(codeStateProvider));
                            });
                      },
                      child: ReusableText(
                          text: "${country.flagEmoji}  ${country.phoneCode}",
                          style:
                              appstyle(18, AppConst.kBkDark, FontWeight.bold)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  hintText: "Enter Your Phone Number",
                  hintStyle: appstyle(16, AppConst.kBkDark, FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomOtnBtn(
                    onTap: () {
                      sendCodeToUser();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           OTPPage(phone: phone.text, smsCodeId: ''),
                      //     ),);
                    },
                    width: AppConst.kWidth * 0.9,
                    height: AppConst.height * 0.075,
                    color: AppConst.kBkDark,
                    color2: AppConst.kLight,
                    text: "Send Code"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
