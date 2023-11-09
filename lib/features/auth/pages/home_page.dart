import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todo_app/common/utils/constants.dart';
import 'package:riverpod_todo_app/common/widgets/appstyle.dart';
import 'package:riverpod_todo_app/common/widgets/custome_text.dart';
import 'package:riverpod_todo_app/common/widgets/reusable_text.dart';
import 'package:riverpod_todo_app/common/widgets/xpansion_tile.dart';
import 'package:riverpod_todo_app/features/todo/controllers/todo_provider.dart';
import 'package:riverpod_todo_app/features/todo/controllers/xpansion_provider.dart';
import 'package:riverpod_todo_app/features/todo/pages/add.dart';
import 'package:riverpod_todo_app/features/todo/widgets/completed_task.dart';
import 'package:riverpod_todo_app/features/todo/widgets/day_AfterTomorrow.dart';
import 'package:riverpod_todo_app/features/todo/widgets/todo_tile.dart';
import 'package:riverpod_todo_app/features/todo/widgets/tomorow_task.dart';
import 'package:riverpod_todo_app/common/helpers/notifications.helper.dart';

import '../../../common/models/task_model.dart';
import '../../todo/widgets/today_task.dart';

class HomePageWidget extends ConsumerStatefulWidget {
  const HomePageWidget({super.key});

  @override
  ConsumerState<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends ConsumerState<HomePageWidget>
    with TickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 2, vsync: this);
  late NotificationsHelper notifierHelper;
  late NotificationsHelper controller;
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    notifierHelper = NotificationsHelper(ref: ref);
    Future.delayed(Duration(seconds: 0), () {
      controller = NotificationsHelper(ref: ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(todoStateProvider.notifier).refresh();
    var color = ref.read(todoStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(85),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: "DashBoard",
                      style: appstyle(
                        18,
                        AppConst.kLight,
                        FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        color: AppConst.kLight,
                        borderRadius: BorderRadius.all(
                          Radius.circular(9),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTask(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: AppConst.kBkDark,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Search",
                controller: search,
                prefixIcon: Container(
                  padding: EdgeInsets.all(14.h),
                  child: GestureDetector(
                    onTap: null,
                    child: Icon(
                      AntDesign.search1,
                      color: AppConst.kGreyLight,
                    ),
                  ),
                ),
                suffixIcon: Icon(
                  FontAwesome.sliders,
                  color: AppConst.kGreyLight,
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FontAwesome.tasks,
                    size: 20,
                    color: AppConst.kLight,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ReusableText(
                    text: "Today's Task",
                    style: appstyle(
                      18,
                      AppConst.kLight,
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppConst.kLight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                ),
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      color: AppConst.kGreyLight,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          AppConst.kRadius,
                        ),
                      ),
                    ),
                    controller: tabController,
                    labelPadding: EdgeInsets.zero,
                    isScrollable: false,
                    labelColor: AppConst.kBlueLight,
                    labelStyle:
                        appstyle(24, AppConst.kBlueLight, FontWeight.w700),
                    unselectedLabelColor: AppConst.kLight,
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: AppConst.kWidth * 0.5,
                          child: Center(
                            child: ReusableText(
                              text: "Pending",
                              style: appstyle(
                                  16, AppConst.kBkDark, FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.only(left: 30.w),
                          width: AppConst.kWidth * 0.5,
                          child: Center(
                            child: ReusableText(
                              text: "Completed",
                              style: appstyle(
                                  16, AppConst.kBkDark, FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: AppConst.height * 0.3,
                width: AppConst.kWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Container(
                          color: AppConst.kBkLight,
                          height: AppConst.height * 0.3,
                          child: TodayTask()
                          // ListView(
                          //   children: [
                          //     ToDoTile(
                          //       start: "03:00",
                          //       end: "05:00",
                          //       switcher: Switch(
                          //         value: true,
                          //         onChanged: (value) {},
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          ),
                      Container(
                        color: AppConst.kBkLight,
                        height: AppConst.height * 0.3,
                        child: CompletedTasks(),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TomorrowList(),
              SizedBox(
                height: 20,
              ),
              DayAfter(),
            ],
          ),
        ),
      ),
    );
  }
}
