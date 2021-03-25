import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.black,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          // color: Colors.black,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          style: TextButton.styleFrom(
            primary: textColor,
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          ),
        ),
      ),
    );
  }
}
