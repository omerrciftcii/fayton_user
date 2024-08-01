import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:userapp/common/app_colors.dart';
import 'package:userapp/common/custom_button.dart';
import 'package:userapp/common/waiting_indicator.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/providers/filter_provider.dart';
import 'package:userapp/providers/route_provider.dart';
import 'package:userapp/screens/driver_profile_screen.dart';
import 'package:userapp/services/filter_service.dart';
import 'package:userapp/utils.dart';
import 'package:userapp/widgets/custom_dialog_box.dart';

class FilterScreen extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String from;
  final String to;
  final bool isAllVisit;
  FilterScreen(
      {super.key,
      required this.endDate,
      required this.from,
      required this.startDate,
      required this.isAllVisit,
      required this.to});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    var routeProvider = Provider.of<RouteProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var filterProvider = Provider.of<FilterProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      filterProvider.filterRoutesFuture =
          FilterService.filterRoutes(widget.startDate, widget.from, widget.to, widget.isAllVisit);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filterProvider = Provider.of<FilterProvider>(context);
    return Scaffold(
      body: FutureBuilder(
          future: filterProvider.filterRoutesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CustomWaitingIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null &&
                snapshot.hasData &&
                snapshot.hasError == false &&
                snapshot.data!.isNotEmpty) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff502eb2), Colors.white],
                    stops: [0.25, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Marşrut siyahısı",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data![index].isComplete) {
                            return SizedBox.shrink(); // Boş bir widget döndürerek gizle
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  snapshot.data![index].profile.facePhotoUrl ??
                                      ""),
                            ),
                            onTap: () async {
                              await await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomDialogBox(
                                      title: snapshot.data![index].from +
                                          ' - ' +
                                          snapshot.data![index].to,
                                      startDate: Utils.getFormatedDate(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                                  snapshot
                                                      .data![index]
                                                      .startDate
                                                      .microsecondsSinceEpoch)
                                              .toString()),
                                      endDate: Utils.getFormatedDate(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                                  snapshot.data![index].endDate
                                                      .microsecondsSinceEpoch)
                                              .toString()),
                                      text: "text",
                                      img: snapshot.data![index].profile
                                              .facePhotoUrl ??
                                          "",
                                      plateNumber: snapshot
                                          .data![index].profile.plateNumber,
                                      driver: snapshot
                                              .data![index].profile.name +
                                          " " +
                                          snapshot.data![index].profile.surname,
                                      routeId: snapshot.data![index].docId,
                                      onDriverPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DriverProfileScreen(
                                                driverId: snapshot
                                                    .data![index].driverId),
                                          ),
                                        );
                                      },
                                      deviceToken: snapshot
                                          .data![index].profile.deviceToken,
                                      route: snapshot.data![index],
                                      otherDeviceToken: snapshot
                                          .data![index].profile.deviceToken,
                                      driverId:
                                          snapshot.data![index].profile.userId,
                                      docId: snapshot.data![index].docId,
                                    );
                                  });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => DriverProfileScreen(
                              //         driverProfile: snapshot.data![index].profile),
                              //   ),
                              // );
                            },
                            title: Text(
                              snapshot.data![index].from +
                                  "-" +
                                  snapshot.data![index].to,
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            subtitle: Text(
                              Utils.getFormatedDate(
                                  DateTime.fromMicrosecondsSinceEpoch(snapshot
                                          .data![index]
                                          .startDate
                                          .microsecondsSinceEpoch)
                                      .toString()),
                              style: GoogleFonts.poppins(color: Colors.white54),
                            ),
                            trailing: Icon(
                              Icons.route,
                              color: Colors.white,
                            ),
                          );
                        }),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustomButton(text: 'Geri', backgroundColor: AppColors.primaryColor,)),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null &&
                snapshot.hasData &&
                snapshot.hasError == false &&
                snapshot.data!.isEmpty) {
              return Center(
                child: Text("Gediş tapılmadı"),
              );
            } else {
              return Center(
                child: Text("An error occured"),
              );
            }
          }),
    );
  }
}
