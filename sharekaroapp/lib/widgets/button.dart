import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Button extends StatefulWidget {

  Button({Key? key,   required this.color, required this.text, required this.textColor, required this.callback}) : super(key: key);
  Color color;
  Function callback;
  String text;
  Color textColor;
  
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80,
        child: TextButton(onPressed: (){
          widget.callback();
        }, child: Text(widget.text),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(widget.color),
          foregroundColor: MaterialStateProperty.all<Color>(widget.textColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
          )
          )
        ),  
      )
    );
  }
}