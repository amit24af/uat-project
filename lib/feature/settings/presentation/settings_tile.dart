import 'package:flutter/material.dart';
class MySettingsTile extends StatelessWidget {
  final String title;
  final Widget action;
  const MySettingsTile({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade200,
        borderRadius: BorderRadius.circular(12),

      ),
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 25, right: 25, top:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          action
        ]
      )
    );
  }
}
