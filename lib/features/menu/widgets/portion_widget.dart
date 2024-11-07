import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter/material.dart';

class PortionWidget extends StatelessWidget {
  final String? imageIcon;
  final IconData? icon;
  final String title;
  final bool hideDivider;
  final String? route;
  final String? suffix;
  const PortionWidget(
      {Key? key,
      required this.imageIcon,
      required this.title,
      this.route,
      this.hideDivider = false,
      this.suffix,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: route == null ? null : () => Navigator.pushNamed(context, route!),
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Row(children: [
            icon != null
                ? Icon(icon,
                    size: 16,
                    color: Theme.of(context).textTheme.titleMedium?.color)
                : CustomAssetImageWidget(
                    imageIcon!,
                    height: 16,
                    width: 16,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
                child: Text(title,
                    style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault))),
            suffix != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSizeDefault),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall,
                        horizontal: Dimensions.paddingSizeSmall),
                    child: Text(suffix!,
                        style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).cardColor)),
                  )
                : const SizedBox(),
          ]),
          hideDivider ? const SizedBox() : const Divider()
        ]),
      ),
    );
  }
}
