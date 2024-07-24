//ignore_for_file: file_names
import '/model/UserPreference.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '/model/flags.dart';
import 'package:flutter/material.dart';

class ChooseLocationRoute extends StatelessWidget {
  const ChooseLocationRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: const Text('Choose location'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: Flags.list.length,
        itemBuilder: (builder, index) => ListTile(
            onTap: () {
              Provider.of<UserPreference>(context, listen: false)
                  .setlocationIndex(index);
              Navigator.of(context).pop();
            },
            leading: SvgPicture.asset(
              'assets/flags/${Flags.list[index]['imagePath']}',
              width: 42,
            ),
            title: Text(
              Flags.list[index]['name'] as String,
              style: Theme.of(context).primaryTextTheme.labelMedium,
            ),
            trailing: Icon(
              Icons.navigate_next_rounded,
              color: Theme.of(context).iconTheme.color,
            )),
      ),
    );
  }
}
