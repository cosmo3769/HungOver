import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:hungover_flutter_app/notification.dart';
import 'file:///E:/~MySpace/Flutters_Code/hungover_flutter_app/lib/booking_details.dart';
import 'package:url_launcher/url_launcher.dart';

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

//plateCapacity of current orgs
var plateCapacity;
var platesOrdered;
var requiedbyOrg; //plates required by org
// ID of orgs
var orgID;


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
    _getOrgsPlateCapacity();
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
              return FlatButton.icon(
                icon: Icon(Icons.logout),
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
                label: const Text('Sign out'),
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
                            Column(
                              children: [
                                Card(
                                    child: new Text(
                                  " Welcome, " +
                                      document.data()["email"].toString() +
                                      " ",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Your Total plate capacity is " +
                                        document.data()["plateCapacity"].toString() +
                                        ".",
                                    textAlign:TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    "Remaining plate-capacity : " +
                    (int.parse(document.data()["plateCapacity"])-int.parse(document.data()["platesOrdered"])).toString()
                                        ,
                                    textAlign:TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                )

                              ],
                            ),
                          Container()
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),

          GestureDetector(
            onTap:(){
              refillPlateCapacity();
            },
              child: Chip(label: Text("Refill Your Plate Capacity"),elevation: 2,shadowColor: Colors.blueAccent,)),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: GestureDetector(
          //     onTap: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingDetails(orgID,plateCapacity,)));
          //     },
          //     child: Card(
          //         color: Colors.lightBlue[100],
          //         elevation: 2,
          //         child:
          //     Column(children: [
          //       Padding(
          //         padding: const EdgeInsets.all(10.0),
          //         child: Icon(Icons.menu_book_rounded,size: 35,color: Colors.indigo,),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(5.0),
          //         child: Text(
          //           "View your Current Booking Details",
          //           style: TextStyle(
          //             color: Colors.indigo,
          //               fontSize: 15,
          //               fontWeight: FontWeight.w600
          //           ),
          //         ),
          //       )
          //     ],)
          //     ),
          //   ),
          // ),

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

                    return Column(
                      children: [
                        Container(),
                        if (Geodesy().distanceBetweenTwoGeoPoints(
                                orgLocation,
                                LatLng(
                                    double.parse(
                                        document.data()['Location']['lat']),
                                    double.parse(document.data()['Location']
                                        ['long']))) <=
                            50000)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                children: [
                                  notifyMe(),
                                  new Text(
                                    "\nEvent Organiser : " +
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
                                    "Total Invitation : " +
                                        document.data()['peopleInvited'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Total people arrived : " +
                                        document.data()['peopleTurnedUp'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Total Plates Ordered : " +
                                        document.data()['platesOrdered'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Plates Remaining : " +
                                        document.data()['platesRemaining'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  new Text(
                                    "Food-Type : " +
                                        document.data()['typeOfFood'] +
                                        "\n",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  new Text(
                                    "Distance : About " +
                                        (Geodesy().distanceBetweenTwoGeoPoints(
                                                    orgLocation,
                                                    LatLng(
                                                        double.parse(
                                                            document.data()['Location']
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
                                                    double.parse(
                                                        document.data()['Location']['lat']),
                                                    double.parse(document.data()['Location']['long']))))
                                            .toString()[1][0] +
                                        " K.M.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,10,0,0),
                                    child: OutlineButton.icon(
                                      icon: Icon(Icons.call),
                                      textColor:Colors.blue[600],
                                      onPressed: (){
                                        _phoneCall(document.data()['phone']);
                                      },
                                      label: Text(
                                        "Contact Event Organiser\n${document.data()['phone']}",
                                        textAlign:TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  if(plateCapacity-platesOrdered>0)
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: OutlineButton.icon(
                                      icon: Icon(Icons.fastfood),
                                      textColor:Colors.green[500],
                                      onPressed: int.parse(document.data()['platesRemaining'])>0 ? () {
                                        bookAndUpdatePlates(document.id,document.data()['platesRemaining']);
                                        plateCapacityUpdate(document.data()['platesRemaining']);
                                      } : null,
                                      label: Text(
                                        int.parse(document.data()['platesRemaining'])>0 ?
                                        "Book Plates":"Food Not Available",
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
                padding: const EdgeInsets.all(10.0),
                child: Text(
            "No more near-by events found.",
            style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.red[600]),
          ),
              )),
          SizedBox(
            height: 20,
          ),
          //ALL OTHER EVENTS
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Chip(
                    elevation: 3,
                    backgroundColor: Colors.white,
                    label: Text(
                      "Other Events",
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
                    return Column(
                      children: [
                        Container(),
                        if (Geodesy().distanceBetweenTwoGeoPoints(
                                orgLocation,
                                LatLng(
                                    double.parse(
                                        document.data()['Location']['lat']),
                                    double.parse(
                                        document.data()['Location']['long']))) >
                            50000)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Card(
                              elevation: 2,
                              child: new Column(
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
                                    height: 20,
                                    color: Colors.amber[700],
                                  ),
                                  new Text(
                                    "Total Invitation : " +
                                        document.data()['peopleInvited'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Total people arrived : " +
                                        document.data()['peopleTurnedUp'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Total Plates Ordered : " +
                                        document.data()['platesOrdered'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  new Text(
                                    "Plates Remaining : " +
                                        document.data()['platesRemaining'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  new Text(
                                    "Food-Type : " +
                                        document.data()['typeOfFood'] +
                                        "\n",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  new Text(
                                    "Distance : About " +
                                        (Geodesy().distanceBetweenTwoGeoPoints(
                                                    orgLocation,
                                                    LatLng(
                                                        double.parse(document
                                                                .data()[
                                                            'Location']['lat']),
                                                        double.parse(
                                                            document.data()[
                                                                    'Location']
                                                                ['long']))) /
                                                1000)
                                            .toString()
                                            .split(".")[0] +
                                        " K.M.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,10,0,0),
                                    child: OutlineButton.icon(
                                      icon: Icon(Icons.call),
                                      textColor:Colors.blue[600],
                                      onPressed: (){
                                        _phoneCall(document.data()['phone']);
                                      },
                                      label: Text(
                                        "Contact Event Organiser\n${document.data()['phone']}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  if(plateCapacity-platesOrdered>0)
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: OutlineButton.icon(
                                      icon: Icon(Icons.fastfood),
                                      textColor:Colors.amber[600],
                                      onPressed: int.parse(document.data()['platesRemaining'])>0 ? () {
                                        bookAndUpdatePlates(document.id,document.data()['platesRemaining']);
                                        plateCapacityUpdate(document.data()['platesRemaining']);
                                      } : null,
                                      label: Text(
                                        int.parse(document.data()['platesRemaining'])>0 ?
                                        "Book Plates":"Food Not Available",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
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

  Widget notifyMe() {
    myAlert.showNotification();
    return Container();
  }

  //Updates the Plates Remaining of an Event after confirmation
  Future<void> bookAndUpdatePlates(String id,String remainingPlates) {
    requiedbyOrg=plateCapacity-platesOrdered;
    int leftPlates=int.parse(remainingPlates)-requiedbyOrg;
    if(leftPlates<0)
      leftPlates=0;
    return food
        .doc(id)
        .update({'platesRemaining': leftPlates.toString()})
        .then((value) => print("Remaining Plates Updated"))
        .catchError((error) => print("Failed to update remaining plates data: $error"));
  }

  //Updates the Plates Remaining of an ORGANIZATION after confirmation
  Future<void> plateCapacityUpdate(String plates) {
    if(int.parse(plates)>=(requiedbyOrg))
      setState(() {
        platesOrdered+=requiedbyOrg;
      });

    else
      setState(() {
        platesOrdered+=int.parse(plates);
      });


    return orgs
        .doc(orgID.toString())
        .update({'platesOrdered': platesOrdered.toString()})
        .then((value) => print("Ordered Plates Updated"))
        .catchError((error) => print("Failed to update ordered plates data: $error"));
  }

  //getPlate Capacity of orgs
  void _getOrgsPlateCapacity() async {

    var result = await FirebaseFirestore.instance
        .collection("organisations")
        .where("email",
        isEqualTo: FirebaseAuth.instance.currentUser.email.toString())
        .get();
    result.docs.forEach((res) {
      print(res.data());
      setState(() {
        plateCapacity=int.parse(res.data()['plateCapacity']);
        platesOrdered=int.parse(res.data()['platesOrdered']);
        orgID=res.id;
      });
    });
  }

  //refillPlateCapacity
  Future<void> refillPlateCapacity(){
    setState(() {
      platesOrdered=0;
    });

    return orgs
        .doc(orgID.toString())
        .update({'platesOrdered': platesOrdered.toString()})
        .then((value) => print("Refill Plates Updated"))
        .catchError((error) => print("Failed to update refill plates data: $error"));

  }

  //Call Launcher
void _phoneCall(phoneNumber){
  launch("tel:$phoneNumber>");
}



}
