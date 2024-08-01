import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/provider.dart';
import 'package:userapp/common/app_colors.dart';
import 'package:userapp/common/app_fonts.dart';
import 'package:userapp/common/assets.dart';
import 'package:userapp/common/custom_button.dart';
import 'package:userapp/common/waiting_indicator.dart';
import 'package:userapp/models/profile_model.dart';
import 'package:userapp/providers/auth_provider.dart';

class VerificationWaitingScreen extends StatefulWidget {
  const VerificationWaitingScreen({super.key, required this.currentUser});
  final ProfileModel? currentUser;
  @override
  State<VerificationWaitingScreen> createState() =>
      _VerificationWaitingScreenState();
}

class _VerificationWaitingScreenState extends State<VerificationWaitingScreen> {
  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.currentUser = widget.currentUser;
    });
    super.initState();
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: authProvider.currentUser == null
          ? Center(
              child: CustomWaitingIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(AssetPaths.logo),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 48),
                    child: Text(
                      'Dear ${authProvider.currentUser!.name} You are on the waiting list, we will be getting to know you after verification completed.',
                      style: AppFonts.generalTextTheme(Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            var result = await OpenMailApp.openMailApp();

                            // If no mail apps found, show error
                            if (!result.didOpen && !result.canOpen) {
                              showNoMailAppsDialog(
                                context,
                              );

                              // iOS: if multiple mail apps found, show dialog to select.
                              // There is no native intent/default app system in iOS so
                              // you have to do it yourself.
                            } else if (!result.didOpen && result.canOpen) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return MailAppPickerDialog(
                                    mailApps: result.options,
                                    title: "Plaese write your message",
                                    emailContent: EmailContent(
                                        to: ["shamkhal@gmail.com"],
                                        body: "Please send your message"),
                                        

                                  );
                                },
                              );
                            }
                            // showModalBottomSheet(
                            //     context: context,
                            //     builder: (context) {
                            //       return Column(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Container(
                            //             height: 120,
                            //             width: double.infinity,
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(
                            //                   right: 48.0, left: 48, top: 12),
                            //               child: CustomTextField(
                            //                   controller: authProvider
                            //                       .supportMailController,
                            //                   maxLine: 5,
                            //                   hintText: 'Support Message'),
                            //             ),
                            //           ),
                            //           Padding(
                            //             padding: const EdgeInsets.only(
                            //                 right: 48.0,
                            //                 left: 48,
                            //                 top: 12,
                            //                 bottom: 48),
                            //             child: CustomButton(
                            //               text: "Send",
                            //               backgroundColor:
                            //                   AppColors.primaryColor,
                            //             ),
                            //           )
                            //         ],
                            //       );
                            //     });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 48.0, right: 48),
                            child: CustomButton(
                              text: 'Send email to us',
                              backgroundColor: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
