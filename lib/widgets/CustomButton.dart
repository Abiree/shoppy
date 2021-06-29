import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final bool? outlineButton;
  final bool? isLoading;
  CustomButton({this.text, this.onPressed, this.outlineButton, this.isLoading});

  @override
  Widget build(BuildContext context) {
    bool _outline = outlineButton ?? false;
    bool _isLoading = isLoading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: _outline ? Colors.transparent : Colors.black,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Stack(
          children: [
            Visibility(
              visible: !_isLoading,
              child: Center(
                child: Text(
                  text ?? "Button",
                  style: TextStyle(
                    fontSize: 16,
                    color: _outline ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: _outline ? Colors.black : Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
