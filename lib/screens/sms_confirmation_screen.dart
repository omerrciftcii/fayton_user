// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:userapp/common/app_colors.dart';
// import 'package:userapp/common/custom_button.dart';
// import 'package:userapp/common/waiting_indicator.dart';
// import 'package:userapp/providers/auth_provider.dart';
// import 'package:userapp/screens/custom_navigation_bar.dart';
// import 'package:userapp/screens/home_screen.dart';
// import 'package:userapp/services/auth_service.dart';

// class SmsConfirmationScreen extends StatefulWidget {
//   const SmsConfirmationScreen({Key? key}) : super(key: key);

//   @override
//   State<SmsConfirmationScreen> createState() => _SmsConfirmationScreenState();
// }

// class _SmsConfirmationScreenState extends State<SmsConfirmationScreen> {
//   @override
//   void initState() {
//     // SmsAutoFill().listenForCode;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // SmsAutoFill().unregisterListener();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var authPRovider = Provider.of<AuthProvider>(context);
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         bottomSheet: Padding(
//           padding: const EdgeInsets.only(bottom: 24.0, right: 24, left: 24),
//           child: InkWell(
//             onTap: () async {
//               await _onCodeSubmit(
//                   authPRovider, authPRovider.otpCode ?? "", context);
//             },
//             child: CustomButton(
//               text: "Davam et",
//               backgroundColor: AppColors.primaryColor,
//             ),
//           ),
//         ),
//         body: Center(
//           child: authPRovider.isLoading
//               ? const CustomWaitingIndicator()
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Doğrulama kodu nömrənizə göndərildi.",
//                       style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 50),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16.0, right: 16),
//                       child: PinFieldAutoFill(
//                           controller: authPRovider.smsCodeController,
//                           decoration: UnderlineDecoration(
//                             textStyle: const TextStyle(
//                                 fontSize: 20, color: Colors.black),
//                             colorBuilder: FixedColorBuilder(
//                                 Colors.black.withOpacity(0.3)),
//                           ), // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,

//                           onCodeChanged: (code) async {
//                             if (code!.length == 6) {
//                               authPRovider.otpCode = code;
//                               // await _onCodeSubmit(authPRovider, code, context);
//                               // FocusScope.of(context).requestFocus(FocusNode());
//                               // var verificationResponse = await authProvider
//                               //     .verifyPhoneNumber(code, widget.smsToken);

//                               // if (authProvider.failure == null) {
//                               //   if (verificationResponse?.authUserData.emailAddress ==
//                               //       null) {
//                               //     // Navigator.push(
//                               //     //   context,
//                               //     //   MaterialPageRoute(
//                               //     //     builder: (_) => CompleteRegistrationScreen(
//                               //     //         smsCode: code,
//                               //     //         verificationCode: verificationResponse!
//                               //     //                 .authUserData.verificationCode ??
//                               //     //             ''),
//                               //     //   ),
//                               //     // );
//                               //   } else {
//                               //     // Navigator.pushReplacement(
//                               //     //   //TODO This line will change
//                               //     //   context,
//                               //     //   MaterialPageRoute(
//                               //     //     builder: (_) => AlreadyRegisteredScreen(
//                               //     //         phoneNumber: verificationResponse!
//                               //     //                 .authUserData.mobilePhone ??
//                               //     //             ''),
//                               //     //   ),
//                               //     // );
//                               //   }
//                               // } else {
//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(
//                               //       content: Text("Ters gitti"),
//                               //     ),
//                               //   );
//                               // }
//                             }
//                           } //code length, default 6
//                           ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Future<void> _onCodeSubmit(
//       AuthProvider authPRovider, String code, BuildContext context) async {
//     try {
//       await authPRovider.verifyOTP(
//           userId: authPRovider.token!.userId, otp: code);
//      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Sms Təsdiqləndi"),
//         ),
//     
//  );
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//               CustomNavigationBar(currentUser: authPRovider.currentUser),
//         ),
//         (route) => false,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     }
//   }
// }
