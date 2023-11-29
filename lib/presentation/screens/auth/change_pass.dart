

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/models/login_info_model.dart';
import 'package:personal_financial_management/presentation/widgets/components/button.dart';
import 'package:personal_financial_management/presentation/widgets/components/custom_form_field.dart';

class ChangePassScreen extends StatefulWidget {
  late String currentUser;
  ChangePassScreen({super.key, required this.currentUser});

  @override
  State<ChangePassScreen> createState() =>
      _ChangePassScreen(currentUser: currentUser);
}

class _ChangePassScreen extends State<ChangePassScreen> {
  late String currentUser;
  _ChangePassScreen({required this.currentUser});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  void _changePass(BuildContext context) async {
    String? currentPass = _currentPass.text;
    String? newPass = _newPass.text;
    String? confirmPass = _confirmPass.text;

    if (newPass != confirmPass) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Mật khẩu xác nhận không trùng mật khẩu mới!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      var loginInfo = Hive.box<LoginInfo>('userBox').get(currentUser);
      if (loginInfo?.password != currentPass) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Thông báo'),
            content: const Text('Mật khẩu cũ chưa chính xác!'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        loginInfo?.password = newPass;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Thông báo'),
            content: const Text('Đổi mật khẩu thành công!'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Đổi mật khẩu'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: CustomFormField(
                          text: 'Mật khẩu cũ',
                          controller: _currentPass,
                          isPassword: true,
                        ),
                      ),
                      Expanded(
                        child: CustomFormField(
                          text: 'Mật khẩu mới',
                          controller: _newPass,
                          isPassword: true,
                        ),
                      ),
                      Expanded(
                        child: CustomFormField(
                          text: 'Xác nhận mật khẩu mới',
                          controller: _confirmPass,
                          isPassword: true,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SecondaryButton(
                        controller: _formKey,
                        text: 'Đăng nhập',
                        method: _changePass,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 3,
              child: SizedBox(
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
