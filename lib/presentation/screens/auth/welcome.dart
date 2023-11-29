import 'package:flutter/material.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/presentation/screens/auth/login.dart';
import 'package:personal_financial_management/presentation/screens/auth/signup.dart';
import 'package:personal_financial_management/presentation/widgets/components/button.dart';
import 'package:personal_financial_management/presentation/widgets/components/social_login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                Flexible(
                  flex: 3,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                              text: 'WELCOME\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              )),
                          TextSpan(
                            text:
                                'Chào mừng bạn đến với ứng dụng của chúng tôi',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 22,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Flexible(
                  flex: 2,
                  child: Center(
                    child: Column(
                      children: [
                        PrimaryButton(
                          buttonText: 'Đăng nhập',
                          onTap: LoginScreen(),
                          color: primaryColor,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 16),
                        PrimaryButton(
                          buttonText: 'Đăng ký',
                          onTap: SignUpScreen(),
                          color: primaryColor,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: SocialLogin(textColor: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
