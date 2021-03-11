import 'package:flutter/material.dart';

class BookingDetails extends StatefulWidget{
  var orgID;
  var plateCapacity;

  BookingDetails(this.orgID, this.plateCapacity);

  @override
  State<StatefulWidget> createState() => BookingDetailsState(this.orgID, this.plateCapacity);

}

class BookingDetailsState extends State<BookingDetails>{
  var orgID;

  var plateCapacity;

  BookingDetailsState(this.orgID, this.plateCapacity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("HungOver"),
    centerTitle: true,
    ),
    body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Your Current Booking Details\n$orgID",
            textAlign:TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ],
    ),
    );
  }

}