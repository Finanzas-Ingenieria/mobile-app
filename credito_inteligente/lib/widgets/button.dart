import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final Function onPressed;
  final double fontSize;
  final double radius;
  final double buttonHeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    this.width = double.infinity,
    required this.onPressed,
    this.fontSize = 20,
    this.radius = 10,
    this.buttonHeight = 50,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor, // Set the text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                widget.radius), // Set the button's border radius
          ),
        ),
        onPressed: () => widget.onPressed(),
        child: Text(
          widget.text,
          style: GoogleFonts.poppins(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
