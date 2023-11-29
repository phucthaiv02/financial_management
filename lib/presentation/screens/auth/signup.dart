import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/constants/default_categories.dart';
import 'package:personal_financial_management/models/category_model.dart';
import 'package:personal_financial_management/models/login_info_model.dart';
import 'package:personal_financial_management/presentation/screens/auth/login.dart';
import 'package:personal_financial_management/presentation/widgets/components/button.dart';
import 'package:personal_financial_management/presentation/widgets/components/custom_form_field.dart';
import 'package:personal_financial_management/presentation/widgets/components/social_login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _register(BuildContext context) async {
    // Thực hiện kiểm tra và đăng ký người dùng mới, ví dụ: lưu thông tin vào Hive.
    // Điều này có thể được thực hiện dựa trên logic ứng dụng của bạn.
    // Sau khi đăng ký thành công, bạn có thể chuyển người dùng đến màn hình đăng nhập hoặc màn hình khác.

    // Ở đây chỉ là một ví dụ đơn giản:
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // Thực hiện đăng ký người dùng mới vào Hive hoặc lưu vào nơi khác.

      LoginInfo? newUser = LoginInfo(_usernameController.text,
          _nameController.text, _passwordController.text);

      String? username = _usernameController.text;
      bool isExist = Hive.box<LoginInfo>("userBox").containsKey(username);
      if (isExist) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tên đăng nhập đã tồn tại'),
          ),
        );
      } else {
        await Hive.box<LoginInfo>('userBox').put(username, newUser);
        Box<CategoryModel> catebox =
            await Hive.openBox<CategoryModel>('categories_$username');
        for (CategoryModel cate in defaultExpenseCategories) {
          catebox.add(cate);
        }
        for (CategoryModel cate in defaultIncomeCategories) {
          catebox.add(cate);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng kí thành công. Chuyển về trang đăng nhập.'),
          ),
        );
        // Chuyển đến màn hình đăng nhập sau khi đăng ký.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // Hiển thị thông báo lỗi nếu thông tin đăng ký không hợp lệ.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin đăng ký.'),
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
                Expanded(
                  flex: 13,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
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
                            'Đăng Ký'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: CustomFormField(
                              controller: _nameController,
                              text: 'Họ và tên',
                              isPassword: false,
                            ),
                          ),
                          Expanded(
                            child: CustomFormField(
                              controller: _usernameController,
                              text: 'Tài khoản',
                              isPassword: false,
                            ),
                          ),
                          Expanded(
                            child: CustomFormField(
                              controller: _passwordController,
                              text: 'Mật khẩu',
                              isPassword: true,
                            ),
                          ),
                          Expanded(
                            child: CustomFormField(
                              controller: _passwordConfirmController,
                              text: 'Xác nhận mật khâu',
                              isPassword: true,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Đã có tài khoản? ',
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
                                                const LoginScreen()),
                                      );
                                    },
                                    child: const Text(
                                      'Đăng nhập',
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
                            text: 'Đăng ký',
                            method: _register,
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
