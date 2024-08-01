import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:userapp/providers/auth_provider.dart';

class ProfilePic extends StatelessWidget {
  final String profilePicture;
  ProfilePic({
    Key? key,
    required this.profilePicture,
  }) : super(key: key);
  final ImagePicker _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: profilePicture != ""
                ? CachedNetworkImageProvider(profilePicture)
                : CachedNetworkImageProvider(
                    "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                  var selectedImage =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (selectedImage != null) {
                    authProvider.currentUserProfilePicture =
                        await authProvider.uploadProfilePicture(
                      File(selectedImage.path),
                    );
                    await authProvider
                        .refreshUser(authProvider.currentUser!.userId);
                  }
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
