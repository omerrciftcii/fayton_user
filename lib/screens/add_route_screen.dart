// import 'package:flutter/material.dart';
// import 'package:flutter_material_pickers/helpers/show_date_picker.dart';
// import 'package:flutter_material_pickers/helpers/show_radio_picker.dart';
// import 'package:flutter_material_pickers/helpers/show_time_picker.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:userapp/common/app_colors.dart';
// import 'package:userapp/common/custom_button.dart';
// import 'package:userapp/common/custom_text_field.dart';
// import 'package:userapp/common/waiting_indicator.dart';
// import 'package:userapp/models/state_model.dart';
// import 'package:userapp/providers/auth_provider.dart';
// import 'package:userapp/providers/navbar_provider.dart';
// import 'package:userapp/providers/route_provider.dart';
// import 'package:userapp/utils.dart';

// class AddRoutesScreen extends StatefulWidget {
//   const AddRoutesScreen({super.key});

//   @override
//   State<AddRoutesScreen> createState() => _AddRoutesScreenState();
// }

// class _AddRoutesScreenState extends State<AddRoutesScreen> {
//   @override
//   void dispose() {
//     var routeProvider = Provider.of<RouteProvider>(context, listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       routeProvider.maxTravellerController.dispose();
//       routeProvider.estimatedTravelDuration = 0;
//       routeProvider.selectedEndDate = null;
//       routeProvider.selectedStartDate = null;
//       routeProvider.selectedFromRoute = null;
//       routeProvider.selectedToRoute = null;
//     });

//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var routeProvider = Provider.of<RouteProvider>(context);
//     var authProvider = Provider.of<AuthProvider>(context);
//     var navigationProvider = Provider.of<NavbarProvider>(context);

//     return Scaffold(
//       body: Form(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
//             child: CustomTextField(
//               controller: TextEditingController(
//                   text: routeProvider.selectedFromRoute?.name ?? ""),
//               hintText: "Please select from city",
//               readOnly: true,
//               prefixIcon: FaIcon(
//                 FontAwesomeIcons.city,
//                 color: AppColors.primaryColor,
//               ),
//               onTap: () {
//                 showMaterialRadioPicker<StateModel>(
//                   context: context,
//                   title: 'From',
//                   items: StateModel.getTowns(),
//                   selectedItem: routeProvider.selectedFromRoute,
//                   onChanged: (value) =>
//                       setState(() => routeProvider.selectedFromRoute = value),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
//             child: CustomTextField(
//               controller: TextEditingController(
//                   text: routeProvider.selectedToRoute?.name ?? ""),
//               hintText: "Please select to city",
//               readOnly: true,
//               prefixIcon: FaIcon(
//                 FontAwesomeIcons.city,
//                 color: AppColors.primaryColor,
//               ),
//               onTap: () {
//                 showMaterialRadioPicker<StateModel>(
//                   context: context,
//                   title: 'To',
//                   items: StateModel.getTowns(),
//                   selectedItem: routeProvider.selectedToRoute,
//                   onChanged: (value) =>
//                       setState(() => routeProvider.selectedToRoute = value),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
//             child: CustomTextField(
//               controller: routeProvider.estimatedDuration,
//               hintText: "Estimated travel duration in minute",
//               readOnly: false,
//               prefixIcon: FaIcon(FontAwesomeIcons.clock),
//               inputType: TextInputType.number,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
//             child: CustomTextField(
//               controller: routeProvider.maxTravellerController,
//               hintText: "Maximum traveller count",
//               readOnly: false,
//               inputType: TextInputType.number,
//               prefixIcon: FaIcon(FontAwesomeIcons.clock),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
//             child: CustomTextField(
//               controller: TextEditingController(),
//               hintText: routeProvider.selectedStartDate == null
//                   ? "Start Date"
//                   : Utils.getFormatedDate(
//                       routeProvider.selectedStartDate.toString()),
//               readOnly: true,
//               prefixIcon: FaIcon(FontAwesomeIcons.calendar),
//               onTap: () async {
//                 await showMaterialDatePicker(
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(Duration(days: 365)),
//                     context: context,
//                     selectedDate:
//                         routeProvider.selectedStartDate ?? DateTime.now(),
//                     onChanged: (value) =>
//                         routeProvider.selectedStartDate = value,
//                     onConfirmed: () async {
//                       await showMaterialTimePicker(
//                           context: context,
//                           selectedTime:
//                               routeProvider.startTime ?? TimeOfDay.now(),
//                           onChanged: (value) => routeProvider.startTime = value,
//                           onConfirmed: () {
//                             routeProvider.selectedStartDate =
//                                 Utils.mergeDateTime(
//                                     routeProvider.selectedStartDate,
//                                     routeProvider.startTime);
//                           });
//                     });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 48.0, right: 48, bottom: 24),
//             child: CustomTextField(
//               controller: TextEditingController(),
//               hintText: routeProvider.selectedEndDate == null
//                   ? "End Date"
//                   : Utils.getFormatedDate(
//                       routeProvider.selectedEndDate.toString()),
//               readOnly: true,
//               prefixIcon: FaIcon(FontAwesomeIcons.calendar),
//               onTap: () async {
//                 await showMaterialDatePicker(
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(Duration(days: 365)),
//                     context: context,
//                     selectedDate:
//                         routeProvider.selectedEndDate ?? DateTime.now(),
//                     onChanged: (value) => routeProvider.selectedEndDate = value,
//                     onConfirmed: () async {
//                       await showMaterialTimePicker(
//                           context: context,
//                           selectedTime:
//                               routeProvider.endTime ?? TimeOfDay.now(),
//                           onChanged: (value) => routeProvider.endTime = value,
//                           onConfirmed: () {
//                             routeProvider.selectedEndDate = Utils.mergeDateTime(
//                                 routeProvider.selectedEndDate,
//                                 routeProvider.endTime);
//                           });
//                     });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 48.0, right: 48, top: 12),
//             child: routeProvider.isLoading
//                 ? Center(
//                     child: const CustomWaitingIndicator(),
//                   )
//                 : GestureDetector(
//                     onTap: () async {
//                       var response = await routeProvider.createRoute(
//                           authProvider.currentUserId() ?? "",
//                           authProvider.currentUser?.plateNumber ?? "");

//                       if (response == true) {
//                         // ignore: use_build_context_synchronously
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               "Your route has been created successfully",
//                               style: GoogleFonts.nunito(color: Colors.white),
//                             ),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                         navigationProvider.tabController.jumpToTab(0);
//                         navigationProvider.tabController.index = 0;
//                         Navigator.pop(context, true);
//                       }
//                     },
//                     child: CustomButton(
//                       text: 'Create',
//                       backgroundColor: AppColors.primaryColor,
//                     ),
//                   ),
//           )
//         ],
//       )),
//     );
//   }
// }
