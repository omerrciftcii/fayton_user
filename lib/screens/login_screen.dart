import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:userapp/common/assets.dart';
import 'package:userapp/common/custom_button.dart';
import 'package:userapp/common/custom_text_field.dart';
import 'package:userapp/common/waiting_indicator.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/screens/landing_screen.dart';
import 'package:userapp/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authProvier = Provider.of<AuthProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff502eb2), Colors.white],
                stops: [0.25, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.only(right: 48.0, left: 48),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, top: 72.0),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  children: [
                                    TextSpan(text: "Xoş gəldiniz"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80.0),
                          child: Image.asset(
                            AssetPaths.logo,
                            width: 160,
                            height: 160,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    /*      SizedBox(
                      height: MediaQuery.of(context).size.height / 8.0,
                    ),*/
                    CustomTextField(
                      controller: authProvier.loginEmailController,
                      hintText: "E-poçt",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Bu sahə tələb olunur";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "E-poçt ünvanı doğru deyil";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Column(
                      children: [
                        CustomTextField(
                          controller: authProvier.loginPasswordController,
                          hintText: "Şifrə",
                          isSecureText: true,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.only(right: 60.0, top: 8),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Text(
                        //         "Forgot password?",
                        //         textAlign: TextAlign.end,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: authProvier.isLoading
                          ? Center(
                              child: CustomWaitingIndicator(),
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    var response =
                                        await authProvier.signInWithEmail();

                                    if (response.user != null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LandingScreen(),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e
                                              .toString()
                                              .replaceAll("Exception:", ""),
                                        ),
                                      ),
                                    );
                                  }

                                  print("object");
                                }
                              },
                              child: CustomButton(
                                text: "Daxil ol",
                                backgroundColor: Colors.green,
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Sizin hesabınız yoxdur?",
                            style: GoogleFonts.poppins(color: Colors.black54),
                          ),
                          TextSpan(
                              text: " Qeydiyyatdan keç",
                              style:
                                  GoogleFonts.poppins(color: Colors.black54)),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
