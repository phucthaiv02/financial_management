

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/models/login_info_model.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/presentation/screens/auth/forgot_pass.dart';
import 'package:personal_financial_management/presentation/screens/auth/signup.dart';
import 'package:personal_financial_management/presentation/screens/HOME.dart';
import 'package:personal_financial_management/presentation/widgets/components/button.dart';
import 'package:personal_financial_management/presentation/widgets/components/custom_form_field.dart';
import 'package:personal_financial_management/presentation/widgets/components/social_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    String? username = _usernameController.text;
    String? password = _passwordController.text;
    bool isExist = Hive.box<LoginInfo>('userBox').containsKey(username);

    if (isExist) {
      var loginInfo = Hive.box<LoginInfo>('userBox').get(username);
      if (loginInfo?.password == password) {
        await Hive.openBox<Transaction>('transactions_$username');
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Bottom(currentUser: username)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu không chính xác'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên người dùng không tồn tại'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    child: Form(
                      key: _formLoginKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đăng nhập'.toUpperCase(),
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
                              text: 'Tài khoản',
                              controller: _usernameController,
                              isPassword: false,
                            ),
                          ),
                          Expanded(
                            child: CustomFormField(
                              text: 'Mật khẩu',
                              controller: _passwordController,
                              isPassword: true,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassScreen()),
                                  );
                                },
                                child: const Text(
                                  'Quên mật khẩu?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Chưa có tài khoản? ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: primaryColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen()),
                                      );
                                    },
                                    child: const Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SecondaryButton(
                            controller: _formLoginKey,
                            text: 'Đăng nhập',
                            method: _login,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Expanded(
                            child: SocialLogin(
                              textColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
