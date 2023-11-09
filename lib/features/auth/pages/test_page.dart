import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todo_app/common/utils/constants.dart';
import 'package:riverpod_todo_app/common/widgets/appstyle.dart';
import 'package:riverpod_todo_app/common/widgets/reusable_text.dart';
import 'package:riverpod_todo_app/features/auth/controllers/code_provider.dart';

class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String code = ref.watch(codeStateProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ReusableText(
              text: code,
              style: appstyle(30, AppConst.kLight, FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                ref.read(codeStateProvider.notifier).setState("Hello Pavan");
              },
              child: Text("Press Me"),
            ),
          ],
        ),
      ),
    );
  }
}
