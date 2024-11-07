import 'dart:ui';

import 'package:zohbi_user/common/enums/footer_type_enum.dart';
import 'package:zohbi_user/common/models/cart_model.dart';
import 'package:zohbi_user/common/models/check_out_model.dart';
import 'package:zohbi_user/common/models/config_model.dart';
import 'package:zohbi_user/common/widgets/custom_app_bar_widget.dart';
import 'package:zohbi_user/common/widgets/custom_web_title_widget.dart';
import 'package:zohbi_user/common/widgets/footer_web_widget.dart';
import 'package:zohbi_user/common/widgets/not_logged_in_screen.dart';
import 'package:zohbi_user/features/address/providers/address_provider.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/features/cart/providers/cart_provider.dart';
import 'package:zohbi_user/features/checkout/providers/checkout_provider.dart';
import 'package:zohbi_user/features/checkout/widgets/details_view_widget.dart';
import 'package:zohbi_user/features/checkout/widgets/map_view_widget.dart';
import 'package:zohbi_user/features/checkout/widgets/place_order_button_view.dart';
import 'package:zohbi_user/features/profile/providers/profile_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/helper/checkout_helper.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel>? cartList;
  final double? amount;
  final double? discount;
  final String? couponCode;
  final double deliveryCharge;
  final String? orderType;
  final bool fromCart;

  const CheckoutScreen({
    Key? key,
    required this.amount,
    required this.orderType,
    required this.fromCart,
    required this.discount,
    required this.couponCode,
    required this.deliveryCharge,
    this.cartList,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();

  late bool _isLoggedIn;
  late List<CartModel?> _cartList;
  List<Branches>? _branches = [];

  @override
  void initState() {
    super.initState();

    final CheckoutProvider checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    _branches = Provider.of<SplashProvider>(context, listen: false)
        .configModel
        ?.branches;

    if (_isLoggedIn) {
      Provider.of<AddressProvider>(context, listen: false)
          .initAddressList()
          .then((value) {
        CheckOutHelper.selectDeliveryAddressAuto(
            orderType: widget.orderType,
            isLoggedIn: _isLoggedIn,
            lastAddress: null);
      });
      Provider.of<CheckoutProvider>(context, listen: false).clearPrevData();

      _cartList = [];

      if (widget.fromCart) {
        _cartList
            .addAll(Provider.of<CartProvider>(context, listen: false).cartList);
      } else {
        _cartList.addAll(widget.cartList ?? []);
      }

      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
          null) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
      }
    }

    checkoutProvider.setCheckOutData = CheckOutModel(
      orderType: widget.orderType,
      deliveryCharge: widget.deliveryCharge,
      freeDeliveryType: '',
      amount: widget.amount,
      placeOrderDiscount: 0,
      couponCode: widget.couponCode,
      orderNote: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    bool kmWiseCharge = configModel.deliveryManagement!.status!;
    bool selfPickup = widget.orderType == 'self_pickup';

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(title: getTranslated('checkout', context)),
      body: _isLoggedIn
          ? Consumer<CheckoutProvider>(
              builder: (context, checkoutProvider, child) {
                double deliveryCharge = checkoutProvider.distance *
                    (configModel.deliveryManagement?.shippingPerKm ?? 1);
                if (deliveryCharge <
                    (configModel.deliveryManagement?.minShippingCharge ?? 0)) {
                  deliveryCharge =
                      configModel.deliveryManagement?.minShippingCharge ?? 0;
                }
                if (!kmWiseCharge || checkoutProvider.distance == -1) {
                  deliveryCharge = 0;
                }

                return Consumer<AddressProvider>(
                  builder: (context, address, child) {
                    return Column(children: [
                      Expanded(
                          child: CustomScrollView(slivers: [
                        SliverToBoxAdapter(
                            child: Center(
                                child: SizedBox(
                          width: Dimensions.webScreenWidth,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWebTitleWidget(
                                    title: getTranslated('checkout', context)),
                                if (!ResponsiveHelper.isDesktop(context))
                                  MapViewWidget(isSelfPickUp: selfPickup),
                                if (!ResponsiveHelper.isDesktop(context))
                                  DetailsViewWidget(
                                    amount: widget.amount ?? 0,
                                    kmWiseCharge: kmWiseCharge,
                                    selfPickup: selfPickup,
                                    deliveryCharge: deliveryCharge,
                                    orderNoteController: _noteController,
                                    orderType: widget.orderType,
                                    cartList: _cartList,
                                  ),
                                if (ResponsiveHelper.isDesktop(context))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeLarge),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (!selfPickup ||
                                            (selfPickup &&
                                                (_branches?.length ?? 0) < 1))
                                          Expanded(
                                              flex: 6,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context)
                                                            .shadowColor,
                                                        blurRadius: 10,
                                                      )
                                                    ]),
                                                child: MapViewWidget(
                                                    isSelfPickUp: selfPickup),
                                              )),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeLarge),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor,
                                                      blurRadius: 10,
                                                    )
                                                  ]),
                                              child: DetailsViewWidget(
                                                amount: widget.amount ?? 0,
                                                kmWiseCharge: kmWiseCharge,
                                                selfPickup: selfPickup,
                                                deliveryCharge: deliveryCharge,
                                                orderNoteController:
                                                    _noteController,
                                                orderType:
                                                    widget.orderType ?? '',
                                                cartList: _cartList,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                              ]),
                        ))),
                        const FooterWebWidget(footerType: FooterType.sliver),
                      ])),
                      if (!ResponsiveHelper.isDesktop(context))
                        PlaceOrderButtonView(
                          deliveryCharge: deliveryCharge,
                          amount: widget.amount,
                          cartList: _cartList,
                          kmWiseCharge: kmWiseCharge,
                          orderNote: _noteController.text,
                          orderType: widget.orderType,
                        ),
                    ]);
                  },
                );
              },
            )
          : const NotLoggedInScreen(),
    );
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
