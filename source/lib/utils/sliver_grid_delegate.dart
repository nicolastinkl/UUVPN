import 'package:flutter/material.dart';

SliverGridDelegate gridDelegate(BuildContext context) {
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: MediaQuery.of(context).size.width > 500.0 ? 4 : 2,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 100 / 150,
  );
}
