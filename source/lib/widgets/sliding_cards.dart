import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uuvpn/entity/plan_entity.dart';
import 'package:uuvpn/models/user_model.dart';
import 'package:uuvpn/service/plan_service.dart';
import 'package:uuvpn/service/user_service.dart';
import 'package:uuvpn/utils/navigator_util.dart';

class SlidingCardsView extends StatefulWidget {
  const SlidingCardsView({Key? key}) : super(key: key);

  @override
  SlidingCardsViewState createState() => SlidingCardsViewState();
}

class SlidingCardsViewState extends State<SlidingCardsView> {
  late PageController pageController;
  double pageOffset = 0;
  List<PlanEntity> _planEntityList = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page!);
    });

    PlanService().plan()?.then((planEntityList) {
      if (this.mounted) {
        setState(() {
          _planEntityList = planEntityList;
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
          controller: pageController,
          children: List.from(_planEntityList.map((e) => SlidingCard(
              id: e.id,
              name: e.name,
              content: e.content ?? "",
              date: e.createdAt?.toIso8601String(),
              onetimePrice: (e.onetimePrice ?? 0.0) / 100,
              monthPrice: (e.monthPrice ?? 0.0) / 100,
              quarterPrice: (e.quarterPrice ?? 0.0) / 100,
              halfYearPrice: (e.halfYearPrice ?? 0.0) / 100,
              yearPrice: (e.yearPrice ?? 0.0) / 100,
              twoYearPrice: (e.twoYearPrice ?? 0.0) / 100,
              threeYearPrice: (e.threeYearPrice ?? 0.0) / 100,
              assetName: 'steve-johnson.jpeg',
              offset: pageOffset)))),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final int id;
  final String name;
  final String content;
  final String? date;
  final String assetName;
  final double offset;
  final double onetimePrice;
  final double monthPrice;
  final double quarterPrice;
  final double halfYearPrice;
  final double yearPrice;
  final double twoYearPrice;
  final double threeYearPrice;

  const SlidingCard({
    Key? key,
    required this.id,
    required this.name,
    required this.content,
    required this.date,
    required this.assetName,
    required this.offset,
    required this.onetimePrice,
    required this.monthPrice,
    required this.quarterPrice,
    required this.halfYearPrice,
    required this.yearPrice,
    required this.twoYearPrice,
    required this.threeYearPrice,
  }) : super(key: key);

  double lowestPrice() {
    List<double> list = [
      onetimePrice,
      monthPrice,
      quarterPrice,
      halfYearPrice,
      yearPrice,
      twoYearPrice,
      threeYearPrice,
    ];

    double min = double.maxFinite;

    for (int i = 0; i < list.length; i++) {
      if ((list[i] < min) && list[i] > 0) {
        min = list[i];
      }
    }

    return min;
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.red, Colors.orange, Colors.indigo]),
                ),
                child: Center(
                    child: Text('${name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25,
                        ))),
              ),
            ),
            // const SizedBox(height: 8),
            Expanded(
              child: CardContent(
                id: id,
                name: name,
                desc: content,
                date: date,
                offset: gauss,
                lowestPrice: lowestPrice(),
              ),
            ),
            GestureDetector(
              onTap: () {
                _userModel.checkHasLogin(
                    context,
                    () => UserService().getQuickLoginUrl(
                            {'redirect': "/plan/${id}"})?.then((value) {
                          NavigatorUtil.goWebView(
                              context, "购买${name}订阅", value);
                        }));
              },
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(32)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.orange, Colors.orange, Colors.orange]),
                  ),
                  child: Center(
                      child: Text('点击购买 ¥${lowestPrice()} 起',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatefulWidget {
  final int id;
  final String name;
  final String desc;
  final String? date;
  final double offset;
  final double lowestPrice;

  const CardContent(
      {Key? key,
      required this.id,
      required this.name,
      required this.desc,
      required this.date,
      required this.offset,
      required this.lowestPrice})
      : super(key: key);

  @override
  CardContentState createState() => CardContentState();
}

class CardContentState extends State<CardContent> {
  late UserModel _userModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userModel = Provider.of<UserModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * widget.offset, 0),
            child: Text(widget.desc,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          // Transform.translate(
          //   offset: Offset(32 * widget.offset, 0),
          //   child: Text(
          //     widget.date!,
          //     style: const TextStyle(
          //         color: Colors.grey, fontWeight: FontWeight.bold),
          //   ),
          // ),
          // const Spacer(),
          // Row(
          //   children: <Widget>[
          //     Transform.translate(
          //       offset: Offset(48 * widget.offset, 0),
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           foregroundColor: Colors.white,
          //           backgroundColor: Colors.yellow,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(32),
          //           ),
          //         ),
          //         onPressed: () => _userModel.checkHasLogin(
          //             context,
          //             () => UserService().getQuickLoginUrl({
          //                   'redirect': "/plan/${widget.id}"
          //                 })?.then((value) {
          //                   NavigatorUtil.goWebView(context, "配置订阅", value);
          //                 })),
          //         child: Transform.translate(
          //           offset: Offset(24 * widget.offset, 0),
          //           child: Text('购买',
          //               style: TextStyle(
          //                   color: Colors.black87,
          //                   fontSize: ScreenUtil().setSp(36))),
          //         ),
          //       ),
          //     ),
          //     const Spacer(),
          //     Transform.translate(
          //       offset: Offset(32 * widget.offset, 0),
          //       child: Text(
          //         '¥ ${widget.lowestPrice} 起',
          //         style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 20,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //   ],
          // )
        ],
      ),
    );
  }
}
