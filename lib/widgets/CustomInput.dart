import 'package:flutter/material.dart';
import 'package:shoppy/Constants.dart';

class CustomInput extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool? isPasswordField;
  CustomInput(
      {this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPasswordField ?? false,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText ?? "Hint Text...",
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
        ),
        style: Constants.regularDarkText,
      ),
    );
  }
}
