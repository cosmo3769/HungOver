import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:hungover_flutter_app/notification.dart';

import 'geoLocationLocator/main.dart';

CollectionReference food = FirebaseFirestore.instance.collection('DonateFood');
Stream collectionStream =
    FirebaseFirestore.instance.collection('DonateFood').snapshots();

CollectionReference orgs =
    FirebaseFirestore.instance.collection('organisations');
//
//Lat-Long for org signed in currently
var x1;
var x2;
var orgLocation;

NotifyAlertState myAlert = NotifyAlertState(null);

class HomeScreen extends StatefulWidget {
  User currentUser;

  HomeScreen(this.currentUser);

  @override
  State<StatefulWidget> createState() => HomeScreenState(this.currentUser);
}

class HomeScreenState extends State<HomeScreen> {
  User currentUser;

  HomeScreenState(this.currentUser);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrgsLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HungOver"),
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            Builder(builder: (BuildContext context) {
              return FlatButton(
                textColor: Theme.of(context).buttonColor,
                onPressed: () async {
                  if (currentUser == null) {
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      content: Text('No one has signed in.'),
                    ));
                    return;
                  }
                  await _signOut();

                  final String uid = currentUser.uid;
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '${currentUser.email} has successfully signed out.'),
                  ));
                  setState(() {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  });
                },
                child: const Text('Sign out'),
              );
            })
          ],
        ),
        body: ListView(children: [
          StreamBuilder<QuerySnapshot>(
              stream: orgs.snapshots(),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: new Column(
                        children: [
                          if (document.data()['email'].toString() ==
                              FirebaseAuth.instance.currentUser.email
                                  .toString())
                            Card(
                                child: new Text(
                              " Welcome, " +
                                  document.data()["email"].toString() +
                                  " ",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            )),
                          Container()
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Chip(
                    elevation: 3,
                    backgroundColor: Colors.white,
                    label: Text(
                      "Near-by Events",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[600]),
                    ))),
          ),

          //NearBy Events ONLY

          StreamBuilder<QuerySnapshot>(
              stream: food.snapshots(),
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
                    if (Geodesy().distanceBetweenTwoGeoPoints(
                            orgLocation,
                            LatLng(
                                double.parse(
                                    document.data()['Location']['lat']),
                                double.parse(
                                    document.data()['Location']['long']))) <=
                        50000) myAlert.showNotification();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Card(
                        elevation: 2,
                        child: new Column(
                          children: [
                            if (Geodesy().distanceBetweenTwoGeoPoints(
                                    orgLocation,
                                    LatLng(
                                        double.parse(
                                            document.data()['Location']['lat']),
                                        double.parse(document.data()['Location']
                                            ['long']))) <=
                                50000)
                              Column(
                                children: [
                                  new Text(
                                    "\nEvent Organiser: " +
                                        document
                                            .data()['name']
                                            .toString()
                                            .toUpperCase(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Divider(
                                    height: 20,
                                    color: Colors.teal[700],
                                  ),
                                  new Text(
                                    "Total Invitation: " +
                                        document.data()['peopleInvited'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Total people arrived: " +
                                        document.data()['peopleTurnedUp'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Total Plates Ordered: " +
                                        document.data()['platesOrdered'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Plates Remaining: " +
                                        document.data()['platesRemaining'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Food-Type: " +
                                        document.data()['typeOfFood'] +
                                        "\n",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            Container()
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
          Center(
              child: Text(
            "No more near-by events found.",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.red[600]),
          )),
          SizedBox(
            height: 25,
          ),
          //ALL OTHER EVENTS
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Chip(
                    elevation: 3,
                    backgroundColor: Colors.white,
                    label: Text(
                      "All Other Events",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700]),
                    ))),
          ),
          //All Other EVENTS
          StreamBuilder<QuerySnapshot>(
              stream: food.snapshots(),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Card(
                        elevation: 2,
                        child: new Column(
                          children: [
                            new Text(
                              "\nEvent Organiser: " +
                                  document
                                      .data()['name']
                                      .toString()
                                      .toUpperCase(),
                              style: TextStyle(fontSize: 16),
                            ),
                            Divider(
                              height: 20,
                              color: Colors.amber[800],
                            ),
                            new Text(
                              "Total Invitation: " +
                                  document.data()['peopleInvited'],
                              style: TextStyle(fontSize: 14),
                            ),
                            new Text(
                              "Total people arrived: " +
                                  document.data()['peopleTurnedUp'],
                              style: TextStyle(fontSize: 14),
                            ),
                            new Text(
                              "Total Plates Ordered: " +
                                  document.data()['platesOrdered'],
                              style: TextStyle(fontSize: 14),
                            ),
                            new Text(
                              "Plates Remaining: " +
                                  document.data()['platesRemaining'],
                              style: TextStyle(fontSize: 14),
                            ),
                            new Text(
                              "Food-Type: " +
                                  document.data()['typeOfFood'] +
                                  "\n",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ]));
  }

  // Example code for sign out.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //get Email match of orgs & get their Location
  void _getOrgsLocation() async {
    var result = await FirebaseFirestore.instance
        .collection("organisations")
        .where("email",
            isEqualTo: FirebaseAuth.instance.currentUser.email.toString())
        .get();
    result.docs.forEach((res) {
      print(res.data());
      setState(() {
        x1 = res.data()['latitude'];
        x2 = res.data()['longitude'];
        orgLocation = LatLng(double.parse(x1), double.parse(x2));
      });
    });
  }
}
