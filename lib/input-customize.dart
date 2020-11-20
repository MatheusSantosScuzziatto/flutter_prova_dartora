import 'package:flutter/material.dart';

class InputCustomize extends StatelessWidget {

  final String hint;
  final bool obscure;
  final Icon icon;
  final TextEditingController controller;

  InputCustomize(
      {@required this.hint,
        this.obscure = false,
        this.icon = const Icon(Icons.person),
        this.controller
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextField(
        obscureText: this.obscure,
        decoration: InputDecoration(
            icon: this.icon,
            border: InputBorder.none,
            hintText: this.hint,
            hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 18
            ),
        ),
        controller: controller,
      ),
    );
  }
}
