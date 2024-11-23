import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  // Constructor to receive the data from SignUpScreen
  PersonalInfoScreen({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _aadharController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with pre-filled data
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController();
    _aadharController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _aadharController,
              decoration: InputDecoration(labelText: 'Aadhar Card Number'),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you can handle saving/updating the user's personal info
                print('Name: ${_nameController.text}');
                print('Email: ${_emailController.text}');
                print('Phone: ${_phoneController.text}');
                print('Address: ${_addressController.text}');
                print('Aadhar: ${_aadharController.text}');
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
