import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/screens/landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('663f64800022cb794a03')
        .setSelfSigned(status: true);
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new LandingScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: null /* add child content here */,
      ),
    );
  }
}
