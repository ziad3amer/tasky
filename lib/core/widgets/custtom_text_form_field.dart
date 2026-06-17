import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CusttomTextFormField extends StatelessWidget {
  const CusttomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.validator,
    this.maxLines,
  });

  final TextEditingController controller;
  final int? maxLines;
  final String hintText;
  final String title;
  final Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:Theme.of(context).textTheme.titleMedium,

        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.labelMedium,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator: validator != null
              ? (String? value) => validator!(value)
              : null,
        ),
      ],
    );
  }
}
