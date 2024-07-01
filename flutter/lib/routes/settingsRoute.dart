//ignore_for_file: file_names
import 'package:sail/constant/app_colors.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/routes/proRoute.dart';
import 'package:sail/utils/navigator_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/themeCollection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  int connectionValue = 0;
  bool killSwitch = false, proVpn = false, notifySwitch = false;
  List<String> connectionModes = ['IPSec', 'ISSR'];

  setConnectionValue(int? value) {
    setState(() {
      connectionValue = value!;
    });
  }

  customListTile(BuildContext context, String title, String icon,
          {Widget? trailing,
          Icon? sysicon,
          String? subtitle,
          VoidCallback? onTap}) =>
      ListTile(
          onTap: onTap ?? null,
          minLeadingWidth: 35,
          dense: true,
          contentPadding: EdgeInsets.only(left: 24),
          title: Text(title,
              style: Theme.of(context).primaryTextTheme.labelMedium),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: Theme.of(context).primaryTextTheme.labelMedium,
                )
              : null,
          // leading: sysicon ??
          //     SvgPicture.asset(
          //       icon,
          //       // color: Theme.of(context).colorScheme.secondary,
          //       width: 24,
          //       cacheColorFilter: true,
          //       color: AppColors.greenColor,
          //       alignment: Alignment.centerRight,
          //     ),
          trailing: trailing ?? null);

  upgradeButton(context) => GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => const ProRoute())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(65),
            gradient: const LinearGradient(
                colors: [AppColors.greenColor, Color.fromARGB(255, 9, 54, 21)],
                transform: GradientRotation(5))),
        child: Text(
          'Upgrade',
          style: Theme.of(context)
              .primaryTextTheme
              .labelMedium!
              .copyWith(color: Colors.white),
        ),
      ));

  Divider get divider => Divider(
      indent: 16,
      endIndent: 16,
      color: Colors.grey.withAlpha(50),
      thickness: 1);

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Column listTileSet(String title, String description, bool value,
          Function(bool)? onChanged) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        divider,
        // const Divider(color: Colors.grey, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: Text(title,
              style: Theme.of(context)
                  .primaryTextTheme
                  .labelMedium!
                  .copyWith(color: Colors.grey)),
        ),
        SwitchListTile(
            activeColor: AppColors.greenColor,
            inactiveTrackColor:
                Provider.of<ThemeCollection>(context).isDarkActive
                    ? AppColors.whiteColor.withAlpha(90)
                    : const Color(0xffD7D6D9),
            contentPadding: EdgeInsets.only(left: 24),
            title: Text(
              description,
              style: Theme.of(context).primaryTextTheme.labelMedium,
            ),
            value: value,
            onChanged: onChanged)
      ]);

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    var themeData = Provider.of<ThemeCollection>(context);
    return Scaffold(
      backgroundColor: isDarkTheme ? Color(0xff0B0415) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: isDarkTheme ? Colors.white : Color(0xff0B0415),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        children: [
          /*Text('Connection Mode',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1!
                  .copyWith(color: Colors.grey)),
          const SizedBox(height: 4),
          Column(
              children: connectionModes.map((e) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                e,
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
              trailing: Radio(
                  fillColor: MaterialStateProperty.all(
                    connectionModes[connectionValue] != e
                        ? themeData.isDarkActive
                            ? Colors.white70
                            : Colors.grey
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  value: connectionModes.indexOf(e),
                  groupValue: connectionValue,
                  onChanged: setConnectionValue),
            );
          }).toList()),
          listTileSet(
              'Kill Switch',
              'Block internet when connecting or changing servers',
              killSwitch,
              (value) => setState(() => killSwitch = value)),
              
          listTileSet('Connection', 'Connect when  VPN starts', proVpn,
              (value) => setState(() => proVpn = value)),*/
          listTileSet(
              'Notification',
              'Show notification when VPN is not connected.',
              notifySwitch,
              (value) => setState(() => notifySwitch = value)),
          listTileSet('Dark theme', 'Reduce glare & improve night viewing.',
              themeData.isDarkActive, (value) {
            themeData.setDarkTheme(value);
          }),
          divider,
          customListTile(context, 'Rate us', '',
              trailing: IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 20,
                      color: isDarkTheme
                          ? Color.fromARGB(255, 148, 145, 145)
                          : Color.fromARGB(255, 190, 187, 187))),
              sysicon: Icon(Icons.rate_review,
                  size: 30, color: AppColors.greenColor),
              onTap: () => _launchUrl(Uri.parse(
                  "https://apps.apple.com/us/app/uuvpn-2023/id6449599228"))),
          divider,
          customListTile(context, 'Privacy policy', '',
              trailing: IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 20,
                      color: isDarkTheme
                          ? Color.fromARGB(255, 148, 145, 145)
                          : Color.fromARGB(255, 190, 187, 187))),
              sysicon: Icon(Icons.private_connectivity,
                  size: 30, color: AppColors.greenColor),
              onTap: () => NavigatorUtil.goWebView(context, "Privacy policy",
                  "https://uuvpn.co/privacy-policy/")),
          divider,
          customListTile(context, 'Terms&Conditions', '',
              sysicon: Icon(Icons.format_align_center,
                  size: 30, color: AppColors.greenColor),
              trailing: IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 20,
                      color: isDarkTheme
                          ? Color.fromARGB(255, 148, 145, 145)
                          : Color.fromARGB(255, 190, 187, 187))), onTap: () {
            NavigatorUtil.goWebView(
                context, "Terms&Conditions", "https://uuvpn.co/terms/");
          }),
          divider,
          customListTile(context, 'Online Help', '',
              sysicon: Icon(Icons.format_align_center,
                  size: 30, color: AppColors.greenColor),
              trailing: IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 20,
                      color: isDarkTheme
                          ? Color.fromARGB(255, 148, 145, 145)
                          : Color.fromARGB(255, 190, 187, 187))), onTap: () {
            // NavigatorUtil.goWebView(
            //     context, "Terms&Conditions", "https://uuvpn.co/terms/");
            NavigatorUtil.goWebView(context, "Online Help",
                "https://go.crisp.chat/chat/embed/?website_id=3ed83170-f288-4c23-acd4-30c1e557948b&user_email=${userModel.userEntity?.email}");
          }),
          divider,
        ],
      ),
    );
  }
}
