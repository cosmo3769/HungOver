import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_event_card.dart';

CollectionReference upcoming =
    FirebaseFirestore.instance.collection('RegisterEvent');
Stream collectionStream =
    FirebaseFirestore.instance.collection('RegisterEvent').snapshots();

class UpcomingEvents extends StatefulWidget {
  var orgLocation;

  UpcomingEvents(this.orgLocation);

  @override
  State<StatefulWidget> createState() => UpcomingEventsState(this.orgLocation);
}

class UpcomingEventsState extends State<UpcomingEvents> {
  var orgLocation;

  UpcomingEventsState(this.orgLocation);

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
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Upcoming Registered Events",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey[800]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
            child: Chip(
              elevation: 2,
              backgroundColor: Colors.purple[50],
              label: Text(
                "Today Upcoming",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.purple),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: upcoming.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: CircularProgressIndicator())]);
                }

                if (!snapshot.hasData)
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: Text("No Data"))]);
                return new Column(
                  // padding: EdgeInsets.symmetric(horizontal:5,vertical: 5),
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Column(
                      children: [
                        Container(),
                        if (DateTime.now().toString().split(" ")[0] ==
                            document.data()['date'].toString())
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                children: [
                                  new Text(
                                    "\nEvent Organiser : " +
                                        document
                                            .data()['name']
                                            .toString()
                                            .toUpperCase(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Divider(
                                    height: 15,
                                    color: Colors.purple[700],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Organiser's Email : ",
                                    values: document.data()['email'].toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Event Date : ",
                                    values: document.data()['date'].toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Event Time : ",
                                    values: document
                                            .data()['startTime']
                                            .toString() +
                                        "-" +
                                        document.data()['endTime'].toString() +
                                        " Hours",
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Total Invitation : ",
                                    values: document
                                        .data()['peopleInvited']
                                        .toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Total Plates Ordered : ",
                                    values: document
                                        .data()['platesOrdered']
                                        .toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Food-Type : ",
                                    values: document
                                        .data()['typeOfFood']
                                        .toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Distance : ",
                                    values: (Geodesy().distanceBetweenTwoGeoPoints(
                                                    orgLocation,
                                                    LatLng(
                                                        double.parse(document.data()['Location']
                                                            ['lat']),
                                                        double.parse(
                                                            document.data()['Location']
                                                                ['long']))) /
                                                1000)
                                            .toString()
                                            .split(".")[0] +
                                        "." +
                                        (Geodesy().distanceBetweenTwoGeoPoints(
                                                orgLocation,
                                                LatLng(
                                                    double.parse(document.data()['Location']['lat']),
                                                    double.parse(document.data()['Location']['long']))))
                                            .toString()[1][0] +
                                        " K.M.",
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: OutlineButton.icon(
                                      icon: Icon(Icons.call),
                                      textColor: Colors.blue[600],
                                      onPressed: () {
                                        _phoneCall(document.data()['phone']);
                                      },
                                      label: Text(
                                        "Contact Event Organiser\n${document.data()['phone']}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Container()
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                );
              }),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                "\nNo more upcoming events for today.",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Chip(
              elevation: 2,
              backgroundColor: Colors.pink[50],
              label: Text(
                "Future Upcoming Events",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.pink),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: upcoming.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: CircularProgressIndicator())]);
                }

                if (!snapshot.hasData)
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: Text("No Data"))]);
                return new Column(
                  // padding: EdgeInsets.symmetric(horizontal:5,vertical: 5),
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Column(
                      children: [
                        Container(),
                        if (DateTime.now().isBefore(
                                DateTime.parse(document.data()['date'])) &&
                            (DateTime.now().toString().split(" ")[0] !=
                                document.data()['date'].toString()))
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                children: [
                                  new Text(
                                    "\nEvent Organiser : " +
                                        document
                                            .data()['name']
                                            .toString()
                                            .toUpperCase(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Divider(
                                    height: 15,
                                    color: Colors.pink[700],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Organiser's Email : ",
                                    values: document.data()['email'].toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Event Date : ",
                                    values: document.data()['date'].toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Event Time : ",
                                    values: document
                                            .data()['startTime']
                                            .toString() +
                                        "-" +
                                        document.data()['endTime'].toString() +
                                        " Hours",
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Total Invitation : ",
                                    values: document
                                        .data()['peopleInvited']
                                        .toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Total Plates Ordered : ",
                                    values: document
                                        .data()['platesOrdered']
                                        .toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Food-Type : ",
                                    values: document
                                        .data()['typeOfFood']
                                        .toString(),
                                  ),
                                  UpcomingCustomEvent(
                                    rowTitle: "Distance : ",
                                    values: (Geodesy().distanceBetweenTwoGeoPoints(
                                                    orgLocation,
                                                    LatLng(
                                                        double.parse(document.data()['Location']
                                                            ['lat']),
                                                        double.parse(
                                                            document.data()['Location']
                                                                ['long']))) /
                                                1000)
                                            .toString()
                                            .split(".")[0] +
                                        "." +
                                        (Geodesy().distanceBetweenTwoGeoPoints(
                                                orgLocation,
                                                LatLng(
                                                    double.parse(document.data()['Location']['lat']),
                                                    double.parse(document.data()['Location']['long']))))
                                            .toString()[1][0] +
                                        " K.M.",
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: OutlineButton.icon(
                                      icon: Icon(Icons.call),
                                      textColor: Colors.blue[600],
                                      onPressed: () {
                                        _phoneCall(document.data()['phone']);
                                      },
                                      label: Text(
                                        "Contact Event Organiser\n${document.data()['phone']}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Container()
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                );
              }),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Text(
                "\nNo more upcoming events.",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Call Launcher
  void _phoneCall(phoneNumber) {
    launch("tel:$phoneNumber>");
  }
}
