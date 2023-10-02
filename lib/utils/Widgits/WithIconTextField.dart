// import 'package:flutter/material.dart';
//
//
// TextField IconTextField({
//   required String text,
//   required IconData icon,
//   required bool isPasswordType,
//   required TextEditingController controller,
//   required TextInputType keyboardType,
// }) {
//   return TextField(
//     controller: controller,
//     obscureText: isPasswordType,
//     enableSuggestions: !isPasswordType,
//     autocorrect: !isPasswordType,
//     cursorColor: Colors.white,
//     style: TextStyle(color: Colors.white,),
//     decoration: InputDecoration(
//       prefixIcon: Icon(
//         icon,
//         color: Colors.white70,
//       ),
//       labelText: text,
//       labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
//       filled: true,
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       fillColor: Colors.white.withOpacity(0.3),
//       border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           borderSide:  BorderSide(width: 0, style: BorderStyle.none)),
//     ),
//     keyboardType: keyboardType,
//   );
// }


import 'package:flutter/material.dart';

class IconTextField extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isPasswordType;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enabled;

  IconTextField({
    required this.text,
    required this.icon,
    required this.isPasswordType,
    required this.controller,
    required this.keyboardType,
    required this.enabled,
  });

  @override
  _IconTextFieldState createState() => _IconTextFieldState();
}

class _IconTextFieldState extends State<IconTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText && widget.isPasswordType,
      enableSuggestions: !widget.isPasswordType,
      autocorrect: !widget.isPasswordType,
      cursorColor: Colors.white,
      enabled: widget.enabled,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white70,
        ),
        labelText: widget.text,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        suffixIcon: widget.isPasswordType
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      keyboardType: widget.keyboardType,
    );
  }
}
