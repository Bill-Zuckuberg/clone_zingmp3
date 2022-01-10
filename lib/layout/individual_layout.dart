import 'package:flutter/material.dart';

class IndividualLayout extends StatefulWidget {
  const IndividualLayout({Key? key}) : super(key: key);

  @override
  _IndividualLayoutState createState() => _IndividualLayoutState();
}

class _IndividualLayoutState extends State<IndividualLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          // Phần Search
          Row(
            children: [
              Container(
                child: const CircleAvatar(
                  child: Icon(Icons.access_alarm),
                ),
              ),
              Expanded(child: Container()),
              const Icon(Icons.settings)
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Thư Viện",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          // Phần .....
        ],
      ),
    );
  }
}
