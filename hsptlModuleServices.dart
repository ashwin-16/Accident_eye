// ignore_for_file: camel_case_types, library_private_types_in_public_api, use_build_context_synchronously

import 'package:accii/Data/data_sources/FireBaseDS.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Data/models/UserModel.dart';

class hsptlModuleServices extends StatefulWidget {
  const hsptlModuleServices({Key? key}) : super(key: key);

  @override
  _servicesState createState() => _servicesState();
}

class _servicesState extends State<hsptlModuleServices> {
  late Future<List<UserModel>> fUsers;
  double lon = 0;
  double lat = 0;

  @override
  void initState() {
    super.initState();
    fUsers = fetchData();
  }

  Future<List<UserModel>> fetchData() async {
    List<UserModel> data = <UserModel>[];

    while (data.isEmpty) {
      data = await FireBaseDS().realTimeEmergencyFetcher();
      if (data.isEmpty) {
        await Future.delayed(const Duration(
            seconds: 2)); // Introduce a delay before the next fetch attempt
      }
    }
    return data;
  }

  Future<void> _refreshList() async {
    fetchData();
    setState(() {
      fUsers = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: FutureBuilder<List<UserModel>>(
        future: fUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return list(snapshot.data!);
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          _refreshList();
        },
      ),
    );
  }

  Widget list(List<UserModel> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return listItem(users[index]);
      },
    );
  }

  Widget listItem(UserModel model) {
    String name = model.userName ?? '';
    String vNo = model.vehicleNo ?? '';
    String msg = "$name $vNo";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            _showUserDataDialog(model);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUserDataDialog(UserModel model) async {
    String name = model.userName ?? '';
    String vNo = model.vehicleNo ?? '';
    String bloodGroup = model.bloodGroup ?? '';
    String age = model.age ?? '';
    String phn = model.phoneNumber ?? '';

    String url = await _loadCordinates(vNo);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Detected'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'The person ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: ' of age ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: age,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: ' with ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: '$bloodGroup',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text:
                          ' bloodgroup met with an accident involving vehicle ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: vNo,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: ' at ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: url,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: '. Please initiate an emergency rescue attempt.',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  //Update the _loadCordinates function
  Future<String> _loadCordinates(String vNo) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref();
      final vehicleRef = databaseReference.child('vehicle').child(vNo);

      DataSnapshot snapshot = await vehicleRef.get();

      if (snapshot.value != null) {
        final data = snapshot.value;

        if (data is Map) {
          final count = data['counter'] ?? 0;

          if (count == 1) {
            final location = data['location'];

            if (location is Map && location.containsKey('lat') && location.containsKey('lon')) {
              var tempLat = double.parse(location['lat'].toString());
              var tempLong = double.parse(location['lon'].toString());

              lat = tempLat;
              lon = tempLong;
              String mapUrl = 'https://www.google.com/maps?q=$lat,$lon';

              return mapUrl;
            }
          }
        }
      }
    } catch (error) {
      print("Error fetching location data: $error");
    }

    return "";
  }
}
