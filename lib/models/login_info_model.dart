// user_model.dart
import 'package:hive/hive.dart';

part 'login_info_model.g.dart';

@HiveType(typeId: 0)
class LoginInfo extends HiveObject {
  @HiveField(0)
  String username;
  @HiveField(1)
  String nameOfUser;
  @HiveField(2)
  String password;

  LoginInfo(this.username, this.nameOfUser, this.password);
}
