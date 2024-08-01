import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/models/request_model.dart';
import 'package:userapp/providers/request_provider.dart';
import 'package:userapp/screens/driver_profile_screen.dart';
import 'package:userapp/widgets/profile_menu.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<SettingScreen> {
  @override
  void initState() {
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);

    super.initState();
  }

  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    var requestProvider = Provider.of<RequestProvider>(context);
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bildiriş', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Switch(
                value: isToggled,
                onChanged: (value) {
                  setState(() {
                    isToggled = value;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
