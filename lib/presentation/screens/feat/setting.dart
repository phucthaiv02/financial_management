import 'package:flutter/material.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/presentation/screens/auth/change_pass.dart';
import 'package:personal_financial_management/presentation/screens/auth/welcome.dart';
import 'package:personal_financial_management/presentation/screens/feat/budget_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.currentUSer});
  final String currentUSer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Cài đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Thiết lập ngân sách'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BudgetScreen(
                              currentUser: currentUSer,
                            )));
              },
            ),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              title: const Text('Đổi mật khẩu'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePassScreen(
                              currentUser: currentUSer,
                            )));
              },
            ),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()));
              },
            ),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
