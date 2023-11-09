import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todo_app/common/helpers/db_helper.dart';

import '../../../common/models/user_model.dart';

final userProvider = StateNotifierProvider<UserState, List<UserModel>>((ref) {
  return UserState();
});

class UserState extends StateNotifier<List<UserModel>> {
  UserState() : super([]);
  void refresh() async {
    final data = await DbHelper.getUsers();
    state = data.map((e) => UserModel.fromJson(e)).toList();
  }
}
