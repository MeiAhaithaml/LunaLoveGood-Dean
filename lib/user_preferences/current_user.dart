import 'package:get/get.dart';
import 'package:lunalovegood/model/user_model.dart';
import 'package:lunalovegood/user_preferences/user_preferences.dart';

class CurrentUser extends GetxController
{
  Rx<User> _currentUser = User(0,'','','','').obs;
  User get user => _currentUser.value;
  getUserInfo() async{
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;

  }
}