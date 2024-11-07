import 'dart:convert';

import 'package:zohbi_user/common/models/place_order_model.dart';
import 'package:zohbi_user/common/models/address_model.dart';
import 'package:zohbi_user/common/models/category_model.dart';
import 'package:zohbi_user/common/models/order_model.dart';
import 'package:zohbi_user/common/enums/search_short_by_enum.dart';

class Routes {
  static const String splashScreen = '/splash';
  static const String languageScreen = '/select-language';
  static const String onBoardingScreen = '/onboarding';
  static const String welcomeScreen = '/welcome';
  static const String loginScreen = '/login';
  static const String verify = '/verify';
  static const String forgotPassScreen = '/forgot-password';
  static const String createNewPassScreen = '/create-new-password';
  static const String createAccountScreen = '/create-account';
  static const String dashboard = '/';
  static const String maintain = '/maintain';
  static const String update = '/update';
  static const String dashboardScreen = '/main';
  static const String searchScreen = '/search';
  static const String searchResultScreen = '/search-result';
  static const String categoryScreen = '/category-screen';
  static const String notificationScreen = '/notification';
  static const String checkoutScreen = '/checkout';
  static const String paymentScreen = '/payment';
  static const String orderSuccessScreen = '/order-completed';
  static const String orderDetailsScreen = '/order-details';
  static const String rateScreen = '/rate-review';
  static const String orderTrackingScreen = '/order-tracking';
  static const String profileScreen = '/profile';
  static const String addressScreen = '/address';
  static const String mapScreen = '/map';
  static const String addAddressScreen = '/add-address';
  static const String selectLocationScreen = '/select-location';
  static const String chatScreen = '/chat_screen';
  static const String couponScreen = '/coupons';
  static const String supportScreen = '/support';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String productDetails = '/product-details';
  static String productImages = '/product-images';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';
  static String categories = '/categories';
  static const String flashSaleDetailsScreen = '/flash-sale-details';
  static const String orderWebPayment = '/order-web-payment';
  static const String orderListScreen = '/order-list';

  static String getSplashRoute() => splashScreen;
  static String getLanguageRoute(String page) => '$languageScreen?page=$page';
  static String getOnBoardingRoute() => onBoardingScreen;
  static String getWelcomeRoute() => welcomeScreen;
  static String getLoginRoute() => loginScreen;
  static String getForgetPassRoute() => forgotPassScreen;
  static String getNewPassRoute(String? email, String token) =>
      '$createNewPassScreen?email=$email&token=$token';
  static String getVerifyRoute(String page, String email) {
    String data = Uri.encodeComponent(jsonEncode(email));
    return '$verify?page=$page&email=$data';
  }

  static String getCreateAccountRoute() => createAccountScreen;
  static String getMainRoute() => dashboard;
  static String getMaintainRoute() => maintain;
  static String getUpdateRoute() => update;
  static String getDashboardRoute(String page) => '$dashboardScreen?page=$page';
  static String getProductDetailsRoute(int? id) => '$productDetails?id=$id';
  static String getProductImageRoute(String images) =>
      '$productImages?images=$images';
  static String getSearchRoute() => searchScreen;
  static String getSearchResultRoute({SearchShortBy? shortBy, String? text}) {
    List<int> encoded = utf8.encode(text ?? '');
    String data = base64Encode(encoded);
    return '$searchResultScreen?text=$data&short_by=${shortBy != null ? shortBy.name : ''}';
  }

  static String getNotificationRoute() => notificationScreen;
  static String getCategoryRoute(CategoryModel? categoryModel,
      {int? subCategoryId}) {
    return '$categoryScreen?sub_id=${subCategoryId ?? '-1'}&id=${categoryModel?.id}';
  }

  static String getCheckoutRoute({
    required double amount,
    double? discount,
    String? type,
    String? code,
    required double deliveryCharge,
    bool? fromCart = true,
  }) {
    String amountData = base64Encode(utf8.encode('$amount'));
    String discountData = base64Encode(utf8.encode('$discount'));
    String deliveryChargeData = base64Encode(utf8.encode('$deliveryCharge'));
    String couponData = base64Encode(utf8.encode('$code'));
    String isFromCart = fromCart! ? '1' : '0';
    return '$checkoutScreen?amount=$amountData&discount=$discountData&type=$type&code=$couponData&del_char=$deliveryChargeData&fr_cart=$isFromCart';
  }

  static String getPaymentRoute(
      {String? id = '', String? url, PlaceOrderModel? placeOrderBody}) {
    String uri = url != null
        ? Uri.encodeComponent(base64Encode(utf8.encode(url)))
        : 'null';
    String data = placeOrderBody != null
        ? base64Url.encode(utf8.encode(jsonEncode(placeOrderBody.toJson())))
        : '';
    return '$paymentScreen?id=$id&uri=$uri&place_order=$data';
  }

  static String getOrderDetailsRoute(int? id) => '$orderDetailsScreen?id=$id';
  static String getRateReviewRoute() => rateScreen;
  static String getOrderTrackingRoute(int? id, {bool fromOrderList = true}) =>
      '$orderTrackingScreen?id=$id&route=${fromOrderList ? 1 : 0}';
  static String getProfileRoute() => profileScreen;
  static String getAddressRoute() => addressScreen;
  static String getMapRoute(AddressModel addressModel) {
    List<int> encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String data = base64Encode(encoded);
    return '$mapScreen?address=$data';
  }

  static String getAddAddressRoute(
      String page, String action, AddressModel addressModel) {
    String data =
        base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$addAddressScreen?page=$page&action=$action&address=$data';
  }

  static String getSelectLocationRoute() => selectLocationScreen;
  static String getChatRoute({OrderModel? orderModel}) {
    String orderModel0 = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$chatScreen?order=$orderModel0';
  }

  static String getCouponRoute() => couponScreen;
  static String getSupportRoute() => supportScreen;
  static String getTermsRoute() => termsScreen;
  static String getPolicyRoute() => policyScreen;
  static String getAboutUsRoute() => aboutUsScreen;
  static String getReturnPolicyRoute() => returnPolicyScreen;
  static String getCancellationPolicyRoute() => cancellationPolicyScreen;
  static String getRefundPolicyRoute() => refundPolicyScreen;
  static String getCategoryAllRoute() => categories;
  static String getFlashSaleDetailsRoute() => flashSaleDetailsScreen;
  static String getOrderListScreen() => orderListScreen;
}
