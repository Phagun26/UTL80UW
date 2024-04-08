import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
bool _isTextboxSelected = false;
bool _isImageboxSelected = false;
bool _isSaveButtonSelected = false;
class _HomePageState extends State<HomePage> {

  File? imag;
  TextEditingController tb = TextEditingController();




  bool _tempTextboxSelected = false;
  bool _tempImageboxSelected = false;
  bool _tempSaveButtonSelected = false;



  void _saveData() {
    setState(() {
      _isTextboxSelected = _tempTextboxSelected;
      _isImageboxSelected = _tempImageboxSelected;
      _isSaveButtonSelected = _tempSaveButtonSelected;
    });

    if (!_isTextboxSelected && !_isImageboxSelected && !_isSaveButtonSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Add at least one widget to save."),
        ),
      );
    } else {
      // Clear existing widgets
      setState(() {
        _tempTextboxSelected = false;
        _tempImageboxSelected = false;
        _tempSaveButtonSelected = false;
      });

      // Save data
      print("Data saved!");
      Navigator.of(context).pop(); // Close bottom sheet
    }
  }
  uploadd()async{
    UploadTask up = FirebaseStorage.instance.ref("Cover Photos").child('intern').putFile(imag!);
    TaskSnapshot tt = await up;
    String url = await tt.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('Projects').doc('intern').set(
        {
          'text' : tb.text.toString(),
          // 'Project_Heading' : ph.text.toString(),
          // 'Project_Description' : de.text.toString(),
          // 'Project_Link' : pl.text.toString(),
          // 'Project_Type' : pt.text.toString(),
          'image' : url,
        });

  }

  @override
  Widget build(BuildContext context) {
    double hh = Get.height;
    double ww = Get.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment App", style: TextStyle(fontSize: 25),textAlign: TextAlign.center,),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Projects").doc('intern').snapshots(),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.active)
            {
              if(snapshot.hasData)
                {
                  print(snapshot);
                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                    
                        height: hh*0.8,
                        width: ww*0.7,
                        decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: Column(
                            children: [
                    
                              if (_isTextboxSelected) Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text("TextBox", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                                    Text('Saved Text : ${snapshot.data?['text']}', style: TextStyle(fontSize: 20),),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                        )
                                      ),
                                      padding: EdgeInsets.all(7),
                                      child: TextField(
                                        controller: tb,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter New Text',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                    
                              ),
                              if (_isImageboxSelected) Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text("Imagebox",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                                    Container(
                                      height: hh*0.3,
                                      width: ww*0.6,
                                      child: Image.network(
                                        snapshot.data?['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                    
                                    // Text('Saved Text : '),
                                    Container(
                    
                                      alignment: Alignment.bottomCenter,
                                      child: ElevatedButton(onPressed: (){img();}, child: Text(
                                        'Select Image', style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15
                                      ),
                                      )
                                      ),),
                                  ],
                                ),
                    
                              ),
                              Spacer(),
                              if (_isSaveButtonSelected) Padding(
                                padding:  EdgeInsets.only(bottom: hh*0.05),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(_isSaveButtonSelected==true && _isTextboxSelected==false && _isImageboxSelected==false)
                                      Get.snackbar('Error', 'Add Atleast one Widget to Proceed',snackPosition: SnackPosition.BOTTOM);
                                    else
                                      uploadd();

                                  },
                                  child: Text("Save", style: TextStyle(fontSize: 19),),
                                ),
                              ),
                              if (!_isTextboxSelected && !_isImageboxSelected && !_isSaveButtonSelected)
                                Align(child: Text("No widgets added.",style: TextStyle(fontSize: 30),), alignment: Alignment.topCenter,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              else
                return Text("No data available");

            }
          else
            return Text("No data available");

        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CheckboxListTile(
                          title: Text("Textbox"),
                          value: _tempTextboxSelected,
                          onChanged: (bool? value) => setState(() => _tempTextboxSelected = value!),
                        ),
                        CheckboxListTile(
                          title: Text("Imagebox"),
                          value: _tempImageboxSelected,
                          onChanged: (bool? value) => setState(() => _tempImageboxSelected = value!),
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                        ),
                        CheckboxListTile(
                          title: Text("Button Widget"),
                          value: _tempSaveButtonSelected,
                          onChanged: (bool? value) => setState(() => _tempSaveButtonSelected = value!),
                        ),
                        ElevatedButton(
                          onPressed: _saveData,
                          child: Text("Save"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        tooltip: 'Add Widget',
        child: Icon(Icons.add),
      ),
    );


  }
  Future img() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null || image.path == null) return;

    final temp = File(image.path); // Use image.path directly
    imag = temp ;
    setState(() {
      // Update your UI if necessary
    });
  }
}

class Textbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      color: Colors.blueGrey,
      child: Text("Textbox"),
    );
  }
}

class Imagebox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text("Imagebox"),
          Text('Saved Text : '),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter New Text',
            ),
          )
        ],
      ),

    );
  }
}

