//ignore_for_file: file_names
import 'dart:math';
import '/model/flags.dart';

import '../model/UserPreference.dart';
import '../model/themeCollection.dart';
import 'package:provider/provider.dart';
import '/routes/chooseLocationRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePagesss extends StatelessWidget {
  const HomePagesss({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    int currentLocIndex = 0;
    Widget netSpeed(IconData icon, Color color) => Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            Builder(builder: (context) {
              return RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          color: isDarkTheme ? Colors.white : Colors.black),
                      text:
                          Provider.of<UserPreference>(context).isCountDownStart
                              ? Random().nextInt(500).toString() + ' '
                              : '___',
                      children: const [
                    TextSpan(text: 'KB/S', style: TextStyle(fontSize: 12))
                  ]));
            })
          ],
        );
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 6,
          color:
              isDarkTheme ? const Color(0xff181227) : const Color(0xffF5F5F6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Builder(builder: (context) {
            currentLocIndex =
                Provider.of<UserPreference>(context).locationIndex;
            return ListTile(
              leading: SvgPicture.asset(
                'assets/flags/${Flags.list[currentLocIndex]['imagePath']}',
                width: 42,
                alignment: Alignment.center,
              ),
              trailing: SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.signal_cellular_alt_rounded,
                      color: Colors.white,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.navigate_next_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (builder) =>
                                    const ChooseLocationRoute()))),
                  ],
                ),
              ),
              title: Text(
                Flags.list[currentLocIndex]['name'] as String,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).primaryTextTheme.headline6,
              ),
              subtitle: Text('IP: 79.110.53.95',
                  style: Theme.of(context).primaryTextTheme.caption),
            );
          }),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            netSpeed(
              Icons.south_rounded,
              Theme.of(context).primaryColor,
            ),
            netSpeed(
              Icons.north_rounded,
              Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
      SvgPicture.asset(
        'assets/map.svg',
        width: MediaQuery.of(context).size.width,
        color: isDarkTheme ? const Color(0xff38323F) : const Color(0xffC7B4E3),
        fit: BoxFit.cover,
      ),
      Builder(builder: (_context) {
        var countDown = Provider.of<UserPreference>(_context);
        return GestureDetector(
          onTap: () => Provider.of<UserPreference>(context, listen: false)
              .countDownSwitch,
          child: Card(
            elevation: 6,
            color:
                isDarkTheme ? const Color(0xff181227) : const Color(0xffF5F5F6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: SizedBox.square(
              dimension: 75 * 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      countDown.isCountDownStart
                          ? 'assets/stop.svg'
                          : 'assets/powOn.svg',
                      width: countDown.isCountDownStart ? 35 : 50,
                      color: countDown.isCountDownStart
                          ? Colors.redAccent.shade200
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        countDown.isCountDownStart
                            ? '${countDown.duration.inHours} : ${countDown.duration.inMinutes % 60} : ${countDown.duration.inSeconds % 60}'
                            : 'Start',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        );
      })
    ]);
  }
}
