import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hungover_flutter_app/notification.dart';

import 'geoLocationLocator/main.dart';

CollectionReference food = FirebaseFirestore.instance.collection('DonateFood');
Stream collectionStream =
    FirebaseFirestore.instance.collection('DonateFood').snapshots();

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
              return
              FlatButton(
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
        body: StreamBuilder<QuerySnapshot>(
            stream: food.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              return new ListView(
                padding: EdgeInsets.symmetric(horizontal:5,vertical: 5),
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  if (document.data()["name"] == "u") {
                    myAlert.showNotification();
                  }
                  return  Padding(
                    padding: const EdgeInsets.symmetric(vertical:2.0),
                    child: Card(
                      color: Color.fromRGBO(200, 225, 225, 10),
                      elevation: 2,
                      child: new Column(

                        children: [
                          new Text("\nEvent Organiser: "+document.data()['name'].toString().toUpperCase(),style: TextStyle(fontSize: 18),),
                          Divider(height: 20,color: Colors.amber,),
                          new Text("Total Invitation: "+document.data()['peopleInvited'],style: TextStyle(fontSize: 16),),
                          new Text("Total people arrived: "+document.data()['peopleTurnedUp'],style: TextStyle(fontSize: 16),),
                          new Text("Total Plates Ordered: "+document.data()['platesOrdered'],style: TextStyle(fontSize: 16),),
                          new Text("Plates Remaining: "+document.data()['platesRemaining'],style: TextStyle(fontSize: 16),),
                          new Text("Food-Type: "+document.data()['typeOfFood']+"\n",style: TextStyle(fontSize: 16),),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }));
  }

  // Example code for sign out.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
