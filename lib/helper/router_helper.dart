import 'dart:convert';
import 'package:zohbi_user/common/enums/html_type_enum.dart';
import 'package:zohbi_user/common/models/product_model.dart';
import 'package:zohbi_user/features/address/screens/address_screen.dart';
import 'package:zohbi_user/features/address/screens/select_location_screen.dart';
import 'package:zohbi_user/features/category/screens/category_screen.dart';
import 'package:zohbi_user/features/checkout/screens/checkout_screen.dart';
import 'package:zohbi_user/features/order/screens/order_successful_screen.dart';
import 'package:zohbi_user/features/payment/screens/payment_screen.dart';
import 'package:zohbi_user/features/payment/screens/order_web_payment.dart';
import 'package:zohbi_user/features/coupon/screens/coupon_screen.dart';
import 'package:zohbi_user/features/forgot_password/screens/create_new_password_screen.dart';
import 'package:zohbi_user/features/forgot_password/screens/forgot_password_screen.dart';
import 'package:zohbi_user/features/forgot_password/screens/verification_screen.dart';
import 'package:zohbi_user/features/flash_sale/screens/flash_sale_details_screen.dart';
import 'package:zohbi_user/helper/email_checker_helper.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/common/enums/search_short_by_enum.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/features/category/screens/all_category_screen.dart';
import 'package:zohbi_user/features/order/screens/order_screen.dart';
import 'package:zohbi_user/features/product/screens/product_details_screen.dart';
import 'package:zohbi_user/features/product/screens/product_image_screen.dart';
import 'package:zohbi_user/features/update/screens/update_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/common/models/address_model.dart';
import 'package:zohbi_user/common/models/order_model.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/common/widgets/map_widget.dart';
import 'package:zohbi_user/common/widgets/not_found.dart';
import 'package:zohbi_user/features/address/screens/add_new_address_screen.dart';
import 'package:zohbi_user/features/auth/screens/create_account_screen.dart';
import 'package:zohbi_user/features/auth/screens/login_screen.dart';
import 'package:zohbi_user/features/chat/screens/chat_screen.dart';
import 'package:zohbi_user/features/dashboard/screens/dashboard_screen.dart';
import 'package:zohbi_user/features/html/screens/html_viewer_screen.dart';
import 'package:zohbi_user/features/language/screens/choose_language_screen.dart';
import 'package:zohbi_user/features/notification/screens/notification_screen.dart';
import 'package:zohbi_user/features/onboarding/screens/onboarding_screen.dart';
import 'package:zohbi_user/features/order/screens/order_details_screen.dart';
import 'package:zohbi_user/features/profile/screens/profile_screen.dart';
import 'package:zohbi_user/features/rate_review/screens/rate_review_screen.dart';
import 'package:zohbi_user/features/search/screens/search_result_screen.dart';
import 'package:zohbi_user/features/search/screens/search_screen.dart';
import 'package:zohbi_user/features/splash/screens/splash_screen.dart';
import 'package:zohbi_user/features/support/screens/support_screen.dart';
import 'package:zohbi_user/features/track/screens/order_tracking_screen.dart';
import 'package:zohbi_user/features/welcome_screen/screens/welcome_screen.dart';
import 'package:zohbi_user/features/maintanance/screens/maintainance_screen.dart';
import 'package:provider/provider.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

//*******Handlers*********
  static final Handler _splashHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const SplashScreen());
  static final Handler _maintainHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const MaintenanceScreen());
  static final Handler _updateHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const UpdateScreen());

  static final Handler _languageHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return ChooseLanguageScreen(fromMenu: params['page'][0] == 'menu');
  });

  static final Handler _onbordingHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          OnBoardingScreen());

  static final Handler _welcomeHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const WelcomeScreen());

  static final Handler _loginHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const LoginScreen());

  static final Handler _productDetailsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return ProductDetailsScreen(
        product: Product(id: int.parse(params['id'][0])));
  });

  static final Handler _productImagesHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    ProductImageScreen? productImageScreen =
        ModalRoute.of(context!)!.settings.arguments as ProductImageScreen?;
    return productImageScreen ??
        ProductImageScreen(imageList: jsonDecode(params['images'][0]));
  });

  static final Handler _verificationHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    String? value = Uri.decodeComponent(jsonDecode(params['email'][0]));
    bool isPhone = EmailCheckerHelper.isNotValid(value);

    if (isPhone && !value.contains('+')) {
      value = '+$value'.replaceAll(' ', '');
    }
    return VerificationScreen(
      fromSignUp: params['page'][0] == 'sign-up',
      emailAddress: value,
    );
  });

  static final Handler _forgotPassHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const ForgotPasswordScreen());

  static final Handler _createNewPassHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CreateNewPasswordScreen? createPassScreen =
        ModalRoute.of(context!)!.settings.arguments as CreateNewPasswordScreen?;
    return createPassScreen ??
        CreateNewPasswordScreen(
          email: params['email'][0],
          resetToken: params['token'][0],
        );
  });

  static final Handler _createAccountHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return const CreateAccountScreen();
  });

  static final Handler _dashScreenBoardHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return DashboardScreen(
        pageIndex: params['page'][0] == 'home'
            ? 0
            : params['page'][0] == 'cart'
                ? 1
                : params['page'][0] == 'favourite'
                    ? 2
                    : params['page'][0] == 'menu'
                        ? 3
                        : 0);
  });

  static final Handler _deshboardHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const DashboardScreen(pageIndex: 0));

  static final Handler _searchHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const SearchScreen());

  static final Handler _searchResultHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['text'][0]);
    String shortBy = params['short_by'][0];

    String data = utf8.decode(decode);
    return SearchResultScreen(
      searchString: data,
      shortBy: shortBy.isEmpty || shortBy == 'null'
          ? null
          : SearchShortBy.values.byName(shortBy),
    );
  });

  static final Handler _categoryHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return CategoryScreen(
      categoryId: int.tryParse(params['id'][0]),
      subCategoryId: '${params['sub_id'][0]}' == '-1'
          ? null
          : int.tryParse(params['sub_id'][0]),
    );
  });

  static final Handler _notificationHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const NotificationScreen());

  static final Handler _checkoutHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    CheckoutScreen? checkoutScreen =
        ModalRoute.of(context!)!.settings.arguments as CheckoutScreen?;
    return checkoutScreen ??
        CheckoutScreen(
          orderType: params['type'][0],
          discount:
              double.parse(utf8.decode(base64Decode(params['discount'][0]))),
          amount: double.parse(utf8.decode(base64Decode(params['amount'][0]))),
          couponCode: utf8.decode(base64Decode(params['code'][0])),
          fromCart: params['fr_cart'][0].contains('1'),
          deliveryCharge:
              double.parse(utf8.decode(base64Decode(params['del_char'][0]))),
        );
  });

  static final Handler _paymentHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return PaymentScreen(
      orderId: int.tryParse(params['id'][0]),
      url: Uri.decodeComponent(utf8.decode(base64Decode(params['uri'][0]))),
    );
  });

  static final Handler _orderSuccessHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    int status = (params['status'][0] == 'success' ||
            params['status'][0] == 'payment-success')
        ? 0
        : params['status'][0] == 'fail'
            ? 1
            : 2;
    return OrderSuccessfulScreen(orderID: params['id'][0], status: status);
  });

  static final Handler _orderDetailsHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    OrderDetailsScreen? orderDetailsScreen =
        ModalRoute.of(context!)!.settings.arguments as OrderDetailsScreen?;
    return orderDetailsScreen ??
        OrderDetailsScreen(
            orderId: int.parse(params['id'][0]), orderModel: null);
  });

  static final Handler _rateReviewHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    RateReviewScreen? rateReviewScreen =
        ModalRoute.of(context!)!.settings.arguments as RateReviewScreen?;
    return rateReviewScreen ?? const NotFound();
  });

  static final Handler _orderTrackingHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return OrderTrackingScreen(
      orderID: params['id'][0],
      fromOrderList: '${params['route'][0]}'.contains('1'),
    );
  });

  static final Handler _profileHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const ProfileScreen());

  static final Handler _addressHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const AddressScreen());

  static final Handler _mapHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['address'][0].replaceAll(' ', '+'));
    DeliveryAddress data =
        DeliveryAddress.fromJson(jsonDecode(utf8.decode(decode)));
    return MapWidget(address: data);
  });

  static final Handler _newAddressHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool isUpdate = params['action'][0] == 'update';
    AddressModel? addressModel;
    if (isUpdate) {
      String decoded = utf8
          .decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      addressModel = AddressModel.fromJson(jsonDecode(decoded));
    }
    return AddNewAddressScreen(
        fromCheckout: params['page'][0] == 'checkout',
        isUpdateEnable: isUpdate,
        address: isUpdate ? addressModel : null);
  });

  static final Handler _selectLocationHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen? locationScreen =
        ModalRoute.of(context!)!.settings.arguments as SelectLocationScreen?;
    return locationScreen ?? const NotFound();
  });

  static final Handler _chatHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final orderModel = jsonDecode(
        utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return ChatScreen(
        orderModel:
            orderModel != null ? OrderModel.fromJson(orderModel) : null);
  });

  static final Handler _couponHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const CouponScreen());

  static final Handler _supportHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const SupportScreen());

  static final Handler _termsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition));

  static final Handler _policyHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy));

  static final Handler _aboutUsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.aboutUs));

  static final Handler _notFoundHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => const NotFound());

  static final Handler _returnPolicyHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.returnPolicy));

  static final Handler _refundPolicyHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.refundPolicy));

  static final Handler _cancellationPolicyHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy));
  static final Handler _categoriesHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const AllCategoryScreen());
  });
  static final Handler _flashSaleDetailsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const FlashSaleDetailsScreen());
  });

  static final Handler _orderWebPaymentHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(
        child: OrderWebPayment(
      token: params['token'][0],
    ));
  });

  static final Handler _orderListHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const OrderScreen());
  });

  static void _customRouteDefine(String routePath,
      {required Handler? handler,
      TransitionType? transitionType,
      Duration? transitionDuration}) {
    router.define(routePath,
        handler: handler,
        transitionType: transitionType,
        transitionDuration:
            transitionDuration ?? const Duration(milliseconds: 150));
  }

//*******Route Define*********
  static void setupRouter() {
    router.notFoundHandler = _notFoundHandler;
    _customRouteDefine(Routes.splashScreen,
        handler: _splashHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.languageScreen,
        handler: _languageHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.onBoardingScreen,
        handler: _onbordingHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.welcomeScreen,
        handler: _welcomeHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.loginScreen,
        handler: _loginHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.verify,
        handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.createAccountScreen,
        handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.forgotPassScreen,
        handler: _forgotPassHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.createNewPassScreen,
        handler: _createNewPassHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.dashboardScreen,
        handler: _dashScreenBoardHandler,
        transitionType: TransitionType.fadeIn); // ?page=home
    _customRouteDefine(Routes.dashboard,
        handler: _deshboardHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.productImages,
        handler: _productImagesHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.searchScreen,
        handler: _searchHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.searchResultScreen,
        handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.categoryScreen,
        handler: _categoryHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.productDetails,
        handler: _productDetailsHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.notificationScreen,
        handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.checkoutScreen,
        handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.paymentScreen,
        handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine('${Routes.orderSuccessScreen}/:id/:status',
        handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine('${Routes.orderWebPayment}/:status?:token',
        handler: _orderWebPaymentHandler,
        transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.orderDetailsScreen,
        handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.rateScreen,
        handler: _rateReviewHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.orderTrackingScreen,
        handler: _orderTrackingHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.profileScreen,
        handler: _profileHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.addressScreen,
        handler: _addressHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.mapScreen,
        handler: _mapHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.addAddressScreen,
        handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.selectLocationScreen,
        handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.chatScreen,
        handler: _chatHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.couponScreen,
        handler: _couponHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.supportScreen,
        handler: _supportHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.termsScreen,
        handler: _termsHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.policyScreen,
        handler: _policyHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.aboutUsScreen,
        handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.maintain,
        handler: _maintainHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.update,
        handler: _updateHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.returnPolicyScreen,
        handler: _returnPolicyHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.refundPolicyScreen,
        handler: _refundPolicyHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.cancellationPolicyScreen,
        handler: _cancellationPolicyHandler,
        transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.categories,
        handler: _categoriesHandler, transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.flashSaleDetailsScreen,
        handler: _flashSaleDetailsHandler,
        transitionType: TransitionType.fadeIn);
    _customRouteDefine(Routes.orderListScreen,
        handler: _orderListHandler, transitionType: TransitionType.fadeIn);
  }

  static Widget _routeHandler({required Widget child}) {
    return Provider.of<SplashProvider>(Get.context!, listen: false)
            .configModel!
            .maintenanceMode!
        ? const MaintenanceScreen()
        : child;
  }
}
