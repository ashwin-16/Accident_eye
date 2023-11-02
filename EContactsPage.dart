
// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert';

import '../../../../Data/data_sources/FireBaseDS.dart';
import '../../../../Data/data_sources/LocalDS.dart';
import '../../../../Data/models/ContactModel.dart';

class EmergencyContacts extends StatefulWidget {
  const EmergencyContacts({Key? key}) : super(key: key);

  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  List<ContactModel> selectedContacts = [];
  String messageToContacts =
      'I have met with an accident. Please help!'; // Default message
  late String messagePrompt = "";

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _sendMessages();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString('emergencyContacts');
    if (contactsJson != null) {
      final List<dynamic> contactsList = json.decode(contactsJson);
      final List<ContactModel> loadedContacts = contactsList
          .map((contact) => ContactModel.fromJson(contact))
          .toList();
      setState(() {
        selectedContacts = loadedContacts;
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson =
    json.encode(selectedContacts.map((contact) => contact.toJson()).toList());
    await prefs.setString('emergencyContacts', contactsJson);
  }

  Future<void> _deleteContact(int index) async {
    selectedContacts.removeAt(index);
    await _saveContacts();
    setState(() {});
  }

  Future<void> _pickContacts() async {
    try {
      final Contact? pickedContact = await _contactPicker.selectContact();
      if (pickedContact != null) {
        final contactModel = ContactModel(
          name: pickedContact.fullName ?? '',
          phoneNumber: pickedContact.phoneNumbers!.isNotEmpty
              ? pickedContact.phoneNumbers!.first
              : 'No phone number',
        );
        setState(() {
          selectedContacts.add(contactModel);
        });
        _saveContacts();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking contacts: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[100], // Change color as desired
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'This is the message sent to emergency contacts',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      messagePrompt,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: selectedContacts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final contact = entry.value;
                    return ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phoneNumber ?? 'No phone number'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteContact(index);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickContacts,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _loadMsg() async {
    String vNo = await LdsServices().getValue("vID");

    final databaseReference = FirebaseDatabase.instance.ref();
    final vehicleRef = databaseReference.child('vehicle').child(vNo);

    await vehicleRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      final data = snapshot.value;
      if (data != null && data is Map) {
        final location = data['location'];
        if (location is Map) {
          final double lat = (double.parse(location['lat'].toString()));
          final double lon = double.parse(location['lon'].toString());

          String mapUrl = 'https://www.google.com/maps?q=$lat,$lon';

          setState(() {
            messagePrompt =
            "I have met with an accident. Please help!\nThis is my location: $mapUrl";
          });
        }
      }
    }).catchError((error) {
      // Handle errors, e.g., database not reachable
    });
  }

  Future<void> sendMessageToContacts(String message) async {
    for (final contact in selectedContacts) {
      final String encodedMessage = Uri.encodeComponent(message);
      final Uri uri = Uri(
        scheme: 'sms',
        path: contact.phoneNumber ?? '',
        queryParameters: {'body': encodedMessage},
      );

      print('Attempting to send SMS using URL: $uri'); // Add this line

      try {
        if (await canLaunch(uri.toString())) {
          await launch(uri.toString());
        } else {
          if (kDebugMode) {
            print('Could not launch the SMS app');
          }
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  Future<void> _sendMessages() async {
    if(await FireBaseDS().isEmergency(await LdsServices().getValue("vID"))){
      await _loadMsg();
      sendMessageToContacts(messagePrompt);
    }
  }

}
