import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_todo_app/common/helpers/db_helper.dart';

import '../../../common/models/task_model.dart';
import '../../../common/utils/constants.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoState extends _$TodoState {
  @override
  List<Task> build() {
    return [];
  }

  void refresh() async {
    final data = await DbHelper.geItems();
    state = data.map((e) => Task.fromJson(e)).toList();
  }

  void addItem(Task task) async {
    await DbHelper.createItem(task);
    refresh();
  }

  dynamic getRandomColor() {
    Random random = Random();
    int randomIndex = random.nextInt(colors.length);
    return colors[randomIndex];
  }

  void updateItem(int id, String title, String desc, int isCompleted,
      String data, String startTime, String endTime) async {
    await DbHelper.updateItem(
        id, title, desc, isCompleted, data, startTime, endTime);
    refresh();
  }

  Future<void> deleteTodo(int id) async {
    await DbHelper.deleteItem(id);
    refresh();
  }

  void markAsCompleted(int id, String title, String desc, int isCompleted,
      String data, String startTime, String endTime) async {
    await DbHelper.updateItem(id, title, desc, 1, data, startTime, endTime);
    refresh();
  }

//today
  String getToday() {
    DateTime today = DateTime.now();
    return today.toString().substring(0, 10);
  }

//tomorow
  String getTomorrow() {
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    return tomorrow.toString().substring(0, 10);
  }

  String getDayAfter() {
    DateTime tomorrow = DateTime.now().add(Duration(days: 2));
    return tomorrow.toString().substring(0, 10);
  }

  List<String> last30Days() {
    DateTime today = DateTime.now();
    DateTime oneMonthAgo = today.subtract(Duration(days: 30));
    List<String> dates = [];
    for (int i = 0; i < 30; i++) {
      DateTime date = oneMonthAgo.add(Duration(days: i));
      dates.add(date.toString().substring(0, 10));
    }
    return dates;
  }

  bool getStatus(Task data) {
    bool? isCompleted;
    if (data.isCompleted == 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }
    return isCompleted;
  }
}
