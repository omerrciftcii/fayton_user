import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/providers/request_provider.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({super.key});

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  @override
  void initState() {
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var requestProvider = Provider.of<RequestProvider>(context);
    return Scaffold(
        body: Center(
      child: Text('Hələ bildiriş yoxdur'),
    ));
  }
}
