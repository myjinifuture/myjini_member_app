import 'package:flutter/material.dart';

class InputFiled extends StatelessWidget {
  String hintText;
  String label;
  TextInputType keyboardType;
  Icon icon;
  int maxLength;
  TextEditingController controller;
  bool isPassword;

  InputFiled({
    this.keyboardType,
    this.hintText,
    this.label,
    this.maxLength,
    this.icon,
    this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 13),
      maxLength: maxLength,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: "${hintText}",
        labelText: "${label}",
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        hintStyle: TextStyle(
          fontSize: 13,
        ),
        contentPadding: EdgeInsets.only(left: 10, right: 8, bottom: 5),
        counterText: "",
        prefixIcon: icon,
      ),
    );
  }
}