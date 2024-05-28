import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern_assignment/selec.dart';

class home extends GetxController {
  RxBool tw = false.obs;
  RxBool iw = false.obs;
  RxBool bw = false.obs;
  RxBool flag = false.obs;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imag;
  TextEditingController tb = TextEditingController();

  uploadd() async {
    UploadTask up = FirebaseStorage.instance
        .ref("Cover Photos")
        .child('intern')
        .putFile(imag!);
    TaskSnapshot tt = await up;
    String url = await tt.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('Projects').doc('intern').set({
      'text': tb.text.toString(),
      // 'Project_Heading' : ph.text.toString(),
      // 'Project_Description' : de.text.toString(),
      // 'Project_Link' : pl.text.toString(),
      // 'Project_Type' : pt.text.toString(),
      'image': url,
    });
  }

  var controller = Get.put(home());
  @override
  Widget build(BuildContext context) {
    double hh = Get.height;
    double ww = Get.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Assignment App",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Projects")
                  .doc('intern')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Container(
                          height: hh * 0.7,
                          width: ww * 0.85,
                          decoration: BoxDecoration(
                            color: Color(0xfff0fcec),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              Obx(
                                    () => Column(
                                  children: [
                                    if (controller.tw.value)
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Saved Text : ${snapshot.data?['text']}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Container(
                                              height: hh * 0.05,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                              ),
                                              padding: EdgeInsets.only(left: 20),
                                              child: TextField(
                                                controller: tb,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Enter New Text',
                                                  hintStyle: TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    if (controller.iw.value)
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: hh * 0.3,
                                              width: ww * 0.6,
                                              child: Image.network(
                                                snapshot.data?['image'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  img();
                                                },
                                                child: Text(
                                                  'Select Image',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600, fontSize: 15),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Spacer(),
                                    if (controller.bw.value)
                                      Align(
                                        alignment:Alignment.bottomCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: hh * 0.05),
                                          child: SizedBox(
                                            width: ww * 0.17,
                                            child: TextButton(
                                              child: Text(
                                                "Save",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.black, fontSize: 17.5),
                                              ),
                                              onPressed: () {
                                                if (!controller.tw.value &&
                                                    !controller.iw.value &&
                                                    controller.bw.value)
                                                  controller.flag.value = true;
                                                else {
                                                  uploadd();
                                                  Get.snackbar(
                                                    "Success",
                                                    "Successfully Saved",
                                                    snackPosition: SnackPosition.BOTTOM,
                                                  );
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: Color(0xffb0fead),
                                                padding:
                                                EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                                side: BorderSide(
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (!controller.tw.value &&
                                        !controller.iw.value &&
                                        !controller.bw.value)
                                      Align(
                                        child: Text(
                                          "No widgets added.",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                  ],
                                ),
                              ),
                              Obx(
                                    () => controller.flag.value
                                    ? Center(
                                  child: Container(

                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: ww*0.2),
                                      child: Text(
                                        "Add at least a widget to save",
                                        style: TextStyle(fontSize: 27, color: Colors.black,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  } else
                    return Text("No data available");
                } else
                  return Text("No data available");
              },
            ),
            SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: ww * 0.45,
                child: TextButton(
                  child: Text(
                    "Add Widgets",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 17.5),
                  ),
                  onPressed: () {
                    Get.to(() => selection());
                    controller.flag.value=false;
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xffb0fead),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        width: 1,
                        color: Colors.black,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future img() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null || image.path == null) return;

    final temp = File(image.path); // Use image.path directly
    imag = temp;
    setState(() {
      // Update your UI if necessary
    });
  }
}
