import 'package:zohbi_user/common/enums/search_short_by_enum.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/common/widgets/pluto_menu_bar_widget.dart';
import 'package:provider/provider.dart';

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({Key? key}) : super(key: key);

  List<MenuItems> getMenus(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return [
      MenuItems(
        title: getTranslated('home', context),
        icon: Icons.home_filled,
        onTap: () =>
            Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
      ),
      MenuItems(
        title: getTranslated('offer', context),
        icon: Icons.local_offer_outlined,
        onTap: () => Navigator.pushNamed(context,
            Routes.getSearchResultRoute(shortBy: SearchShortBy.offerProducts)),
      ),
      MenuItems(
        title: getTranslated('necessary_links', context),
        icon: Icons.settings,
        children: [
          MenuItems(
            title: getTranslated('privacy_policy', context),
            onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
          ),
          MenuItems(
            title: getTranslated('terms_and_condition', context),
            onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
          ),
          MenuItems(
            title: getTranslated('about_us', context),
            onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
          ),
        ],
      ),
      MenuItems(
        title: getTranslated('favourite', context),
        icon: Icons.favorite_border,
        onTap: () =>
            Navigator.pushNamed(context, Routes.getDashboardRoute('favourite')),
      ),
      MenuItems(
        title: getTranslated('menu', context),
        icon: Icons.menu,
        onTap: () =>
            Navigator.pushNamed(context, Routes.getDashboardRoute('menu')),
      ),
      isLoggedIn
          ? MenuItems(
              title: getTranslated('profile', context),
              icon: Icons.person,
              onTap: () =>
                  Navigator.pushNamed(context, Routes.getProfileRoute()),
            )
          : MenuItems(
              title: getTranslated('login', context),
              icon: Icons.lock,
              onTap: () => Navigator.pushNamed(context, Routes.getLoginRoute()),
            ),
      MenuItems(
        title: '',
        icon: Icons.shopping_cart,
        onTap: () =>
            Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.white,
      width: 700,
      child: PlutoMenuBarWidget(
        backgroundColor: Theme.of(context).cardColor,
        gradient: false,
        goBackButtonText: 'Back',
        textStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        moreIconColor: Theme.of(context).textTheme.bodyLarge!.color,
        menuIconColor: Theme.of(context).textTheme.bodyLarge!.color,
        menus: getMenus(context),
      ),
    );
  }
}
