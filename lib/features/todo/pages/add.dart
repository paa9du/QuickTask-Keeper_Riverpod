import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todo_app/common/helpers/notifications.helper.dart';
import 'package:riverpod_todo_app/common/utils/constants.dart';
import 'package:riverpod_todo_app/common/widgets/appstyle.dart';
import 'package:riverpod_todo_app/common/widgets/custom_otn_btn.dart';
import 'package:riverpod_todo_app/common/widgets/custome_text.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:riverpod_todo_app/common/widgets/showDialogue.dart';
import 'package:riverpod_todo_app/features/auth/pages/home_page.dart';
import 'package:riverpod_todo_app/features/todo/controllers/dates/dates_provider.dart';
import 'package:riverpod_todo_app/features/todo/controllers/todo_provider.dart';

import '../../../common/models/task_model.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  List<int> notification = [];
  late NotificationsHelper notifierHelper;
  late NotificationsHelper controller;
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    notifierHelper = NotificationsHelper(ref: ref);
    Future.delayed(Duration(seconds: 0), () {
      controller = NotificationsHelper(ref: ref);
    });
    notifierHelper.initializeNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scheduleDate = ref.watch(datesStateProvider);
    var start = ref.watch(startTimeStateProvider);
    var end = ref.watch(finishTimeStateProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Add title",
              controller: title,
              hintStyle: appstyle(16, AppConst.kGreyLight, FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Add description",
              controller: desc,
              hintStyle: appstyle(16, AppConst.kGreyLight, FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            CustomOtnBtn(
                onTap: () {
                  picker.DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2023, 9, 1),
                      maxTime: DateTime(2024, 12, 31),
                      theme: picker.DatePickerTheme(
                          // headerColor: Colors.orange,
                          // backgroundColor: Colors.blue,
                          // itemStyle: TextStyle(
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 18),
                          doneStyle:
                              TextStyle(color: AppConst.kGreen, fontSize: 16)),
                      //     onChanged: (date) {
                      //   print('change $date in time zone ' +
                      //       date.timeZoneOffset.inHours.toString());
                      // },
                      onConfirm: (date) {
                    ref
                        .read(datesStateProvider.notifier)
                        .setDate(date.toString());
                    // print('confirm $date');
                  }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
                },
                width: AppConst.kWidth,
                height: 52.h,
                color: AppConst.kLight,
                color2: AppConst.kGreyLight,
                text: scheduleDate == ""
                    ? "Set Date"
                    : scheduleDate.substring(0, 10)),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOtnBtn(
                    onTap: () {
                      picker.DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          // minTime: DateTime(2020, 5, 5, 20, 50),
                          // maxTime: DateTime(2020, 6, 7, 05, 09),
                          // onChanged: (date) {
                          //   print('change $date in time zone ' +
                          //       date.timeZoneOffset.inHours.toString());
                          // },
                          onConfirm: (date) {
                        // /  print('confirm $date');
                        notification = ref
                            .read(startTimeStateProvider.notifier)
                            .dates(date);
                        ref
                            .read(startTimeStateProvider.notifier)
                            .setStartTime(date.toString());
                      }, locale: picker.LocaleType.en);
                    },
                    width: AppConst.kWidth * 0.4,
                    height: 52.h,
                    color: AppConst.kLight,
                    color2: AppConst.kGreyLight,
                    text: start == "" ? "Start Time" : start.substring(10, 16)),
                CustomOtnBtn(
                    onTap: () {
                      picker.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        // minTime: DateTime(2020, 5, 5, 20, 50),
                        // maxTime: DateTime(2020, 6, 7, 05, 09),
                        // onChanged: (date) {
                        //   print('change $date in time zone ' +
                        //       date.timeZoneOffset.inHours.toString());
                        // },
                        onConfirm: (date) {
                          // /  print('confirm $date');
                          ref
                              .read(finishTimeStateProvider.notifier)
                              .setStartTime(date.toString());
                        },
                      );
                    },
                    width: AppConst.kWidth * 0.4,
                    height: 52.h,
                    color: AppConst.kLight,
                    color2: AppConst.kGreyLight,
                    text: end == "" ? "End Time" : end.substring(10, 16)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CustomOtnBtn(
                onTap: () {
                  if (title.text.isNotEmpty &&
                      desc.text.isNotEmpty &&
                      scheduleDate.isNotEmpty &&
                      start.isNotEmpty &&
                      end.isNotEmpty) {
                    Task task = Task(
                        title: title.text,
                        desc: desc.text,
                        isCompleted: 0,
                        date: scheduleDate,
                        startTime: start.substring(10, 16),
                        endTime: end.substring(10, 16),
                        remind: 0,
                        repeat: "yes");
                    notifierHelper.scheduledNotification(
                      notification[0],
                      notification[1],
                      notification[2],
                      notification[3],
                      task,
                    );
                    ref.read(todoStateProvider.notifier).addItem(task);
                    // ref.read(finishTimeStateProvider.notifier).setStartTime("");
                    // ref.read(startTimeStateProvider.notifier).setStartTime("");
                    // ref.read(datesStateProvider.notifier).setDate("");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePageWidget(),
                        ));
                  } else {
                    showAlertDialg(
                        context: context, message: 'Failed to add task');
                  }
                },
                width: AppConst.kWidth,
                height: 52.h,
                color: AppConst.kLight,
                color2: AppConst.kGreen,
                text: "Submit"),
          ],
        ),
      ),
    );
  }
}
