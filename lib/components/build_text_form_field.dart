// ignore_for_file: must_be_immutable

import 'package:arrhythmia/palette.dart';
import 'package:flutter/material.dart';

class BuildTextFormField extends StatefulWidget {
  BuildTextFormField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.isEmail,
    required this.onChange,
    required this.isHidden,
  });

  final IconData icon;
  final String hintText;
  final bool isPassword;
  final bool isEmail;
  bool isHidden;
  final Function(String) onChange;

  @override
  State<BuildTextFormField> createState() => _BuildTextFormFieldState();
}

class _BuildTextFormFieldState extends State<BuildTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        onChanged: widget.onChange,
        validator: (value) {
          if (widget.isPassword) {
            if (value!.isEmpty) {
              return 'required field';
            }
          } else if (widget.hintText == 'User Name') {
            if (value!.isEmpty) {
              return 'required field';
            }
          } else {
            if (value!.isEmpty) {
              return 'required field';
            } else if (!checkEmail(value)) {
              return "Check your email";
            }
          }
          return null;
        },
        obscureText: widget.isHidden,
        keyboardType:
            widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: widget.isHidden == false
                        ? const Icon(
                            Icons.visibility,
                            color: Palette.iconColor,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: Palette.iconColor,
                          ),
                    onPressed: () => setState(() {
                          if (widget.isHidden == true) {
                            widget.isHidden = false;
                          } else {
                            widget.isHidden = true;
                          }
                        }))
                : null,
            prefixIcon: Icon(
              widget.icon,
              color: Palette.iconColor,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Palette.textColor1),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Palette.textColor1),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 252, 112, 6)),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            contentPadding: const EdgeInsets.all(10),
            hintText: widget.hintText,
            hintStyle: const TextStyle(fontSize: 14, color: Palette.textColor1),
            errorStyle:
                const TextStyle(color: Color.fromARGB(255, 252, 112, 6))),
      ),
    );
  }

  bool checkEmail(String email) {
    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailPattern);

    return regExp.hasMatch(email);
  }
}
