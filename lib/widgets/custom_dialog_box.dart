import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/common/constants.dart';
import 'package:userapp/models/request_model.dart';
import 'package:userapp/models/route_model.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/providers/request_provider.dart';
import 'package:userapp/screens/driver_profile_screen.dart';
import 'package:userapp/services/firebase_helper.dart';
import 'package:userapp/services/notification_service.dart';

import '../common/app_colors.dart';
import '../common/custom_button.dart';

class CustomDialogBox extends StatefulWidget {
  final String title,
      text,
      img,
      startDate,
      endDate,
      plateNumber,
      driver,
      deviceToken,
      otherDeviceToken,
      driverId,
      docId;
  final RouteModel route;
  final String routeId;
  final VoidCallback? onDriverPressed;
  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.text,
    required this.img,
    required this.startDate,
    required this.endDate,
    required this.plateNumber,
    required this.driver,
    this.onDriverPressed,
    required this.deviceToken,
    required this.routeId,
    required this.otherDeviceToken,
    required this.driverId,
    required this.docId,
    required this.route,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {

  var requestData;
  int requestCount = 0;
  int passengerLast = 0;

  void getRequest() {
    FirebaseFirestore.instance
        .collection('routes')
        .doc(widget.docId)
        .collection('requests')
        .snapshots()
        .listen((snapshot) {


      snapshot.docs.forEach((doc) {
        var requestData = doc.data();
        var status = requestData['status'];

        // Status'u kontrol et
        if (status == 1) {
          setState(() {
            requestCount++;
          });
        }

        print(requestData['status']);
      });

      setState(() {
        passengerLast = int.parse((int.parse(widget.route.maxPassengerCount.toString()) -
            requestCount).toString());
      });
        });
  }

  @override
  void initState() {
    getRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }



  contentBox(context) {
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Stack(
      children: <Widget>[
        Container(
          height: 500,
          width: double.infinity,
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sürücü",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.driver,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Seriya nömresi",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.plateNumber,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Başlama tarixi",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.startDate,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bitmə vaxtı",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.endDate,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Max sərnişin sayı",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.route.maxPassengerCount.toString(),
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Adambaşı qiymət",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.route.pricePerPerson.toString(),
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ödeme şəkli",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Nağd",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color:  passengerLast <= 0 ? Colors.red : Colors.green)
                ),
                child: Center(
                  child: passengerLast <= 0 ? Text(
                    "Yer Qalmadı",
                    style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ) :
                Text(
                "Hələ " + passengerLast.toString() + " yer var",
                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              )
                ),
              ),
              SizedBox(
                height: 10,
              ),
              passengerLast <= 0 ?
              SizedBox.shrink() :
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                    onTap: widget.onDriverPressed,
                    child: CustomButton(
                      icon: Icons.drive_eta_rounded,
                      text: 'Sürücü', backgroundColor: AppColors.secondaryColor,)),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                    onTap: () async {

                      /*     await FirebaseHelper.sendNotification(
                          title: "Merhaba",
                          body: "Test",
                          token: widget.deviceToken);*/
                      await requestProvider.sendRequest(
                        RequestModel(
                          fromDeviceToken:
                          authProvider.currentUser!.deviceToken ?? "",
                          toDeviceToken: widget.otherDeviceToken,
                          fromUserId: authProvider.currentUser!.userId,
                          fromPicture: authProvider.currentUser!.profileUrl,
                          fromNameAndSurname: authProvider.currentUser!.name +
                              " " +
                              authProvider.currentUser!.familyName,
                          requestTime: Timestamp.fromDate(DateTime.now()),
                          driverId: widget.driverId,
                          docId: widget.docId,
                          fromDate: widget.route.startDate,
                          fromLocation: widget.route.from,
                          toLocation: widget.route.to,
                          status: 0,
                          toDate: widget.route.endDate,
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                    child: CustomButton(
                      icon: Icons.send_to_mobile,
                      text: 'Sorğu', backgroundColor: AppColors.secondaryColor,)),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CustomButton(
                      icon: Icons.cancel_sharp,
                      text: 'Ləğv et', backgroundColor: AppColors.secondaryColor,)),
              ),
        /*      Row(
                  children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onDriverPressed,
                    child: Text(
                      "Sürücü",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {

                 /*     await FirebaseHelper.sendNotification(
                          title: "Merhaba",
                          body: "Test",
                          token: widget.deviceToken);*/
                      await requestProvider.sendRequest(
                        RequestModel(
                          fromDeviceToken:
                              authProvider.currentUser!.deviceToken ?? "",
                          toDeviceToken: widget.otherDeviceToken,
                          fromUserId: authProvider.currentUser!.userId,
                          fromPicture: authProvider.currentUser!.profileUrl,
                          fromNameAndSurname: authProvider.currentUser!.name +
                              " " +
                              authProvider.currentUser!.familyName,
                          requestTime: Timestamp.fromDate(DateTime.now()),
                          driverId: widget.driverId,
                          docId: widget.docId,
                          fromDate: widget.route.startDate,
                          fromLocation: widget.route.from,
                          toLocation: widget.route.to,
                          status: 0,
                          toDate: widget.route.endDate,
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Sorğu",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Ləğv et",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ]),*/
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              widget.img,
              maxHeight: 45,
              maxWidth: 45,
            ),
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
          ),
        ),
      ],
    );
  }
}
