import 'package:blood_donor/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.hinttext,
      this.keyboardtype,
      required this.labeltext,
      this.inputformatter,
      this.maxlenght,
      this.textalign,
      this.obscuretext = false,
      this.validator,
      this.controller,
      this.suffixicon,
      this.prefixicon,
      this.autoFocus = false,
      this.prefixStyle,
      this.prefixIconColor,
      this.onSaved})
      : super(key: key);

  final String labeltext;
  final String hinttext;
  final TextInputType? keyboardtype;
  final int? maxlenght;
  final TextAlign? textalign;
  final bool obscuretext;
  final TextInputFormatter? inputformatter;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final InkWell? suffixicon;
  final bool autoFocus;
  final Icon? prefixicon;
  final TextStyle? prefixStyle;
  final Color? prefixIconColor;
  final void Function(String?)? onSaved;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: TextFormField(
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
        autofocus: autoFocus,
        onSaved: onSaved,
        cursorColor: primaryColor,
        controller: controller,
        validator: validator,
        obscureText: obscuretext,
        keyboardType: keyboardtype,
        maxLength: maxlenght,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIconColor: prefixIconColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          hintText: hinttext,
          prefixIcon: prefixicon,
          suffixIcon: suffixicon,
          prefixStyle: prefixStyle,
          contentPadding: EdgeInsets.only(left: 14, bottom: 10, top: 6),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(18.0),
          ),
          counter: const Offstage(),
        ),
      ),
    );
  }
}
