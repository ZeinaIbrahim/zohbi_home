import 'package:zohbi_user/common/models/category_model.dart';

class ConfigModel {
  String? _ecommerceName;
  String? _appLogo;
  String? _ecommerceAddress;
  String? _ecommercePhone;
  String? _ecommerceEmail;
  EcommerceLocationCoverage? _ecommerceLocationCoverage;
  double? _minimumOrderValue;
  int? _selfPickup;
  BaseUrls? _baseUrls;
  String? _currencySymbol;
  double? _deliveryCharge;
  bool? _cashOnDelivery;
  bool? _digitalPayment;
  List<Branches>? _branches;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;
  bool? _emailVerification;
  bool? _phoneVerification;
  String? _currencySymbolPosition;
  bool? _maintenanceMode;
  String? _countryCode;
  DeliveryManagement? _deliveryManagement;
  PlayStoreConfig? _playStoreConfig;
  AppStoreConfig? _appStoreConfig;
  List<SocialMediaLink>? _socialMediaLink;
  String? _softwareVersion;
  String? _footerCopyright;
  int? _otpResendTime;
  CookiesManagement? _cookiesManagement;
  SocialStatus? _socialLoginStatus;
  Whatsapp? _whatsapp;
  Telegram? _telegram;
  Messenger? _messenger;
  List<CategoryModel>? _featuredCategory;
  List<PaymentMethod>? _activePaymentMethodList;

  ConfigModel({
    String? ecommerceName,
    String? appLogo,
    String? ecommerceAddress,
    String? ecommercePhone,
    String? ecommerceEmail,
    EcommerceLocationCoverage? ecommerceLocationCoverage,
    double? minimumOrderValue,
    int? selfPickup,
    BaseUrls? baseUrls,
    String? currencySymbol,
    double? deliveryCharge,
    bool? cashOnDelivery,
    bool? digitalPayment,
    List<Branches>? branches,
    String? termsAndConditions,
    String? privacyPolicy,
    String? aboutUs,
    bool? emailVerification,
    bool? phoneVerification,
    String? currencySymbolPosition,
    bool? maintenanceMode,
    String? countryCode,
    DeliveryManagement? deliveryManagement,
    PlayStoreConfig? playStoreConfig,
    AppStoreConfig? appStoreConfig,
    List<SocialMediaLink>? socialMediaLink,
    String? softwareVersion,
    int? otpResendTime,
    CookiesManagement? cookiesManagement,
    SocialStatus? socialLoginStatus,
    Whatsapp? whatsapp,
    Telegram? telegram,
    Messenger? messenger,
    List<CategoryModel>? featuredCategory,
    List<PaymentMethod>? activePaymentMethodList,
  }) {
    _ecommerceName = ecommerceName;
    _appLogo = appLogo;
    _ecommerceAddress = ecommerceAddress;
    _ecommercePhone = ecommercePhone;
    _ecommerceEmail = ecommerceEmail;
    _ecommerceLocationCoverage = ecommerceLocationCoverage;
    _minimumOrderValue = minimumOrderValue;
    _selfPickup = selfPickup;
    _baseUrls = baseUrls;
    _currencySymbol = currencySymbol;
    _deliveryCharge = deliveryCharge;
    _cashOnDelivery = cashOnDelivery;
    _digitalPayment = digitalPayment;
    _branches = branches;
    _termsAndConditions = termsAndConditions;
    _aboutUs = aboutUs;
    _privacyPolicy = privacyPolicy;
    _emailVerification = emailVerification;
    _phoneVerification = phoneVerification;
    _currencySymbolPosition = currencySymbolPosition;
    _maintenanceMode = maintenanceMode;
    _countryCode = countryCode;
    _deliveryManagement = deliveryManagement;
    _playStoreConfig = playStoreConfig;
    _appStoreConfig = appStoreConfig;
    _socialMediaLink = socialMediaLink;
    _softwareVersion = softwareVersion;
    _otpResendTime = otpResendTime;
    _cookiesManagement = cookiesManagement;
    _socialLoginStatus = socialLoginStatus;
    _whatsapp = whatsapp;
    _telegram = telegram;
    _messenger = messenger;
    _featuredCategory = featuredCategory;
    _activePaymentMethodList = activePaymentMethodList;
  }

  String? get ecommerceName => _ecommerceName;
  String? get appLogo => _appLogo;
  String? get ecommerceAddress => _ecommerceAddress;
  String? get ecommercePhone => _ecommercePhone;
  String? get ecommerceEmail => _ecommerceEmail;
  EcommerceLocationCoverage? get ecommerceLocationCoverage =>
      _ecommerceLocationCoverage;
  double? get minimumOrderValue => _minimumOrderValue;
  int? get selfPickup => _selfPickup;
  BaseUrls? get baseUrls => _baseUrls;
  String? get currencySymbol => _currencySymbol;
  double? get deliveryCharge => _deliveryCharge;
  bool? get cashOnDelivery => _cashOnDelivery;
  bool? get digitalPayment => _digitalPayment;
  List<Branches>? get branches => _branches;
  String? get termsAndConditions => _termsAndConditions;
  String? get aboutUs => _aboutUs;
  String? get privacyPolicy => _privacyPolicy;
  bool? get emailVerification => _emailVerification;
  bool? get phoneVerification => _phoneVerification;
  String? get currencySymbolPosition => _currencySymbolPosition;
  bool? get maintenanceMode => _maintenanceMode;
  String? get countryCode => _countryCode;
  DeliveryManagement? get deliveryManagement => _deliveryManagement;
  PlayStoreConfig? get playStoreConfig => _playStoreConfig;
  AppStoreConfig? get appStoreConfig => _appStoreConfig;
  List<SocialMediaLink>? get socialMediaLink => _socialMediaLink;
  String? get softwareVersion => _softwareVersion;
  String? get footerCopyright => _footerCopyright;
  int? get otpResendTime => _otpResendTime;
  CookiesManagement? get cookiesManagement => _cookiesManagement;
  SocialStatus? get socialLoginStatus => _socialLoginStatus;
  Whatsapp? get whatsapp => _whatsapp;
  Telegram? get telegram => _telegram;
  Messenger? get messenger => _messenger;
  List<CategoryModel>? get featuredCategory => _featuredCategory;
  List<PaymentMethod>? get activePaymentMethodList => _activePaymentMethodList;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _ecommerceName = json['ecommerce_name'];
    _appLogo = json['app_logo'];
    _ecommerceAddress = json['ecommerce_address'];
    _ecommercePhone = json['ecommerce_phone'];
    _ecommerceEmail = json['ecommerce_email'];
    _ecommerceLocationCoverage = json['ecommerce_location_coverage'] != null
        ? EcommerceLocationCoverage.fromJson(
            json['ecommerce_location_coverage'])
        : null;
    _minimumOrderValue = json['minimum_order_value'].toDouble();
    _selfPickup = json['self_pickup'];
    _baseUrls =
        json['base_urls'] != null ? BaseUrls.fromJson(json['base_urls']) : null;
    _currencySymbol = json['currency_symbol'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _cashOnDelivery = '${json['cash_on_delivery']}'.contains('true');
    _digitalPayment = '${json['digital_payment']}'.contains('true');
    if (json['branches'] != null) {
      _branches = [];
      json['branches'].forEach((v) {
        _branches!.add(Branches.fromJson(v));
      });
    }
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    _emailVerification = json['email_verification'];
    _phoneVerification = json['phone_verification'];
    _currencySymbolPosition = json['currency_symbol_position'];
    _maintenanceMode = json['maintenance_mode'];
    _countryCode = json['country'];
    _deliveryManagement = json['delivery_management'] != null
        ? DeliveryManagement.fromJson(json['delivery_management'])
        : null;
    _playStoreConfig = json['play_store_config'] != null
        ? PlayStoreConfig.fromJson(json['play_store_config'])
        : null;
    _appStoreConfig = json['app_store_config'] != null
        ? AppStoreConfig.fromJson(json['app_store_config'])
        : null;
    if (json['social_media_link'] != null) {
      _socialMediaLink = [];
      json['social_media_link'].forEach((v) {
        _socialMediaLink!.add(SocialMediaLink.fromJson(v));
      });
    }

    if (json['software_version'] != null && json['software_version'] != '') {
      _softwareVersion = json['software_version'];
    }
    if (json['footer_text'] != null) {
      _footerCopyright = json['footer_text'];
    }
    _otpResendTime = int.tryParse('${json['otp_resend_time']}');
    _cookiesManagement = json['cookies_management'] != null
        ? CookiesManagement.fromJson(json['cookies_management'])
        : null;

    if (json['social_login'] != null) {
      _socialLoginStatus = SocialStatus.fromJson(json['social_login']);
    }
    _telegram =
        json['telegram'] != null ? Telegram.fromJson(json['telegram']) : null;
    _messenger = json['messenger'] != null
        ? Messenger.fromJson(json['messenger'])
        : null;
    _whatsapp =
        json['whatsapp'] != null ? Whatsapp.fromJson(json['whatsapp']) : null;
    if (json['featured_category'] != null) {
      _featuredCategory = [];
      //todo need to add category
      // json['featured_category'].forEach((v) {
      //   _featuredCategory!.add(CategoryModel.fromJson(v));
      // });
    }

    if (json['active_payment_method_list'] != null) {
      _activePaymentMethodList = <PaymentMethod>[];
      json['active_payment_method_list'].forEach((v) {
        activePaymentMethodList!.add(PaymentMethod.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ecommerce_name'] = _ecommerceName;
    data['app_logo'] = _appLogo;
    data['ecommerce_address'] = _ecommerceAddress;
    data['ecommerce_phone'] = _ecommercePhone;
    data['ecommerce_email'] = _ecommerceEmail;
    if (_ecommerceLocationCoverage != null) {
      data['ecommerce_location_coverage'] =
          _ecommerceLocationCoverage!.toJson();
    }
    data['minimum_order_value'] = _minimumOrderValue;
    data['self_pickup'] = _selfPickup;
    if (_baseUrls != null) {
      data['base_urls'] = _baseUrls!.toJson();
    }
    data['currency_symbol'] = _currencySymbol;
    data['delivery_charge'] = _deliveryCharge;
    data['cash_on_delivery'] = _cashOnDelivery;
    data['digital_payment'] = _digitalPayment;
    if (_branches != null) {
      data['branches'] = _branches!.map((v) => v.toJson()).toList();
    }
    data['terms_and_conditions'] = _termsAndConditions;
    data['privacy_policy'] = privacyPolicy;
    data['about_us'] = aboutUs;
    data['email_verification'] = emailVerification;
    data['phone_verification'] = phoneVerification;
    data['currency_symbol_position'] = currencySymbolPosition;
    data['maintenance_mode'] = maintenanceMode;
    data['country'] = countryCode;
    if (_deliveryManagement != null) {
      data['delivery_management'] = _deliveryManagement!.toJson();
    }
    data['software_version'] = _softwareVersion;
    data['footer_text'] = _footerCopyright;
    data['otp_resend_time'] = _otpResendTime;
    if (_cookiesManagement != null) {
      data['cookies_management'] = _cookiesManagement!.toJson();
    }
    if (_whatsapp != null) {
      data['whatsapp'] = _whatsapp!.toJson();
    }

    return data;
  }
}

class EcommerceLocationCoverage {
  String? _longitude;
  String? _latitude;
  double? _coverage;

  EcommerceLocationCoverage(
      {String? longitude, String? latitude, double? coverage}) {
    _longitude = longitude;
    _latitude = latitude;
    _coverage = coverage;
  }

  String? get longitude => _longitude;
  String? get latitude => _latitude;
  double? get coverage => _coverage;

  EcommerceLocationCoverage.fromJson(Map<String, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['coverage'] = _coverage;
    return data;
  }
}

class PlayStoreConfig {
  bool? _status;
  String? _link;
  double? _minVersion;

  PlayStoreConfig({bool? status, String? link, double? minVersion}) {
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }
  bool? get status => _status;
  String? get link => _link;
  double? get minVersion => _minVersion;

  PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['link'] != null) {
      _link = json['link'];
    }
    if (json['min_version'] != null && json['min_version'] != '') {
      _minVersion = double.parse(json['min_version']);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class AppStoreConfig {
  bool? _status;
  String? _link;
  double? _minVersion;

  AppStoreConfig({bool? status, String? link, double? minVersion}) {
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }

  bool? get status => _status;
  String? get link => _link;
  double? get minVersion => _minVersion;

  AppStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['link'] != null) {
      _link = json['link'];
    }
    if (json['min_version'] != null && json['min_version'] != '') {
      _minVersion = double.parse(json['min_version']);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class SocialMediaLink {
  int? _id;
  String? _name;
  String? _link;
  int? _status;

  SocialMediaLink({int? id, String? name, String? link, int? status}) {
    _id = id;
    _name = name;
    _link = link;
    _status = status;
  }
  int? get id => _id;
  String? get name => _name;
  String? get link => _link;
  int? get status => _status;

  SocialMediaLink.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _link = json['link'];
    _status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['link'] = _link;
    data['status'] = _status;
    return data;
  }
}

class BaseUrls {
  String? _productImageUrl;
  String? _customerImageUrl;
  String? _bannerImageUrl;
  String? _reviewImageUrl;
  String? _notificationImageUrl;
  String? _ecommerceImageUrl;
  String? _deliveryManImageUrl;
  String? _chatImageUrl;
  String? _getWayImageUrl;

  BaseUrls({
    String? productImageUrl,
    String? customerImageUrl,
    String? bannerImageUrl,
    String? categoryImageUrl,
    String? reviewImageUrl,
    String? notificationImageUrl,
    String? ecommerceImageUrl,
    String? deliveryManImageUrl,
    String? chatImageUrl,
    String? categoryBanner,
    String? getWayImageUrl,
  }) {
    _productImageUrl = productImageUrl;
    _customerImageUrl = customerImageUrl;
    _bannerImageUrl = bannerImageUrl;
    _reviewImageUrl = reviewImageUrl;
    _notificationImageUrl = notificationImageUrl;
    _ecommerceImageUrl = ecommerceImageUrl;
    _deliveryManImageUrl = deliveryManImageUrl;
    _chatImageUrl = chatImageUrl;
    _getWayImageUrl = getWayImageUrl;
  }

  String? get productImageUrl => _productImageUrl;
  String? get customerImageUrl => _customerImageUrl;
  String? get bannerImageUrl => _bannerImageUrl;
  String? get reviewImageUrl => _reviewImageUrl;
  String? get notificationImageUrl => _notificationImageUrl;
  String? get ecommerceImageUrl => _ecommerceImageUrl;
  String? get deliveryManImageUrl => _deliveryManImageUrl;
  String? get chatImageUrl => _chatImageUrl;
  String? get getWayImageUrl => _getWayImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'];
    _customerImageUrl = json['customer_image_url'];
    _bannerImageUrl = json['banner_image_url'];
    _reviewImageUrl = json['review_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _ecommerceImageUrl = json['ecommerce_image_url'];
    _deliveryManImageUrl = json['delivery_man_image_url'];
    _chatImageUrl = json['chat_image_url'];
    _getWayImageUrl = json['gateway_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_url'] = _productImageUrl;
    data['customer_image_url'] = _customerImageUrl;
    data['banner_image_url'] = _bannerImageUrl;
    data['review_image_url'] = _reviewImageUrl;
    data['notification_image_url'] = _notificationImageUrl;
    data['ecommerce_image_url'] = _ecommerceImageUrl;
    data['delivery_man_image_url'] = _deliveryManImageUrl;
    data['chat_image_url'] = _chatImageUrl;
    return data;
  }
}

class Branches {
  int? _id;
  String? _name;
  String? _email;
  String? _longitude;
  String? _latitude;
  String? _address;
  double? _coverage;

  Branches(
      {int? id,
      String? name,
      String? email,
      String? longitude,
      String? latitude,
      String? address,
      double? coverage}) {
    _id = id;
    _name = name;
    _email = email;
    _longitude = longitude;
    _latitude = latitude;
    _address = address;
    _coverage = coverage;
  }

  int? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get address => _address;
  double? get coverage => _coverage;

  Branches.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _address = json['address'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['email'] = _email;
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['address'] = _address;
    data['coverage'] = _coverage;
    return data;
  }
}

class DeliveryManagement {
  bool? _status;
  double? _minShippingCharge;
  double? _shippingPerKm;

  DeliveryManagement(
      {bool? status, double? minShippingCharge, double? shippingPerKm}) {
    _status = status;
    _minShippingCharge = minShippingCharge;
    _shippingPerKm = shippingPerKm;
  }

  bool? get status => _status;
  double? get minShippingCharge => _minShippingCharge;
  double? get shippingPerKm => _shippingPerKm;

  DeliveryManagement.fromJson(Map<String, dynamic> json) {
    _status = '${json['status']}'.contains('1');
    _minShippingCharge = json['min_shipping_charge'].toDouble();
    _shippingPerKm = json['shipping_per_km'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['min_shipping_charge'] = _minShippingCharge;
    data['shipping_per_km'] = _shippingPerKm;
    return data;
  }
}

class CookiesManagement {
  bool? status;
  String? content;

  CookiesManagement({this.status, this.content});

  CookiesManagement.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    content = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['text'] = content;
    return data;
  }
}

class SocialStatus {
  bool? isGoogle;
  bool? isFacebook;

  SocialStatus(this.isGoogle, this.isFacebook);

  SocialStatus.fromJson(Map<String, dynamic> json) {
    isGoogle = '${json['google']}' == '1';
    isFacebook = '${json['facebook']}' == '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google'] = isGoogle;
    data['facebook'] = isFacebook;
    return data;
  }
}

class Whatsapp {
  bool? status;
  String? number;

  Whatsapp({this.status, this.number});

  Whatsapp.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['number'] = number;
    return data;
  }
}

class Telegram {
  bool? status;
  String? userName;

  Telegram({this.status, this.userName});

  Telegram.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_name'] = userName;
    return data;
  }
}

class Messenger {
  bool? status;
  String? userName;

  Messenger({this.status, this.userName});

  Messenger.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_name'] = userName;
    return data;
  }
}

class FeaturedCategory {
  int? id;
  String? name;
  String? image;
  String? bannerImage;

  FeaturedCategory({this.id, this.name, this.image, this.bannerImage});

  FeaturedCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    bannerImage = json['banner_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['banner_image'] = bannerImage;

    return data;
  }
}

class PaymentMethod {
  String? getWay;
  String? getWayTitle;
  String? getWayImage;
  String? type;

  PaymentMethod({this.getWay, this.getWayTitle, this.getWayImage, this.type});

  PaymentMethod copyWith(String type) {
    this.type = type;
    return this;
  }

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    getWay = json['gateway'];
    getWayTitle = json['gateway_title'];
    getWayImage = json['gateway_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gateway'] = getWay;
    data['gateway_title'] = getWayTitle;
    data['gateway_image'] = getWayImage;
    return data;
  }
}
