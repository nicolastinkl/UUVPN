//ignore_for_file: file_names
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/router/application.dart';
import 'package:sail/utils/l10n.dart';

import '/model/themeCollection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProPage extends StatelessWidget {
  const ProPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _list = [
      {
        'svg': '1',
        'title': 'Anonymous',
        'icon': 'assets/fi-sr-incognito.svg',
        'icon2': Icons.groups_3,
        'description': 'Hide your ip with anonymous surfing'
      },
      {
        'svg': '1',
        'title': 'Fast Safe',
        'icon': 'assets/fi-sr-rocket.svg',
        'icon2': Icons.rocket_launch,
        'description': 'Up to >=1 Mb/s bandwidth to explore'
      },
      {
        'svg': '1',
        'title': 'No Ads',
        'icon': 'assets/fi-sr-add.svg',
        'icon2': Icons.no_adult_content,
        'description': 'App without annoying ads'
      },
      {
        'svg': '0',
        'title': 'All Free',
        'icon2': Icons.sentiment_very_satisfied,
        'description': 'Really free, no kidding'
      },
      {
        'svg': '0',
        'title': 'Quit Anytime',
        'icon2': Icons.delete_forever,
        'description': 'Server does not record any user data'
      }
    ];
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    return Center(
      child: ListView(
        // shrinkWrap: true,
        children: [
          // SvgPicture.asset(
          //   'assets/logo.svg',
          //   cacheColorFilter: true,
          //   color: AppColors.greenColor,
          // ),
          // const SizedBox(height: 12),

          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Free ',
                  style: TextStyle(
                      fontFamily: 'Aquire',
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 24),
                  children: const [
                    TextSpan(
                        text: 'Features',
                        style: TextStyle(
                            fontFamily: 'Roboto', fontWeight: FontWeight.w500))
                  ])),
          const SizedBox(height: 32),

          /*childAspectRatio: 16 / 10,
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 14), */
          GridView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 16 / 4,
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 14),
              children: List.generate(
                  _list.length,
                  (index) => Column(
                        children: [
                          Row(
                            children: [
                              Icon(_list[index]['icon2'] as IconData,
                                  size: 30, color: AppColors.greenColor),
                              const SizedBox(width: 8.0),
                              Text(
                                _list[index]['title'] as String,
                                style: TextStyle(
                                    color: AppColors.greenColor, fontSize: 24),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              // Icon(_list[index]['icon2'] as IconData,
                              // size: 30, color: AppColors.greenColor),
                              const SizedBox(width: 40.0),
                              Container(
                                width: ScreenUtil().screenWidth / 1.5,
                                child: Text(
                                    _list[index]['description'] as String,
                                    overflow: TextOverflow.visible,
                                    textDirection: TextDirection.ltr,
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'Aquire',
                                        // backgroundColor: AppColors.yellowColor,
                                        color: isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20)),
                              )
                            ],
                          ),
                        ],
                      ))),
          // decoratedButton(context, '1 MONTH', '1.99', '\$/month', false),
          // decoratedButton(context, '1 YEAR', '0.99', '\$/month', true),
          // GestureDetector(
          //   onTap: () => Application.showMsg(context,
          //       "Notable features of UU: \n\n* No credit card required\n\n* You can try premium features for free for 7 days\n\n* Do not keep any user logs\n\n* Simple, one-click connection VPN\n\n* Automatically connects you to the fastest VPN server"),
          //   child: Container(
          //     alignment: Alignment.center,
          //     height: kToolbarHeight,
          //     margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(65),
          //         color: isDarkTheme
          //             ? AppColors.greenColor
          //             : AppColors.greenColor),
          //     child: Text(
          //       'FOREVER FOR FREE',
          //       style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
          //           color: isDarkTheme
          //               ? AppColors.whiteColor
          //               : Color.fromARGB(255, 9, 30, 4)),
          //     ),
          //   ),
          // ),
          Text(
            'Please rest assured to use.',
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
