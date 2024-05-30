import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeChoferScreen extends StatefulWidget {
  static String name = 'home_chofer_screen';
  final Map<String,dynamic>? data;
  const HomeChoferScreen({super.key, this.data});

  @override
  State<HomeChoferScreen> createState() => _HomeChoferScreenState();
}

class _HomeChoferScreenState extends State<HomeChoferScreen> {

  @override
  Widget build(BuildContext context) {

    final String? viajeId = widget.data?["viajeid"] as String?;


    return Scaffold(
      body: Center(
        child: Text(viajeId??"nodata"),
      ),
    );
  }
}