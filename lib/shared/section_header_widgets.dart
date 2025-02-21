import 'package:flutter/material.dart';
import './styles.dart';

Widget sectionHeader(String headerTitle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10, bottom: 10),
        child: Text(headerTitle, style: h4),
      ),
    ],
  );
}

