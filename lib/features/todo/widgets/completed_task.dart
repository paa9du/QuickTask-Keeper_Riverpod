import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todo_app/common/utils/constants.dart';
import 'package:riverpod_todo_app/features/todo/widgets/todo_tile.dart';

import '../../../common/models/task_model.dart';
import '../controllers/todo_provider.dart';

class CompletedTasks extends ConsumerWidget {
  const CompletedTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> listData = ref.watch(todoStateProvider);
    List lastMonth = ref.read(todoStateProvider.notifier).last30Days();
    var CompletedList = listData
        .where((element) =>
            element.isCompleted == 1 ||
            lastMonth.contains(element.date!.substring(0, 10)))
        .toList();

    return ListView.builder(
        itemCount: CompletedList.length,
        itemBuilder: (context, index) {
          final data = CompletedList[index];
          // bool isCompleted =
          //     ref.read(todoStateProvider.notifier).getStatus(data);
          dynamic color = ref.read(todoStateProvider.notifier).getRandomColor();

          return ToDoTile(
              delete: () {
                ref.read(todoStateProvider.notifier).deleteTodo(data.id ?? 0);
              },
              editWidget: SizedBox.shrink(),
              title: data.title,
              //colors: color,
              description: data.desc,
              start: data.startTime,
              end: data.endTime,
              switcher: Icon(
                AntDesign.checkcircle,
                color: AppConst.kGreen,
              ));
        });
  }
}
