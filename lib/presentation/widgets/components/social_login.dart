import 'package:flutter/material.dart';
import 'package:personal_financial_management/presentation/widgets/components/button.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key, this.textColor});
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginDivider(text: 'Hoặc đăng nhập bằng', textColor: textColor),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SocialButton(
              iconSrc: "assets/images/facebook.png",
              press: () {},
            ),
            SocialButton(
              iconSrc: "assets/images/google.png",
              press: () {},
            )
          ],
        )
      ],
    );
  }
}

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key, this.text, this.textColor});
  final String? text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: textColor!,
                  height: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  text!,
                  style: TextStyle(
                      color: textColor!,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: Divider(
                  color: textColor!,
                  height: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
