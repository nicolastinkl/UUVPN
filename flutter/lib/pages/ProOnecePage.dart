//ProOnecePage.dart
//ignore_for_file: file_names
import 'package:sail/constant/app_colors.dart';
import 'package:sail/router/application.dart';
import 'package:sail/utils/l10n.dart';

import '/model/themeCollection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProOnecePage extends StatelessWidget {
  const ProOnecePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          // SvgPicture.asset(
          //   'assets/logo.svg',
          //   cacheColorFilter: true,
          //   color: AppColors.greenColor,
          // ),
          const SizedBox(height: 12),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: ' ',
                  style: TextStyle(
                      fontFamily: 'Aquire',
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 24),
                  children: const [
                    TextSpan(
                        text: 'Your privacy comes first',
                        style: TextStyle(
                            fontFamily: 'Roboto', fontWeight: FontWeight.w500))
                  ])),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: """

    We do not keep logs of your online activities and never associate any domains or applications that you use with you, your device,IP address, or email. Betternet collects a minimal amount of data to offer you a fast and reliable VPN service. We collect:

    Device-specific information like OS version hardware modeland IP address to optimize our network connection to you.We do not store or log your IP address after you disconnect from the VPN
    
Aggregated anonymous website activity datatoperform analytics on our service and to ensure you can reliably access certain websites orapps

For more information, please read our Privacy Policy


""",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 17),
                ),
              )),

          const SizedBox(height: 32),

          // decoratedButton(context, '1 MONTH', '1.99', '\$/month', false),
          // decoratedButton(context, '1 YEAR', '0.99', '\$/month', true),
          GestureDetector(
            onTap: () => {Navigator.maybePop(context)},
            child: Container(
              alignment: Alignment.center,
              height: kToolbarHeight,
              margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(65),
                  color: Color.fromARGB(255, 34, 128, 15).withOpacity(0.7)),
              child: Text(
                'Accept and continue',
                style: Theme.of(context).primaryTextTheme.labelMedium!.copyWith(
                      color: AppColors.whiteColor,
                    ),
              ),
            ),
          ),
          Text(
            ' ',
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  Container decoratedButton(BuildContext context, String lt, String rt_1,
      String rt_2, bool isDiscount) {
    return Container(
      height: kToolbarHeight,
      margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(65),
          gradient: const LinearGradient(
              colors: [AppColors.greenColor, Color.fromARGB(255, 7, 52, 7)],
              transform: GradientRotation(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                lt,
                style: Theme.of(context)
                    .primaryTextTheme
                    .labelMedium!
                    .copyWith(color: Colors.white),
              ),
              if (isDiscount)
                Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Text(
                    '50% OFF',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
            ],
          ),
          RichText(
              text: TextSpan(
                  text: rt_1,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelMedium!
                      .copyWith(color: Colors.white),
                  children: [
                TextSpan(
                  text: ' $rt_2',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelMedium!
                      .copyWith(color: Colors.white),
                )
              ])),
        ],
      ),
    );
  }
}
