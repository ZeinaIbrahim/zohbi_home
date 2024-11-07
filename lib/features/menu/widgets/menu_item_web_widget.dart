import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_alert_dialog_widget.dart';
import 'package:zohbi_user/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuItemWebWidget extends StatelessWidget {
  final String image;
  final String? title;
  final String routeName;
  const MenuItemWebWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.routeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogin =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: () {
        if (routeName == 'auth') {
          if (isLogin) {
            ResponsiveHelper.showDialogOrBottomSheet(
                context,
                CustomAlertDialogWidget(
                  title: getTranslated('want_to_sign_out', context),
                  icon: Icons.contact_support_outlined,
                  onPressRight: () {
                    Provider.of<AuthProvider>(context, listen: false)
                        .clearSharedData();
                    if (ResponsiveHelper.isWeb()) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.getMainRoute(), (route) => false);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.getSplashRoute(), (route) => false);
                    }
                  },
                ));
          } else {
            Navigator.pushNamed(context, Routes.getLoginRoute());
          }
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.04),
            borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAssetImageWidget(image,
                height: 40,
                width: 40,
                color: Theme.of(context).textTheme.titleMedium?.color),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(title!, style: rubikRegular),
          ],
        ),
      ),
    );
  }
}
