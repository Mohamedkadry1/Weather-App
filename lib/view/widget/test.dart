import 'package:flutter/material.dart';

class CutsomTextFiled extends StatelessWidget {
  String labelText;
  String hintText;
  TextEditingController controller;
  String? Function(String?)? validator;
  CutsomTextFiled(
      {required this.labelText,
      required this.hintText,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            labelText,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              height: 0.05,
              letterSpacing: -0.44,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            enabled: true,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                hintText: hintText,
                // labelText: labelText,
                hintStyle: TextStyle(
                  color: Color(0xFF858585),
                  fontSize: 18,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 0.06,
                  letterSpacing: -0.36,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
        ),
      ],
    );
  }
}
