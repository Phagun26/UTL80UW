import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';


class selectget extends GetxController{
  RxBool tw = false.obs;
  RxBool iw = false.obs;
  RxBool bw = false.obs;

  var controller = Get.put(home());
  void change(int ind)
  {
    if(ind==1)
      tw.value = !tw.value;
    else if(ind==2)
      iw.value = !iw.value;
    else
      bw.value = !bw.value;

  }
  void ontapp()
  {
    controller.tw.value = tw.value;
    controller.iw.value = iw.value;
    controller.bw.value = bw.value;
  }



}
class selection extends StatefulWidget {
  const selection({super.key});

  @override
  State<selection> createState() => _selectionState();
}

class _selectionState extends State<selection> {
  double ww = Get.width;
  double hh = Get.height;
  var controller = Get.put(selectget());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0fcec),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: ww*0.15),
          child: Column(
            children: [
              SizedBox(height: hh*0.2,),
             InkWell(
               onTap: () {
                 controller.change(1);
               },
               child: Container(
                 height: hh*0.05,
                child: Row(
                children: [
                  Container(
                    width: ww*0.1,
                    height: hh*0.05,
                    padding: EdgeInsets.all(9),
                    color: Colors.white,
                    child: Obx(
                      ()=>  CircleAvatar(
                        radius: 10,
                        backgroundColor:controller.tw.value?Colors.green:Colors.grey.shade300 ,
                      ),
                    ),
                  ),
                 Container(
                   padding: EdgeInsets.only(left: 25),
                   width: ww*0.6,
                   alignment: Alignment.centerLeft,
                   color: Colors.grey.shade300,
                   child: Text("Text Widget",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                 )
                ],
                         )
                ),
             ),
              SizedBox(height: hh*0.07,),
              InkWell(
                onTap: () {
                  controller.change(2);
                },
                child: Container(
                    height: hh*0.05,
                    child: Row(
                      children: [
                        Container(
                          width: ww*0.1,
                          height: hh*0.05,
                          padding: EdgeInsets.all(9),
                          color: Colors.white,
                          child: Obx(
                                ()=>  CircleAvatar(
                              radius: 10,
                              backgroundColor:controller.iw.value?Colors.green:Colors.grey.shade300 ,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          width: ww*0.6,
                          alignment: Alignment.centerLeft,
                          color: Colors.grey.shade300,
                          child: Text("Image Widget",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        )
                      ],
                    )
                ),
              ),
              SizedBox(height: hh*0.07,),
              InkWell(
                onTap: () {
                  controller.change(3);
                },
                child: Container(
                    height: hh*0.05,
                    child: Row(
                      children: [
                        Container(
                          width: ww*0.1,
                          height: hh*0.05,
                          padding: EdgeInsets.all(9),
                          color: Colors.white,
                          child: Obx(
                                ()=>  CircleAvatar(
                              radius: 10,
                              backgroundColor:controller.bw.value?Colors.green:Colors.grey.shade300 ,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          width: ww*0.6,
                          alignment: Alignment.centerLeft,
                          color: Colors.grey.shade300,
                          child: Text("Button Widget",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        )
                      ],
                    )
                ),
              ),
              SizedBox(height: hh*0.2,),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: ww*0.45,
                  child: TextButton(
                    child: Text("Import Widgets",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 17.5,fontWeight: FontWeight.bold),),
                    onPressed: (){
                      controller.ontapp();
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xffb0fead),
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),

                        ),
                        side: BorderSide(
                          width: 2,
                          color: Colors.black,
                        )
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
