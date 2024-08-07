import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/providers/request_provider.dart';
import 'package:userapp/screens/landing_screen.dart';
import 'package:userapp/screens/setting_screen.dart';
import 'package:userapp/screens/travel_history_screen.dart';
import 'package:userapp/widgets/profile_menu.dart';
import 'package:userapp/widgets/profile_picture.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late OverlayEntry _overlayMailEntry;

  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.currentUserProfilePicture = authProvider.currentUser?.profileUrl;
      requestProvider.getRequestList(authProvider.currentUser!.userId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
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
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    ProfilePic(profilePicture: authProvider.currentUser!.profileUrl),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          authProvider.currentUser!.name.toString() + ' ' + authProvider.currentUser!.lastName.toString(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    ProfileMenu(
                      text: "Keçmiş Səyahətlərim",
                      icon: "assets/icons/User Icon.svg",
                      press: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TravelHistoryScreen(),
                          ),
                        )
                      },
                    ),
                    // ProfileMenu(
                    //   text: "Bildirişlər",
                    //   icon: "assets/icons/Bell.svg",
                    //   press: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => NotifyScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    ProfileMenu(
                      text: "Parametrlər",
                      icon: "assets/icons/Settings.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingScreen(),
                          ),
                        );
                      },
                    ),
                    // ProfileMenu(
                    //   text: "Hesabı Sil ",
                    //   icon: "assets/icons/Question mark.svg",
                    //   press: () async {
                    //     await showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return AlertDialog(
                    //           actions: [
                    //             TextButton(
                    //                 onPressed: () {
                    //                   Navigator.pop(context);
                    //                 },
                    //                 child: Text("Cancel")),
                    //             TextButton(
                    //                 onPressed: () async {
                    //                   var response = authProvider.deleteUser();
                    //
                    //                   if (response == true) {
                    //                     ScaffoldMessenger.of(context).showSnackBar(
                    //                       SnackBar(
                    //                         content: Text("Hesabınız uğurla silindi"),
                    //                       ),
                    //                     );
                    //                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                    //                   } else {
                    //                     // ScaffoldMessenger.of(context)
                    //                     //     .showSnackBar(
                    //                     //   SnackBar(
                    //                     //     content:
                    //                     //         Text("Nəsə xəta baş verdi"),
                    //                     //     backgroundColor: Colors.red,
                    //                     //   ),
                    //                     // );
                    //                     Navigator.pop(context);
                    //                   }
                    //                 },
                    //                 child: Text("Yes")),
                    //           ],
                    //           title: Text("Hesabı Sil"),
                    //           content: Text("Hesabınızı silmək istədiyinizdən əminsinizmi?"),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    ProfileMenu(
                      text: "Şərtlər və Qaydalar",
                      icon: "assets/icons/Question mark.svg",
                      press: () {
                        canLaunchUri("https://fayton.netlify.app/privacyandpolicy");
                      },
                    ),
                    ProfileMenu(
                      text: "Çıxış",
                      icon: "assets/icons/Log out.svg",
                      press: () async {
                        await auth.FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LandingScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> canLaunchUri(String urlString) async {
    final Uri url = Uri.parse(urlString);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // void _showOverlayMail(BuildContext context) async {
  //   _overlayMailEntry = OverlayEntry(
  //       builder: (context) => Dialog(
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  //               child: Material(
  //                 color: Colors.transparent,
  //                 child: Container(
  //                   height: MediaQuery.of(context).size.height * .20,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Align(
  //                         alignment: Alignment.topRight,
  //                         child: IconButton(
  //                             onPressed: () {},
  //                             icon: IconButton.outlined(
  //                                 onPressed: () {
  //                                   _overlayMailEntry.remove();
  //                                 },
  //                                 icon: Icon(Icons.cancel))),
  //                       ),
  //                       Container(
  //                           padding: EdgeInsets.all(8),
  //                           child: TextButton(
  //                             onPressed: () {
  //                               _sendEmail();
  //                             },
  //                             child: Text("faytondriver@gmail.com"),
  //                           )),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ));
  //   Overlay.of(context).insert(_overlayMailEntry);
  // }

  // _editProfile(BuildContext parentContext) async {
  //   return showDialog(
  //     context: parentContext,
  //     builder: (BuildContext context) {
  //       return SimpleDialog(
  //         //  title: const Text('Düzenle'),
  //         children: <Widget>[
  //           SimpleDialogOption(
  //               padding: const EdgeInsets.all(5),
  //               child: Container(
  //                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
  //                   child: const Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [Text('Parolunuzu Yeniləyin'), Icon(Icons.key)],
  //                   )),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return const EditProfileScreen(
  //                     editType: 'password',
  //                   );
  //                 }));
  //               }),
  //           SimpleDialogOption(
  //               padding: const EdgeInsets.all(5),
  //               child: Container(
  //                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
  //                   child: const Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [Text('Telefon nömrəsi'), Icon(Icons.phone_iphone_sharp)],
  //                   )),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return const EditProfileScreen(
  //                     editType: 'info',
  //                   );
  //                 }));
  //               }),
  //           SimpleDialogOption(
  //               padding: const EdgeInsets.all(5),
  //               child: Container(
  //                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
  //                   child: const Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [Text('Hesabı Sil'), Icon(Icons.clear)],
  //                   )),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return const EditProfileScreen(
  //                     editType: 'delete',
  //                   );
  //                 }));
  //               }),
  //           SimpleDialogOption(
  //             padding: const EdgeInsets.all(5),
  //             child: Container(
  //               decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(15)),
  //               padding: EdgeInsets.symmetric(vertical: 5),
  //               child: const Center(
  //                   child: Text(
  //                 "Yaxın",
  //                 style: TextStyle(color: Colors.white70),
  //               )),
  //             ),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  void _sendEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    // Mailto URL'sini oluştur
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: "faytondriver@gmail.com",
      query: encodeQueryParameters(<String, String>{'subject': 'Help Center', 'body': 'Desteğe ihtiyacım var'}),
    );

    // URL'yi başlat
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      // Eğer URL başlatılamazsa, bir hata mesajı göster
      print('Mail gönderme başarısız!');
    }
  }

  Widget infoChild(double width, IconData icon, data, {Color? iconColor}) => Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width / 10,
              ),
              Icon(
                icon,
                color: iconColor ?? const Color(0xFF26CBE6),
                size: 36.0,
              ),
              SizedBox(
                width: width / 20,
              ),
              Text(data)
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
