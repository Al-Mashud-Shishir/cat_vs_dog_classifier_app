import 'package:flutter/material.dart';

class HomeBtnWidget extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function fn;
  const HomeBtnWidget(
      {Key key, @required this.icon, @required this.text, this.fn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      // padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      color: Colors.orange[800],
      onPressed: fn,
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
