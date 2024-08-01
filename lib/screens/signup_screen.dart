// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/common/app_colors.dart';
import 'package:userapp/common/app_fonts.dart';
import 'package:userapp/common/custom_button.dart';
import 'package:userapp/common/custom_text_field.dart';
import 'package:userapp/common/waiting_indicator.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/screens/custom_navigation_bar.dart';
import 'package:userapp/screens/sms_confirmation_screen.dart';
import 'package:userapp/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String numberInitialCode = "994";

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(selectedDate!.toLocal().millisecondsSinceEpoch);
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var authPRovider = Provider.of<AuthProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff502eb2), Colors.white],
              stops: [0.25, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: double.infinity,
          child: SingleChildScrollView(
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
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 36, top: 72.0),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  children: [
                                    TextSpan(text: "Qeydiyyatdan Keçin"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 8.0,
                    ),
                    CustomTextField(
                      controller: authPRovider.emailController,
                      hintText: "E-poçt",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "E-poçt ünvanı doğru deyil";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                      },
                      controller: authPRovider.nameController,
                      hintText: "Ad",
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                      },
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      controller: authPRovider.familyNameController,
                      hintText: "Soyadı",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 60.0,
                        right: 36,
                        top: 24,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                        ),
                        height: 48,
                        child: InternationalPhoneNumberInput(
                          textStyle: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              numberInitialCode = number.isoCode.toString();
                            });
                            print(number.phoneNumber.toString() +
                                " onInputChanged");
                            authPRovider.selectedPhoneCode = number.dialCode;
                          },

                          onInputValidated: (bool value) {
                            print(value);
                          },

                          textAlign: TextAlign.start,
                          countries: ["AZ", "TR"],
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                          initialValue: PhoneNumber(
                            isoCode: numberInitialCode,
                          ),

                          textFieldController: authPRovider.phoneController,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          // inputBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(30.0),
                          //   borderSide: BorderSide(
                          //     width: 0,
                          //     color: Colors.transparent,
                          //   ),
                          // ),
                          // inputDecoration: InputDecoration(
                          //   hintText: "Telefon nömrəsi",
                          //   hintStyle: GoogleFonts.roboto(
                          //       color: Colors.black54, fontSize: 16),
                          //   contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          //   border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(30.0),
                          //     borderSide: BorderSide(
                          //       width: 0,
                          //       color: Colors.transparent,
                          //     ),
                          //   ),
                          // ),
                          validator: null,
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),
                    ),
                    // TextFormField(
                    //   controller: authPRovider.phoneController,
                    //   autocorrect: false,
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.phone,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'This field is required';
                    //     }
                    //     return null;
                    //   },
                    //   decoration: InputDecoration(
                    //       enabledBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
                    //       ),
                    //       focusedBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(color: AppColors.primaryColor),
                    //       ),
                    //       hintText: 'Telefon nömrəsi',
                    //       hintStyle: GoogleFonts.poppins(color: Colors.white70),
                    //       prefixIcon: Container(
                    //           width: 70,
                    //           child: Center(child: Text("+994", style: AppFonts.generalTextTheme(Colors.black),)))
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 0),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white70,
                        ),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: TextButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                selectedDate == null
                                    ? "Doğum Tarixinizi Seçin"
                                    : _formatDate(selectedDate!),
                                style:
                                    GoogleFonts.poppins(color: Colors.white70),
                              )),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 0),
                    CustomTextField(
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      isSecureText: !authPRovider.isPasswordVisible,
                      suffixIcon: authPRovider.isPasswordVisible
                          ? GestureDetector(
                              onTap: () {
                                authPRovider.isPasswordVisible =
                                    !authPRovider.isPasswordVisible;
                              },
                              child: Icon(Icons.visibility))
                          : GestureDetector(
                              onTap: () {
                                authPRovider.isPasswordVisible =
                                    !authPRovider.isPasswordVisible;
                              },
                              child: Icon(Icons.visibility_off)),
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                      },
                      controller: authPRovider.passwordController,
                      hintText: "Şifrə",
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    CustomTextField(
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      isSecureText: !authPRovider.isPasswordVisible,
                      suffixIcon: authPRovider.isPasswordVisible
                          ? GestureDetector(
                              onTap: () {
                                authPRovider.isPasswordVisible =
                                    !authPRovider.isPasswordVisible;
                              },
                              child: Icon(Icons.visibility))
                          : GestureDetector(
                              onTap: () {
                                authPRovider.isPasswordVisible =
                                    !authPRovider.isPasswordVisible;
                              },
                              child: Icon(Icons.visibility_off)),
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        if (authPRovider.passwordController.text !=
                            authPRovider.passwordAgainController.text) {
                          return "Password should match";
                        }
                      },
                      controller: authPRovider.passwordAgainController,
                      hintText: "Şifrəni təsdiqləyin",
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        "*Şifrə ən az 6 xanali olmalıdır",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    // CustomTextField(
                    //   validator: (value) {
                    //     if (value == null) {
                    //       return "This field is required";
                    //     }
                    //   },
                    //   controller: authPRovider.phoneController,
                    //   labelIcon: Icon(
                    //     Icons.phone_android_outlined,
                    //     color: Colors.white30,
                    //   ),
                    //   hintText: "Phone Number",
                    //   label: "Phone Number",
                    // ),
                    // const SizedBox(
                    //   height: 18,
                    // ),
                    CheckboxListTile(
                      contentPadding:
                          const EdgeInsets.only(right: 48, left: 48),
                      title: InkWell(
                          onTap: () {
                            canLaunchUrl(
                                "https://fayton.netlify.app/privacyandpolicy");
                          },
                          child: Text(
                            "Mən Şərtlər və Məxfilik ilə razıyam",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              decoration: TextDecoration
                                  .underline, // Add this line to underline the text
                            ),
                          )),
                      onChanged: (value) {
                        authPRovider.isTermsAccepted = value ?? false;
                      },
                      activeColor: AppColors.primaryColor,
                      value: authPRovider.isTermsAccepted,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate() &&
                            authPRovider.isTermsAccepted &&
                            selectedDate != null) {
                          var credential = await authPRovider.signupWithEmail();
                          if (credential.user != null) {
                            await authPRovider.setToken(
                                userId: credential.user!.uid);
                            var response = await authPRovider.addUserToDb();

                            authPRovider.currentUser =
                                await AuthService.getCurrentUser(
                                    response.userId);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomNavigationBar(
                                    currentUser: authPRovider.currentUser),
                              ),
                              (route) => false,
                            );
                          }
                        }
                      },
                      child: authPRovider.isLoading
                          ? Center(
                              child: CustomWaitingIndicator(),
                            )
                          : CustomButton(
                              text: "Qeyd",
                              backgroundColor: AppColors.primaryColor,
                            ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (_formKey.currentState!.validate() &&
                    //         authPRovider.isTermsAccepted &&
                    //         selectedDate != null) {
                    //       authPRovider.sendSms(context).then((value) async {
                    //         Navigator.pushReplacement(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     SmsConfirmationScreen()));
                    //       });
                    //     }
                    //   },
                    //   child: authPRovider.isLoading
                    //       ? Center(
                    //           child: CustomWaitingIndicator(),
                    //         )
                    //       : CustomButton(
                    //           text: "Qeyd",
                    //           backgroundColor: AppColors.primaryColor,
                    //         ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  canLaunchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
