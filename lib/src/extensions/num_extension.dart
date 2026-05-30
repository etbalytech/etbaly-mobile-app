import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumExtension on num {
  // SizedBox generators
  Widget get kH => SizedBox(height: h);
  Widget get kW => SizedBox(width: w);

  // BorderRadius helpers
  BorderRadius get radius => BorderRadius.circular(r);

  // Duration helpers
  Duration get ms => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
}
