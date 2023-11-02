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
  LatLng selectedLocation = const LatLng(0, 0);
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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> orderData = {
        'Timestamp': DateTime.now().millisecondsSinceEpoch,
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

      _firestore.collection('orders').add(orderData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order submitted successfully!'),
        ),
      );
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
                  decoration: const InputDecoration(labelText: 'Order ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the order ID';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      orderId = value;
                    });
                  }),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Consignor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter consignor name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    consignorName = value;
                  });
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
                onChanged: (value) {
                  setState(() {
                    consigneeName = value;
                  });
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
                onChanged: (value) {
                  setState(() {
                    fromAddress = value;
                  });
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
                onChanged: (value) {
                  setState(() {
                    fromPincode = value;
                  });
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
                onChanged: (value) {
                  setState(() {
                    toAddress = value;
                  });
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
                onChanged: (value) {
                  setState(() {
                    toPincode = value;
                  });
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text('Enquiry Type:'),
              Row(
                children: [
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
                onChanged: (value) {
                  setState(() {
                    materialDimensions = value;
                  });
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
                onChanged: (value) {
                  setState(() {
                    materialWeight = double.parse(value);
                  });
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
              const SizedBox(
                height: 25,
              ),
              const Text('Vehicle Load Capacity: '),
              Row(
                children: [
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
                onChanged: (value) {
                  setState(() {
                    expectedVehicleLength = double.parse(value);
                  });
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text('Is Material Stackable: '),
              Row(
                children: [
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
                onChanged: (value) {
                  setState(() {
                    materialHarnessing = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Latitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Latitude';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    selectedLocation =
                        LatLng(double.parse(value), selectedLocation.longitude);
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Longitude';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    selectedLocation =
                        LatLng(selectedLocation.latitude, double.parse(value));
                  });
                },
              ),
              const SizedBox(
                height: 25,
              ),
              OutlinedButton(
                onPressed: () => _uploadPhoto(),
                child: const Text('Upload Photo'),
              ),
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
