import 'package:flutter/widgets.dart';
import './colours.dart';

class TextStyles {
  static TextStyle bigTitle = TextStyle(
    fontSize: Dimens.font_sp24,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle listTitle = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle labelTitle = TextStyle(
    fontSize: Dimens.font_sp18,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle listContent = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_normal,
  );
  static TextStyle listContentBlack = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle listExtra = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray,
  );
  static TextStyle listSmallExtra = TextStyle(
    fontSize: Dimens.font_sp10,
    color: Colours.gray_66,
  );
  static TextStyle hugeTitle = TextStyle(
    fontSize: Dimens.font_sp30,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );
}

class Decorations {
  static Decoration bottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.33, color: Colours.divider)));
}

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap5 = new SizedBox(width: Dimens.gap_dp5);
  static Widget hGap15 = new SizedBox(width: Dimens.gap_dp15);
  static Widget hGap10 = new SizedBox(width: Dimens.gap_dp10);
  static Widget hGap8 = new SizedBox(width: Dimens.gap_dp8);
  static Widget hGap20 = new SizedBox(width: Dimens.gap_dp20);

  /// 垂直间隔
  static Widget vGap5 = new SizedBox(height: Dimens.gap_dp5);
  static Widget vGap10 = new SizedBox(height: Dimens.gap_dp10);
  static Widget vGap15 = new SizedBox(height: Dimens.gap_dp15);
  static Widget vGap20 = new SizedBox(height: Dimens.gap_dp20);
}

class Dimens {
  static const double font_sp8 = 8;
  static const double font_sp10 = 10;
  static const double font_sp12 = 12;
  static const double font_sp14 = 14;
  static const double font_sp16 = 16;
  static const double font_sp18 = 18;
  static const double font_sp20 = 20;
  static const double font_sp24 = 24;
  static const double font_sp26 = 26;
  static const double font_sp30 = 30;

  static const double gap_dp3 = 3;
  static const double gap_dp5 = 5;
  static const double gap_dp8 = 8;
  static const double gap_dp10 = 10;
  static const double gap_dp12 = 12;
  static const double gap_dp15 = 15;
  static const double gap_dp16 = 16;
  static const double gap_dp20 = 20;
  static const double gap_dp25 = 25;
  static const double gap_dp30 = 30;

  static const double btn_h_48 = 48;
  static const double item_h_42 = 42;

  static const double border_width = 0.33;
}
