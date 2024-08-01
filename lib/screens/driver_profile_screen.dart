import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:userapp/common/waiting_indicator.dart';
import 'package:userapp/models/driver_profile_model.dart';
import 'package:userapp/models/request_model.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/providers/request_provider.dart';
import 'package:userapp/screens/message_detail_screen.dart';
import 'package:userapp/services/auth_service.dart';
import 'package:userapp/services/firebase_helper.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:userapp/services/request_service.dart';
import 'package:userapp/widgets/profile_picture.dart';

class DriverProfileScreen extends StatefulWidget {
  final String driverId;
  const DriverProfileScreen({super.key, required this.driverId});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int counter = 0;
  User? otherUser;
  @override
  void initState() {
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      requestProvider.getDriverProfileFuture =
          RequestService.getDriver(widget.driverId);
    });

    super.initState();
  }

  String formatDate(timestamp) {
    var now = DateTime.now();
    final Timestamp firebaseTimestamp = Timestamp.fromMillisecondsSinceEpoch(timestamp);
    var date = firebaseTimestamp.toDate();
    var difference = now.difference(date);

    if (difference.inDays > 0) {
      return DateFormat.yMMM().format(date);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Şimdi';
    }
  }

  @override
  Widget build(BuildContext context) {
    var requestProvider = Provider.of<RequestProvider>(context);
    return Scaffold(
        body: FutureBuilder(
      future: requestProvider.getDriverProfileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CustomWaitingIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError == false) {
          return Container(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff502eb2), Colors.white],
                      stops: [0.25, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 140, 119, 204),
                                    Colors.deepPurpleAccent
                                  ],
                                ),
                              ),
                              child: Column(children: [
                                SizedBox(
                                  height: 110.0,
                                ),
                                CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage: CachedNetworkImageProvider(
                                      snapshot.data?.facePhotoUrl ??
                                          "https://www.pngkit.com/png/detail/176-1768859_myeong-hwan-yoo-unknown-profile-picture-png.png"),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                    snapshot.data!.name +
                                        " " +
                                        snapshot.data!.surname,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    )),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  snapshot.data!.plateNumber,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                )
                              ]),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              color: Colors.grey[200],
                              child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Text(
                                          "📌Avtomobilə minməzdən əvvəl həmişə sərnişinin adını soruşun və təsdiqləyin.",
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal, fontSize: 14),
                                        ),
                                      ),SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot.data?.rating != null ? "★ " + snapshot.data!.rating.toString() : "★ 0.0",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.bold, fontSize: 18),
                                                  ),
                                                  Text("Rating"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 25,
                                            color: Colors.grey,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                                              child: Column(
                                                children: [
                                                  FittedBox(
                                                    child: Text(
                                                      formatDate(snapshot.data!.createdAt!.millisecondsSinceEpoch),
                                                      style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.bold, fontSize: 18),
                                                    ),
                                                  ),
                                                  Text("Member since", style: TextStyle(fontSize: 12),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                Card(
                                  margin: EdgeInsets.fromLTRB(
                                      0.0, 45.0, 0.0, 0.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 110),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/car.png',
                                          height: 100,
                                        ),
                                        Text(
                                          snapshot.data!.vehicleModel.toString(),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                )


                                /**      Card(
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 45.0, 0.0, 0.0),
                                          child: Container(
                                              width: 310.0,
                                              height: 200.0,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Information",
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[300],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [],
                                                    ),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Icon(
                                                          Icons.auto_awesome,
                                                          color: Colors
                                                              .yellowAccent[400],
                                                          size: 35,
                                                        ),
                                                        SizedBox(
                                                          width: 20.0,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Qiymətləndirmə",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Row(
                                                                children: [
                                                                  RatingBar.builder(
                                                                    itemSize: 36,
                                                                    initialRating: double
                                                                        .parse(snapshot
                                                                                .data
                                                                                ?.rating ??
                                                                            "0"),
                                                                    minRating: 1,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    allowHalfRating:
                                                                        true,
                                                                    itemCount: 5,
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            Icon(
                                                                      Icons.star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    onRatingUpdate:
                                                                        (rating) async {
                                                                      await RequestService.ratingCalculation(
                                                                          snapshot
                                                                              .data!
                                                                              .userId,
                                                                          rating);
                                                                      print(rating);
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text("3/4")
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                  ],
                                                ),
                                              ))),*/
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.45,
                          left: 20.0,
                          right: 20.0,
                          child: Card(
                              child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(children: [
                                        InkWell(
                                          onTap: () async {
                                            try {
                                              await FirebaseChatCore.instance
                                                  .createUserInFirestore(
                                                types.User(
                                                  id: snapshot.data!.userId,
                                                  imageUrl: snapshot
                                                      .data!.facePhotoUrl,
                                                  createdAt: 1,
                                                  firstName:
                                                      snapshot.data!.name,
                                                  lastName:
                                                      snapshot.data!.surname,
                                                ),
                                              );
                                              var users = await FirebaseChatCore
                                                  .instance
                                                  .users();
                                              users.first.then((value) {
                                                print(value);
                                              });
                                              final room =
                                                  await FirebaseChatCore
                                                      .instance
                                                      .createRoom(
                                                types.User(
                                                  id: snapshot.data!.userId,
                                                  imageUrl: snapshot
                                                      .data!.facePhotoUrl,
                                                  createdAt: 1,
                                                  firstName:
                                                      snapshot.data!.name,
                                                  lastName:
                                                      snapshot.data!.surname,
                                                ),
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ChatPage(room: room),
                                                ),
                                              );
                                            } catch (e) {
                                              throw Exception(e);
                                            }
                                          },
                                          child: Icon(
                                            Icons.message,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                      ]),
                                    ),
                                    Text("Mesaj")
                                  ],
                                ),
                              ],
                            ),
                          )))
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
      },
    ));
  }
}
