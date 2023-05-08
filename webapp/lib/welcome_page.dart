import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webapp/user_data_model.dart';
import 'package:webapp/user_data_form.dart';
import 'package:webapp/authentication.dart';
import 'package:cross_file/cross_file.dart';
import 'package:webapp/main.dart';

class WelcomePage extends StatefulWidget {
  final User user;

  WelcomePage({required this.user});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late Stream<UserData?> _userDataStream;
  late UserData _userData =
      UserData(name: '', address: '', profilePictureUrl: '');
  XFile? _imageFile;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _userDataStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .snapshots()
        .map((snapshot) => UserData.fromMap(snapshot.data() ?? {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_userData.profilePictureUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
          Hero(
            tag: 'profile_picture',
            child: GestureDetector(
              onTap: () => _pickImage(),
              child: CircleAvatar(
                backgroundImage: _userData.profilePictureUrl != null
                    ? NetworkImage(_userData.profilePictureUrl!)
                    : null,
                child: _userData.profilePictureUrl == null
                    ? Icon(Icons.person)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<UserData?>(
        stream: _userDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _userData = snapshot.data!;
            _nameController.text = _userData.name;
            _addressController.text = _userData.address;
          }
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome, ${widget.user.email}!'),
                SizedBox(height: 16.0),
                Text('Please enter your name and address below:'),
                SizedBox(height: 16.0),
                UserDataForm(
                  nameController: _nameController,
                  addressController: _addressController,
                  onSave: _saveUserInfo,
                  key: _formKey,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveUserInfo() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      return;
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    await userRef.set(UserData(name: name, address: address).toMap(),
        SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('User info saved')));
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users/${widget.user.uid}/profile.jpg');

    final metadata = SettableMetadata(contentType: 'image/jpeg');

    final uploadTask =
        storageRef.putData(await _imageFile!.readAsBytes(), metadata);

    uploadTask.whenComplete(() => _saveImage(storageRef));
  }

  Future<void> _saveImage(Reference storageRef) async {
    final downloadUrl = await storageRef.getDownloadURL();

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.user.uid);

    await userRef.set({
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'profilePictureUrl': downloadUrl,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('User info saved')));
    setState(() {});
  }
}
