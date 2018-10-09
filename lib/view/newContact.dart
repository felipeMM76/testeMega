import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mega_test/model/user.dart';
import 'package:mega_test/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class NewContactPage extends StatefulWidget {
  final User myUser;

  NewContactPage({Key key, @required this.myUser}) : super(key: key);

  @override
  _NewContactPageState createState() => _NewContactPageState(myUser: myUser);
}

class _NewContactPageState extends State<NewContactPage> {
  var _formKey = new GlobalKey<FormState>();
  var _nameController = new TextEditingController();
  var _phoneController = new MaskedTextController(mask: '(00) 00000-0000');
  var _addressController = new TextEditingController();


  File _photo;
  User myUser = new User();
  bool editUser = false;

  _NewContactPageState({this.myUser}) {
    if (myUser != null) {
      _nameController.text = myUser.name;
      _phoneController.text = myUser.phone;
      _addressController.text = myUser.address;
      editUser = true;
    }
    else{
      myUser = new User();
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = image;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text('Perfil', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600,),),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _panelProfile(),
        bottomNavigationBar:
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: new FlatButton(
            onPressed: _updateProfile,
            padding: EdgeInsets.all(0.0),
            child: new Container(
              height: 50.0,
              decoration: new BoxDecoration(
                color: AppColors.colorPrimary,
                borderRadius: BorderRadius.circular(5.0)),
              child: Center(
                child: new Text('Salvar',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Branding',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold))))),
        ),
      ),
    );
  }


  Widget _panelProfile() {
    return new Center(
      child: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
        children: <Widget>[

          new Center(
            child: FlatButton(
              onPressed: () {
                getImage();
              },
              child: new Container(
                width: 140.0,
                height: 140.0,
                child: new CircleAvatar(
                  backgroundImage: _photo == null ? (myUser.photo != null ? new NetworkImage(myUser.photo) : new AssetImage('assets/images/user.png')) : new FileImage(_photo),
                  )),
            )),
          SizedBox(height: 50.0),

          //name
          new TextFormField(
            controller: _nameController,
            style: TextStyle(color: Colors.black, fontFamily: 'Intelo'),
            keyboardType: TextInputType.text,
            autofocus: false,
            onSaved: (v) => myUser.name = v,
            validator: (v) {
              return v.isEmpty ? 'Informe o nome.' : null;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              labelText: 'Nome completo',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),

          // phone
          new TextFormField(
            controller: _phoneController,
            style: TextStyle(color: Colors.black, fontFamily: 'Intelo'),
            keyboardType: TextInputType.number,
            autofocus: false,
            onSaved: (v) => myUser.phone = v,
            validator: (v) {
              return v.isEmpty ? 'Informe o Telefone.' : null;
            },
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              labelText: 'Telefone',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),

          //Endereco
          new TextFormField(
            controller: _addressController,
            style: TextStyle(color: Colors.black, fontFamily: 'Intelo'),
            keyboardType: TextInputType.text,
            autofocus: false,
            onSaved: (v) => myUser.address = v,
            validator: (v) {
              return v.isEmpty ? 'Informe o Endereço.' : null;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              labelText: 'Endereço',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }


  _updateProfile() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context);
      editUser ? uploadFile(myUser.id, myUser.toJson()) : addFile(myUser.toJson());
    }
  }



  Future<Null> addFile(myData) async {
    if (_photo != null) {
      final String fileName = "${Random().nextInt(10000)}.jpg";
      final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = ref.putFile(_photo);
      uploadTask.onComplete.then((result) =>
        result.ref.getDownloadURL().then((res) {
          print(res);
          myUser.photo = res;
          addData(myUser.toJson());
        }));
    }
    else{
      addData(myData);
    }
  }




  Future<Null> uploadFile(String id, myData) async {
    if (_photo != null) {
      final String fileName = myUser.photo!=null ? myUser.photo : "${Random().nextInt(10000)}.jpg";
      final StorageReference ref = FirebaseStorage.instance.ref().child(fileName.split('/o/')[1].split('?')[0]);
      StorageUploadTask uploadTask = ref.putFile(_photo);
      uploadTask.onComplete.then((result) =>
        result.ref.getDownloadURL().then((res) {
          print(res);
          myUser.photo = res;
          updateData(id, myUser.toJson());
        }));
    }
    else{
      updateData(id, myData);
    }
  }


  addData(myData) {
    Firestore.instance.collection('user').add(myData).catchError((e) {
      print(e);
    });
  }



  updateData(String id, myData) {
    Firestore.instance.collection('user').document(id).updateData(myData).catchError((e) {
      print(e);
    });
  }




}







