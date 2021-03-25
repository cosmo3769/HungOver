import 'package:flutter/material.dart';

class CustomEvent extends StatelessWidget {
  String rowTitle;
  String values;

  CustomEvent({this.rowTitle, this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .55,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
            child: Text(
              rowTitle,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'productSans',
                  color: Colors.grey[600]),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .40,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Text(
              values,
              style: TextStyle(fontSize: 15, fontFamily: 'productSans'),
            ),
          ),
        ],
      ),
    );
  }
}

//UpcomingCustomEvent

class UpcomingCustomEvent extends StatelessWidget {
  String rowTitle;
  String values;

  UpcomingCustomEvent({this.rowTitle, this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .42,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
            child: Text(
              rowTitle,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'productSans',
                  color: Colors.grey[600]),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .45,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Text(
              values,
              style: TextStyle(fontSize: 15, fontFamily: 'productSans'),
            ),
          ),
        ],
      ),
    );
  }
}
