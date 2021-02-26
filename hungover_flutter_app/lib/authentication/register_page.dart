import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:location/location.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

//fireStore
// Create a CollectionReference called users that references the firestore collection
CollectionReference orgs = FirebaseFirestore.instance.collection('organisations');
//

/// Entrypoint example for registering via Email/Password.
class RegisterPage extends StatefulWidget {
  /// The page title.
  final String title = 'Registration';

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _org_nameTC = TextEditingController();
  final TextEditingController _org_phoneTC = TextEditingController();
  final TextEditingController  _latTC= TextEditingController();
  final TextEditingController  _longTC= TextEditingController();

  bool _success;
  String _userEmail = '';

  //registration details
  String org_name, org_phone, org_latitude="--", org_longitude='--';

  final Location location = Location();

  LocationData _location;
  String _error;

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      setState(() {
        _location = _locationResult;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    org_latitude='--'; org_longitude='--';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Organisation Email'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,

                      decoration: const InputDecoration(labelText: 'Password (use atleast 6 characters)'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    ///////////////////////////////////////--------->>> registration details
                    TextFormField(
                      controller: _org_nameTC,
                      decoration: const InputDecoration(labelText: 'Organisation Name'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: _org_phoneTC,
                      decoration: const InputDecoration(labelText: 'Organisation Contact number'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Divider(height: 25,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Your Organisation Current Location:",textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: OutlineButton.icon(onPressed: (){
                        _getLocation();
                        setState(() {
                          org_latitude=_location.latitude.toString();
                          org_longitude=_location.longitude.toString();
                        });
                      }, icon: Icon(Icons.location_on), label: Text("Get Curent Location"))),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Latitude: $org_latitude \nLongitude: $org_longitude",textAlign: TextAlign.start,),
                    ),

                    Divider(height: 25,),



                    //////////////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: SignInButtonBuilder(
                        icon: Icons.person_add,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () async {
                          if (_formKey.currentState.validate() && (org_latitude!=null || org_latitude!="--")) {
                            await _register();
                          }
                        },
                        text: 'Register',
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(_success == null
                          ? ''
                          : (_success
                              ? 'Successfully registered:\n$_userEmail'
                              : 'Registration failed'),style: TextStyle(fontSize: 18,color: Colors.red),),
                    )
                  ],
                ),
              ),
            )),]
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return orgs
        .add({
      'email': _emailController.text, //
      'latitude': org_latitude, //
      'longitude': org_longitude ,
      'org_name': _org_nameTC.text,
      'org_phone':_org_phoneTC.text
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // Example code for registration.
  Future<void> _register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      //add orgs
      addUser();
      setState(() {
        _success = true;
        _userEmail = user.email;

      });
    } else {
      _success = false;
    }
}
}


