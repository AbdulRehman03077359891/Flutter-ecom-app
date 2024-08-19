import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {

  // ignore: prefer_typing_uninitialized_variables
  final controller, validate, hintText, prefixIcon, fillColor, focusBorderColor, hidePassword, suffixIcon, errorBorderColor, suffixIconColor;
  


  const TextFieldWidget({
    super.key, 
    this.controller, 
    this.validate, 
    this.hintText, 
    this.prefixIcon, 
    this.fillColor, 
    this.focusBorderColor, 
    this.hidePassword = false,
    this.suffixIcon,
    this.errorBorderColor,
    this.suffixIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                obscureText: hidePassword,
                controller: controller,
                validator: validate,
                decoration:  InputDecoration(
                  hintText: hintText,
                  suffixIcon: suffixIcon,
                  suffixIconColor: suffixIconColor,
                  prefixIcon: prefixIcon,
                  filled: true,
                  fillColor: fillColor,
                  border: const  OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
                    ),
                    borderSide: BorderSide(
                      width: 2.0,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
                    ),
                    borderSide: BorderSide(
                      color: focusBorderColor,
                      width: 2.0,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
                    ),
                    borderSide: BorderSide(
                      color: errorBorderColor,
                      width: 2.0,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
              )
              ;
  }
}