import 'package:finance_admin/view/screens/dashboard/totalUserCountWidgets.dart';
import 'package:flutter/material.dart';

class  DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: size.width * .7,
              // color: Colors.brown
              // ,
              child: UserCountWidget(),
            ),
          ),
        ),
      ],
    ));
  }
}
