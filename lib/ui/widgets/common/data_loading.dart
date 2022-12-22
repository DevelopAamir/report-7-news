import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitDoubleBounce;
import '../../../core/common/app_color.dart';

class DataLoading extends StatelessWidget {

  final Color color;
  final double size;
  final int duration;
  final EdgeInsets padding;

  DataLoading({
    this.color,
    this.size,
    this.duration,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: SpinKitDoubleBounce(
          color: color ?? AppColors.primaryColor,
          size: size ?? 22,
          duration: Duration(milliseconds: duration ?? 1800),
        ),
      ),
    );
  }
}