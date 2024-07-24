//ignore_for_file: file_names
import '/pages/proPage.dart';
import 'package:flutter/material.dart';

class ProRoute extends StatelessWidget {
  const ProRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CloseButton(),
          )
        ],
      ),
      body: const ProPage(),
    );
  }
}
