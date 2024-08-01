// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:userapp/screens/message_detail_screen.dart';

// class ConversationWidget extends StatefulWidget {
//   String name;
//   String messageText;
//   String imageUrl;
//   String time;
//   bool isMessageRead;
//   ConversationWidget(
//       {required this.name,
//       required this.messageText,
//       required this.imageUrl,
//       required this.time,
//       required this.isMessageRead});
//   @override
//   _ConversationWidgetState createState() => _ConversationWidgetState();
// }

// class _ConversationWidgetState extends State<ConversationWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ChatPage(),
//           ),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 children: <Widget>[
//                   CircleAvatar(
//                     backgroundImage:
//                         CachedNetworkImageProvider(widget.imageUrl),
//                     maxRadius: 30,
//                   ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             widget.name,
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             widget.messageText,
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade600,
//                                 fontWeight: widget.isMessageRead
//                                     ? FontWeight.bold
//                                     : FontWeight.normal),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               widget.time,
//               style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: widget.isMessageRead
//                       ? FontWeight.bold
//                       : FontWeight.normal),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
