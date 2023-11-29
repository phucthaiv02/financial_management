import 'package:flutter/material.dart';
import 'package:personal_financial_management/constants/color.dart';

// Sử dụng cho nút chuyển sang trang đăng nhập và đăng ký
class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key, this.buttonText, this.onTap, this.color, this.textColor});
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (e) => onTap!,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        width: 300,
        decoration: BoxDecoration(
          color: color!,
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Text(
          buttonText!.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: textColor!,
          ),
        ),
      ),
    );
  }
}

// Sử dụng cho nút đăng nhập và đăng ký
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, this.controller, this.text, this.method});
  final GlobalKey<FormState>? controller;
  final String? text;
  final void Function(BuildContext)? method;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        onPressed: () {
          if (controller!.currentState!.validate()) {
            method!(context);
          }
        },
        child: Text(
          text!,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Sử dụng cho nút đăng nhập bằng mạng xã hội
class SocialButton extends StatelessWidget {
  final String? iconSrc;
  final Function? press;
  const SocialButton({
    Key? key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press as void Function()?,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: Image.asset(
          iconSrc!,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
