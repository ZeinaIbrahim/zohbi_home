import 'package:zohbi_user/utill/dimensions.dart';
import 'package:flutter/material.dart';

class CustomShadowWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final bool isActive;
  const CustomShadowWidget({
    Key? key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = Dimensions.radiusSizeDefault,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Container(
            padding: padding,
            margin: margin,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(borderRadius!),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(2, 10),
                    blurRadius: 30,
                    color: Theme.of(context).shadowColor.withOpacity(0.05)),
              ],
            ),
            child: child,
          )
        : child;
  }
}
