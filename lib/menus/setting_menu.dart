import 'package:flutter/material.dart';

class SettingMenu extends StatefulWidget {
  const SettingMenu({super.key});

  @override
  State<SettingMenu> createState() => _SettingMenuState();
}

class _SettingMenuState extends State<SettingMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) => Container(
          height: 100,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).canvasColor,
            boxShadow: const [BoxShadow()],
          ),
        ),
      ),
    );
  }
}
