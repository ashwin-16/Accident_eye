import 'package:accii/Data/data_sources/LocalDS.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewMapPage extends StatefulWidget {
  const WebViewMapPage({super.key});

  @override
  _WebViewMapPageState createState() => _WebViewMapPageState();
}

class _WebViewMapPageState extends State<WebViewMapPage> {
  late WebViewController webViewController;
  double lon = 0;
  double lat = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'about:blank', // You can use any initial URL here
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          webViewController = controller;
          _loadCordinates();
        },
      ),
    );
  }

  ///This method should be in data-source
  void _loadCordinates() async {
    String vNo = await LdsServices().getValue("vID");

    // Access Realtime Database instance
    final databaseReference = FirebaseDatabase.instance.ref();

    // Reference to the "vehicle" location in the Realtime Database
    final vehicleRef = databaseReference.child('vehicle').child(vNo);

    DataSnapshot snapshot = await vehicleRef.get();

    final data = snapshot.value;
    if (data != null && data is Map) {
      final count = data['counter']??0;
      if(count==1){
        final location = data['location'];
        var tempLat = double.parse(location['lat'].toString());
        var tempLong = double.parse(location['lon'].toString());
        if (location is Map && lat != tempLat && lon != tempLong) {
          lat = tempLat;
          lon = tempLong;
          String mapUrl = 'https://www.google.com/maps?q=$lat,$lon';
          webViewController.loadUrl(mapUrl);
          // print("map : $mapUrl");
          // Now you have the latitude and longitude values from the Realtime Database
        } else {}
      }else{
        // Not in emergency..
      }
    } else {}
  }
}

