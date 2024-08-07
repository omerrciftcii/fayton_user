import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/providers/request_provider.dart';
import 'package:userapp/screens/edit_profile_screen.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Parametrlər",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Bildirişlər',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
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
              SizedBox(height: 22),
              SimpleDialogOption(
                  padding: EdgeInsets.zero,
                  child: Container(
                      child: const Row(
                    children: [
                      Icon(Icons.lock_outline_rounded),
                      SizedBox(width: 12),
                      Text(
                        'Parolunuzu Yeniləyin',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const EditProfileScreen(
                        editType: 'password',
                      );
                    }));
                  }),
              SizedBox(height: 32),
              SimpleDialogOption(
                  padding: EdgeInsets.zero,
                  child: Container(
                      child: const Row(
                    children: [
                      Icon(Icons.phone_outlined),
                      SizedBox(width: 12),
                      Text(
                        'Telefon nömrəsi',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const EditProfileScreen(
                        editType: 'info',
                      );
                    }));
                  }),
              SizedBox(height: 32),
              SimpleDialogOption(
                  padding: EdgeInsets.zero,
                  child: Container(
                      child: const Row(
                    children: [
                      Icon(Icons.clear, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Hesabı Sil',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const EditProfileScreen(
                        editType: 'delete',
                      );
                    }));
                  }),
            ],
          ),
        ));
  }
}
