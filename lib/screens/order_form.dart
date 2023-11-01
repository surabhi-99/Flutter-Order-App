// ignore_for_file: unused_field, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({Key? key}) : super(key: key);

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();

  String timestamp = '';
  String orderId = '';
  String consignorName = '';
  String consigneeName = '';
  String fromAddress = '';
  String fromPincode = '';
  String toAddress = '';
  String toPincode = '';
  String enquiryType = '';
  String materialDimensions = '';
  double materialWeight = 0.0;
  String materialType = 'Type A';
  String vehicleType = 'Car';
  double expectedVehicleLength = 0.0;
  String materialHarnessing = '';
  bool isMaterialStackable = false;
  String loadingType = 'Type X';
  String optionalPhotoURL = '';
  late LatLng selectedLocation;
  String vehicleLoadCapacity = '';

  List<String> vehicleTypes = ['Car', 'Truck', 'Bike', 'Van'];
  List<String> materialTypes = ['Type A', 'Type B', 'Type C', 'Type D'];
  List<String> loadCapacities = ['Light', 'Medium', 'Heavy'];
  List<String> loadingTypes = ['Type X', 'Type Y', 'Type Z'];

  Future<void> _uploadPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('photos/${DateTime.now()}.png');
      await storageReference.putFile(imageFile);
      final String downloadURL = await storageReference.getDownloadURL();
      setState(() {
        optionalPhotoURL = downloadURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Order ID'), 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the order ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  orderId = value!;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Timestamp'), 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the timestamp';
                  }
                  return null;
                },
                onSaved: (value) {
                  timestamp = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Consignor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter consignor name';
                  }
                  return null;
                },
                onSaved: (value) {
                  consignorName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Consignee Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter consignee name';
                  }
                  return null;
                },
                onSaved: (value) {
                  consigneeName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'From Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter from address';
                  }
                  return null;
                },
                onSaved: (value) {
                  fromAddress = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'From Pincode'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter from pincode';
                  }
                  return null;
                },
                onSaved: (value) {
                  fromPincode = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'To Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter to address';
                  }
                  return null;
                },
                onSaved: (value) {
                  toAddress = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'To Pincode'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter to pincode';
                  }
                  return null;
                },
                onSaved: (value) {
                  toPincode = value!;
                },
              ),
              Row(
                children: [
                  const Text('Enquiry Type:'),
                  Radio<String>(
                    value: 'Type A',
                    groupValue: enquiryType,
                    onChanged: (value) {
                      setState(() {
                        enquiryType = value!;
                      });
                    },
                  ),
                  const Text('Type A'),
                  Radio<String>(
                    value: 'Type B',
                    groupValue: enquiryType,
                    onChanged: (value) {
                      setState(() {
                        enquiryType = value!;
                      });
                    },
                  ),
                  const Text('Type B'),
                ],
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Material Dimensions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter material dimensions';
                  }
                  return null;
                },
                onSaved: (value) {
                  materialDimensions = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Material Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter material weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  materialWeight = double.parse(value!);
                },
              ),
              DropdownButtonFormField(
                items:
                    materialTypes.map<DropdownMenuItem<String>>((String type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    materialType = value.toString();
                  });
                },
                value: materialType,
                decoration: const InputDecoration(labelText: 'Material Type'),
              ),
              Row(
                children: [
                  const Text('Vehicle Load Capacity: '),
                  for (var capacity in loadCapacities)
                    Row(
                      children: [
                        Radio<String>(
                          value: capacity,
                          groupValue: vehicleLoadCapacity,
                          onChanged: (value) {
                            setState(() {
                              vehicleLoadCapacity = value!;
                            });
                          },
                        ),
                        Text(capacity),
                      ],
                    ),
                ],
              ),
              DropdownButtonFormField(
                items: vehicleTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    vehicleType = value.toString();
                  });
                },
                value: vehicleType,
                decoration: const InputDecoration(labelText: 'Vehicle Type'),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Expected Vehicle Length'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expected vehicle length';
                  }
                  return null;
                },
                onSaved: (value) {
                  expectedVehicleLength = double.parse(value!);
                },
              ),
              Row(
                children: [
                  const Text('Is Material Stackable: '),
                  Radio<bool>(
                    value: true,
                    groupValue: isMaterialStackable,
                    onChanged: (value) {
                      setState(() {
                        isMaterialStackable = value!;
                      });
                    },
                  ),
                  const Text('Yes'),
                  Radio<bool>(
                    value: false,
                    groupValue: isMaterialStackable,
                    onChanged: (value) {
                      setState(() {
                        isMaterialStackable = value!;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              DropdownButtonFormField(
                items: loadingTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    loadingType = value.toString();
                  });
                },
                value: loadingType,
                decoration: const InputDecoration(labelText: 'Loading Type'),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Material Harnessing'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter material harnessing';
                  }
                  return null;
                },
                onSaved: (value) {
                  materialHarnessing = value!;
                },
              ),
              ElevatedButton(
                onPressed: () => _uploadPhoto(),
                child: const Text('Upload Photo'),
              ),
              /*  ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Simulate the submission by printing the order data to the console
                    print("Order Data:");
                    print("Order ID: $orderId");
                    print("Timestamp: $timestamp");                    
                    print("Consignor Name: $consignorName");
                    print("Consignee Name: $consigneeName");
                    print("From Address: $fromAddress");
                    print("From Pincode: $fromPincode");
                    print("To Address: $toAddress");
                    print("To Pincode: $toPincode");
                    print("Enquiry Type: $enquiryType");
                    print("Material Dimensions: $materialDimensions");
                    print("Material Weight: $materialWeight");
                    print("Material Type: $materialType");
                    print("Vehicle Type: $vehicleType");
                    print("Expected Vehicle Length: $expectedVehicleLength");
                    print("Optional Photo URL: $optionalPhotoURL");
                    print("Location Latitude: ${selectedLocation.latitude}");
                    print("Location Longitude: ${selectedLocation.longitude}");
                    print("Is Material Stackable: $isMaterialStackable");
                    print("Loading Type: $loadingType");
                    print("Material Harnessing: $materialHarnessing");

                    // Show a success message using SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order submitted locally!'),
                        duration: Duration(
                            seconds: 5), // Adjust the duration as needed
                      ),
                    );
                  }
                },
                child: const Text('Submit Locally'),
              ),
             */
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Map<String, dynamic> orderData = {
                      'Timestamp': timestamp,
                      'Order ID': orderId,
                      'Consignor Name': consignorName,
                      'Consignee Name': consigneeName,
                      'From Address': fromAddress,
                      'From Pincode': fromPincode,
                      'To Address': toAddress,
                      'To Pincode': toPincode,
                      'Enquiry Type': enquiryType,
                      'Material Dimensions': materialDimensions,
                      'Expected Vehicle Length': expectedVehicleLength,
                      'Material Type': materialType,
                      'Vehicle Type': vehicleType,
                      'Optional Photo URL': optionalPhotoURL,
                      'Location Latitude': selectedLocation.latitude,
                      'Location Longitude': selectedLocation.longitude,
                      'Is Material Stackable': isMaterialStackable,
                      'Loading Type': loadingType,
                      'Material Harnessing': materialHarnessing,
                    };

                    // Store the data in Firebase Firestore
                    _firestore.collection('orders').add(orderData);

                    // Show a success message or navigate to a new screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order submitted successfully!'),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
