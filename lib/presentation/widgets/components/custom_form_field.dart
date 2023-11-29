import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key, this.text, this.controller, this.isPassword});
  final TextEditingController? controller;
  final String? text;
  final bool? isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller!,
      obscureText: isPassword!,
      obscuringCharacter: '*',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Hãy nhập ${text!.toLowerCase()}';
        }
        return null;
      },
      decoration: InputDecoration(
        label: Text(text!),
        hintText: text,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
