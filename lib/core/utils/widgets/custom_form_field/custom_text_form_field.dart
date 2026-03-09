import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData iconData;

  final bool expands;
  final bool obscureText;
  final void Function()? onPressed;
  final String? Function(String?) validator;
  final bool isNumber;
  final IconData? suffixIcon;
  final bool isSuffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Iterable<String>? autofillHints;
  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.isNumber,
    required this.validator,
    required this.iconData,
    this.suffixIcon,
    required this.isSuffixIcon,
    required this.expands,
    required this.obscureText,
    this.controller,
    this.onPressed,
    this.onChanged,
    this.autofillHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      controller: controller,
      expands: expands,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      autofillHints: autofillHints,
      decoration: DecorationTextField(context),
      onEditingComplete: () => TextInput.finishAutofillContext(),
    );
  }

  // ignore: non_constant_identifier_names
  InputDecoration DecorationTextField(BuildContext context) {
    return InputDecoration(
      prefixIcon: Icon(
        iconData,
        color: ColorsManger.mainBlue,
      ),
      labelText: labelText,
      labelStyle: const TextStyle(color: ColorsManger.white),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: ColorsManger.gray),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: ColorsManger.white),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: ColorsManger.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: ColorsManger.red),
      ),
      suffixIcon: isSuffixIcon
          ? InkWell(
              onTap: onPressed,
              child: Icon(
                suffixIcon,
                color: ColorsManger.white,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
