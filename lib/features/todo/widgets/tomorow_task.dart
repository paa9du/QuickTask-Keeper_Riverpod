import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_vector_icons/flutter_vector_icons.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_todo_app/features/todo/controllers/todo_provider.dart";
import "package:riverpod_todo_app/features/todo/widgets/todo_tile.dart";

import "../../../common/utils/constants.dart";
import "../../../common/widgets/xpansion_tile.dart";
import "../controllers/xpansion_provider.dart";
import "../pages/update_task.dart";

class TomorrowList extends ConsumerWidget {
  const TomorrowList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoStateProvider);
    var color = ref.read(todoStateProvider.notifier);
    String tomorrow = ref.read(todoStateProvider.notifier).getTomorrow();
    var tomorrowTasks =
        todos.where((element) => element.date!.contains(tomorrow));

    return SingleChildScrollView(
      child: xpansionTile(
        text: "Tomorrow Task",
        text2: "Tomorrow's Tasks are here",
        onExpansionChanged: (bool expanded) {
          ref.read(xpansionStateProvider.notifier).setState(!expanded);
        },
        trailing: Padding(
          padding: EdgeInsets.only(right: 12.0.w),
          child: ref.watch(xpansionStateProvider)
              ? Icon(
                  AntDesign.circledown,
                  color: AppConst.kLight,
                )
              : Icon(
                  AntDesign.closecircleo,
                  color: AppConst.kBlueLight,
                ),
        ),
        children: [
          for (final todo in tomorrowTasks)
            ToDoTile(
              title: todo.title,
              start: todo.startTime,
              end: todo.endTime,
              description: todo.desc,
              delete: () {
                ref.read(todoStateProvider.notifier).deleteTodo(todo.id ?? 0);
              },
              editWidget: GestureDetector(
                onTap: () {
                  titles = todo.title.toString();
                  descs = todo.desc.toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateTask(
                        id: todo.id ?? 0,
                      ),
                    ),
                  );
                },
                child: Icon(MaterialCommunityIcons.circle_edit_outline),
              ),
              switcher: SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
