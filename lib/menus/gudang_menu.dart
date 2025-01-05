import 'package:flutter/material.dart';

class GudangMenu extends StatefulWidget {
  const GudangMenu({super.key});

  @override
  State<GudangMenu> createState() => _GudangMenuState();
}

class _GudangMenuState extends State<GudangMenu> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here for the button press
          // For example, you can navigate to a different screen
          print("Add button pressed");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
