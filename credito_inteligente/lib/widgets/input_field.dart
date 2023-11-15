import 'package:credito_inteligente/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldWidget extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final bool isNumber;
  final String initialValue;
  final Function(String) onTextChanged;
  const InputFieldWidget(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      this.isNumber = false,
      this.initialValue = '',
      required this.onTextChanged});

  @override
  _InputFieldWidgetState createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != '') {
      print("Initial value required");
      _textEditingController.text = widget.initialValue;
      print(
          "HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      print(_textEditingController.text);
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        keyboardType:
            widget.isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: [
          widget.isNumber
              ? FilteringTextInputFormatter.allow(
                  RegExp(
                      r'^\d+\.?\d{0,4}'), // Allow digits and a dot with up to two decimal places
                )
              : FilteringTextInputFormatter.singleLineFormatter
        ],
        controller: _textEditingController,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: primaryColorLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor),
          ),
        ),
        onChanged: (text) {
          widget.onTextChanged(text);

          setState(() {
            _isFocused = true;
          });
        },
      ),
    );
  }
}
