import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hungover_flutter_app/authentication/main.dart';
import 'package:hungover_flutter_app/authentication/register_page.dart';
import 'package:hungover_flutter_app/authentication/signin_page.dart';
import 'package:hungover_flutter_app/home.dart';
import 'package:location/location.dart';
import 'get_location.dart';
import 'listen_location.dart';
import 'permission_status.dart';
import 'service_enabled.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Location location = Location();

  PermissionStatus _permissionGranted;

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
    }
  }

  bool _serviceEnabled;

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    _checkPermissions();
    _requestService();
    _checkService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HungOver",
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Welcome to the HungOver Project Initiative.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Divider(height: 32),
          if (_permissionGranted != PermissionStatus.granted ||
              _serviceEnabled != true)
            Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Permission status: ${_permissionGranted ?? "unknown"}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 42),
                          child: RaisedButton(
                            child: const Text('Check Status'),
                            onPressed: _checkPermissions,
                          ),
                        ),
                        RaisedButton(
                          child: const Text('Grant Request'),
                          onPressed:
                              _permissionGranted == PermissionStatus.granted
                                  ? null
                                  : _requestPermission,
                        )
                      ],
                    )
                  ],
                ),
                Divider(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Service enabled: ${_serviceEnabled ?? "unknown"}',
                        style: Theme.of(context).textTheme.bodyText1),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 42),
                          child: RaisedButton(
                            child: const Text('Check Status'),
                            onPressed: _checkService,
                          ),
                        ),
                        RaisedButton(
                          child: const Text('Grant Request'),
                          onPressed:
                              _serviceEnabled == true ? null : _requestService,
                        )
                      ],
                    ),
                  ],
                ),
                Divider(height: 32),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Kindly, grant the Location permission & Location services for the proper functioning of the app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                // GetLocationWidget(),
                // Divider(height: 32),
                // ListenLocationWidget(),
                // Divider(height: 32),
              ],
            ),
          if (_permissionGranted == PermissionStatus.granted &&
              _serviceEnabled == true)
            Column(
              children: [
                Text("You are good to Go."),
                Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton.icon(
                      onPressed: () {
                        if(FirebaseAuth.instance.currentUser==null)
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthTypeSelector() ));
                        else
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(FirebaseAuth.instance.currentUser) ));
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                      label: Text("Proceed")),
                ),

              ],
            ),
        ]),
      ),
    );
  }
}
