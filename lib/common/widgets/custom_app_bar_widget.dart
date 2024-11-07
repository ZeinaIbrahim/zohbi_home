import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/common/widgets/web_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/styles.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final bool onlyDesktop;
  final Function? onBackPressed;
  final double space;
  const CustomAppBarWidget(
      {Key? key,
      this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.onlyDesktop = false,
      this.space = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? const WebAppBarWidget()
        : onlyDesktop
            ? SizedBox(height: space)
            : AppBar(
                title: title == null
                    ? null
                    : Text(title!,
                        style: rubikMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                centerTitle: true,
                leading: isBackButtonExist
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        onPressed: () => onBackPressed != null
                            ? onBackPressed!()
                            : Navigator.pop(context),
                      )
                    : const SizedBox(),
                backgroundColor: Theme.of(context).cardColor,
                elevation: 0,
              );
  }

  @override
  Size get preferredSize => Size(
      double.maxFinite, ResponsiveHelper.isDesktop(Get.context!) ? 90 : 50);
}
