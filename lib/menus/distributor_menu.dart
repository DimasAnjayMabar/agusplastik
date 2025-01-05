import 'package:agusplastik/popups/create/create_distributor.dart';
import 'package:flutter/material.dart';

class DistributorMenu extends StatefulWidget {
  const DistributorMenu({super.key});

  @override
  State<DistributorMenu> createState() => _DistributorMenuState();
}

class _DistributorMenuState extends State<DistributorMenu> {
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
          // Use showDialog to display the CreateDistributor dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CreateDistributor();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
