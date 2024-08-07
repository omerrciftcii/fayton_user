import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/models/request_model.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/providers/request_provider.dart';
import 'package:userapp/screens/driver_profile_screen.dart';
import 'package:userapp/widgets/profile_menu.dart';

class TravelHistoryScreen extends StatefulWidget {
  const TravelHistoryScreen({super.key});

  @override
  State<TravelHistoryScreen> createState() => _TravelHistoryScreenState();
}

List<RequestModel> _requestList = [];

class _TravelHistoryScreenState extends State<TravelHistoryScreen> {
  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.currentUserProfilePicture = authProvider.currentUser?.profileUrl;
      requestProvider.getRequestList(authProvider.currentUser!.userId);
    });
    setState(() {
      _requestList = requestProvider.requestList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Keçmiş səyahətlərim",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: _requestList.isEmpty
          ? Center(
              child: Text(
              "Səyahət tapılmadı",
              style: TextStyle(fontSize: 18),
            ))
          : ListView.builder(
              itemCount: _requestList.length,
              itemBuilder: (context, index) {
                return ProfileMenu(
                  text: _requestList[index].fromLocation + " - " + _requestList[index].toLocation,
                  icon: "assets/icons/Location point.svg",
                  fromHistory: true,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DriverProfileScreen(driverId: _requestList[index].driverId),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
