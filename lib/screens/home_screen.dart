import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_date_picker.dart';
import 'package:flutter_material_pickers/helpers/show_selection_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:userapp/common/custom_button.dart';
import 'package:userapp/common/custom_text_field.dart';
import 'package:userapp/models/state_model.dart';
import 'package:userapp/providers/route_provider.dart';
import 'package:userapp/screens/filter_screen.dart';
import 'package:userapp/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAllVisit = false;

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Kullanıcı daha önce izni reddetmiş, izin iste
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      openAppSettings();
    } else {
      // Kullanıcı izin verdi
    }
  }

  @override
  void initState() {
    checkLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var routeProvider = Provider.of<RouteProvider>(context, listen: true);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff502eb2), Colors.white],
            stops: [0.25, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
              child: CustomTextField(
                controller: TextEditingController(text: routeProvider.selectedFromRoute?.title ?? ""),
                hintText: "Gediş şəhərini seçin",
                readOnly: true,
                style: GoogleFonts.poppins(color: Colors.white38),
                prefixIcon: FaIcon(
                  FontAwesomeIcons.route,
                  color: Colors.white38,
                ),
                onTap: () {
                  showMaterialSelectionPicker<StateModel?>(
                    context: context,
                    cancelText: "Ləğv et",
                    confirmText: "Təsdiqlə",
                    title: 'Gediş şəhərini seçin',
                    items: StateModel.townModels.followedBy(StateModel.villageModels).followedBy(StateModel.subwayStationModels).toList(),
                    transformer: (item) => (item?.title),
                    iconizer: (item) => item?.icon,
                    selectedItem: routeProvider.selectedFromRoute,
                    onChanged: (value) => setState(() => routeProvider.selectedFromRoute = value),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
              child: CustomTextField(
                style: GoogleFonts.poppins(color: Colors.white38),
                controller: TextEditingController(text: routeProvider.selectedToRoute?.title ?? ""),
                hintText: "Gedəcəyiniz şəhəri seçin",
                readOnly: true,
                prefixIcon: FaIcon(
                  FontAwesomeIcons.route,
                  color: Colors.white38,
                ),
                onTap: () {
                  showMaterialSelectionPicker<StateModel?>(
                    context: context,
                    cancelText: "Ləğv et",
                    confirmText: "Təsdiqlə",
                    items: StateModel.townModels.followedBy(StateModel.villageModels).followedBy(StateModel.subwayStationModels).toList(),
                    transformer: (item) => (item?.title),
                    iconizer: (item) => item?.icon,
                    selectedItem: routeProvider.selectedToRoute,
                    onChanged: (value) => setState(() => routeProvider.selectedToRoute = value),
                  );
                },
              ),
            ),
            !isAllVisit
                ? Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
                    child: CustomTextField(
                      controller: TextEditingController(),
                      hintText: routeProvider.selectedStartDate == null
                          ? "Başlama tarixi"
                          : Utils.getFormatedDate(routeProvider.selectedStartDate.toString()),
                      readOnly: true,
                      prefixIcon: FaIcon(
                        FontAwesomeIcons.calendarCheck,
                        color: Colors.white38,
                      ),
                      onTap: () async {
                        await showMaterialDatePicker(
                            title: "Vaxtı seçin",
                            cancelText: "Ləğv et",
                            confirmText: "Təsdiqlə",
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            context: context,
                            selectedDate: routeProvider.selectedStartDate ?? DateTime.now(),
                            onChanged: (value) => routeProvider.selectedStartDate = value,
                            onConfirmed: () async {});
                      },
                    ),
                  )
                : SizedBox(),
            /**      CheckboxListTile(
              contentPadding:
              const EdgeInsets.only(right: 48, left: 48),
              title: Text("Bütün səfərlərə baxın", style: GoogleFonts.poppins(color: Colors.white70),),
              onChanged: (value) {
                setState(() {
                  isAllVisit = value ?? false;
                });
              },
              activeColor: AppColors.primaryColor,
              value: isAllVisit,
              controlAffinity: ListTileControlAffinity.leading,
            ),*/
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48.0, right: 48),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FilterScreen(
                        endDate: routeProvider.selectedEndDate,
                        from: routeProvider.selectedFromRoute?.title ?? "TR",
                        startDate: routeProvider.selectedStartDate,
                        to: routeProvider.selectedToRoute?.title ?? "TR",
                        isAllVisit: isAllVisit,
                      ),
                    ),
                  );
                },
                child: CustomButton(
                  text: "Axtar",
                  backgroundColor: Color(0xff502eb2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
