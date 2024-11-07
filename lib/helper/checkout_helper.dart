import 'package:zohbi_user/common/models/address_model.dart';
import 'package:zohbi_user/common/models/config_model.dart';
import 'package:zohbi_user/features/checkout/providers/checkout_provider.dart';
import 'package:zohbi_user/features/checkout/widgets/delivery_fee_dialog_widget.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/features/address/providers/address_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/common/widgets/custom_loader_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckOutHelper {
  static AddressModel? getDeliveryAddress({
    required List<AddressModel?>? addressList,
    required AddressModel? selectedAddress,
    required AddressModel? lastOrderAddress,
  }) {
    AddressModel? deliveryAddress;
    if (selectedAddress != null) {
      deliveryAddress = selectedAddress;
    } else if (lastOrderAddress != null) {
      deliveryAddress = lastOrderAddress;
    } else if (addressList != null && addressList.isNotEmpty) {
      deliveryAddress = addressList.first;
    }

    return deliveryAddress;
  }

  static bool isBranchAvailable(
      {required List<Branches> branches,
      required Branches selectedBranch,
      required AddressModel selectedAddress}) {
    bool isAvailable = branches.length == 1 &&
        (branches[0].latitude == null || branches[0].latitude!.isEmpty);

    if (!isAvailable) {
      double distance = Geolocator.distanceBetween(
            double.parse(selectedBranch.latitude!),
            double.parse(selectedBranch.longitude!),
            double.parse(selectedAddress.latitude!),
            double.parse(selectedAddress.longitude!),
          ) /
          1000;

      isAvailable = distance < selectedBranch.coverage!;
    }

    return isAvailable;
  }

  static bool isKmWiseCharge({required ConfigModel? configModel}) =>
      configModel != null && configModel.deliveryManagement!.status!;

  static Future<void> selectDeliveryAddress({
    required bool isAvailable,
    required int index,
    required ConfigModel configModel,
    required AddressProvider locationProvider,
    required CheckoutProvider checkoutProvider,
    required bool fromAddressList,
  }) async {
    if (isAvailable) {
      locationProvider.updateAddressIndex(index, fromAddressList);
      checkoutProvider.setOrderAddressIndex(index, notify: false);

      if (CheckOutHelper.isKmWiseCharge(configModel: configModel)) {
        if (fromAddressList) {
          if (checkoutProvider.selectedPaymentMethod != null) {
            showCustomSnackBar(
                getTranslated('your_payment_method_has_been', Get.context!),
                Get.context!,
                isError: false);
          }
          checkoutProvider.savePaymentMethod(index: null, method: null);
        }
        showDialog(
            context: Get.context!,
            builder: (context) => Center(
                    child: Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      CustomLoaderWidget(color: Theme.of(context).primaryColor),
                )),
            barrierDismissible: false);

        bool isSuccess = await checkoutProvider.getDistanceInMeter(
          LatLng(
            double.parse(
                configModel.branches![checkoutProvider.branchIndex].latitude!),
            double.parse(
                configModel.branches![checkoutProvider.branchIndex].longitude!),
          ),
          LatLng(
            double.parse(locationProvider.addressList![index].latitude!),
            double.parse(locationProvider.addressList![index].longitude!),
          ),
        );

        Navigator.pop(Get.context!);

        if (fromAddressList) {
          await showDialog(
              context: Get.context!,
              builder: (context) => DeliveryFeeDialogWidget(
                    freeDelivery:
                        checkoutProvider.getCheckOutData?.freeDeliveryType ==
                            'free_delivery',
                    amount: checkoutProvider.getCheckOutData?.amount ?? 0,
                    distance: checkoutProvider.distance,
                    callBack: (deliveryCharge) {
                      checkoutProvider.getCheckOutData
                          ?.copyWith(deliveryCharge: deliveryCharge);
                    },
                  ));
        } else {
          checkoutProvider.getCheckOutData?.copyWith(
              deliveryCharge: CheckOutHelper.getDeliveryCharge(
            freeDeliveryType:
                checkoutProvider.getCheckOutData?.freeDeliveryType,
            orderAmount: checkoutProvider.getCheckOutData?.amount ?? 0,
            distance: checkoutProvider.distance,
            discount: checkoutProvider.getCheckOutData?.placeOrderDiscount ?? 0,
            configModel: configModel,
          ));
        }

        if (!isSuccess) {
          showCustomSnackBar(
              getTranslated('failed_to_fetch_distance', Get.context!),
              Get.context!);
        }
      }
    } else {
      showCustomSnackBar(
          getTranslated('out_of_coverage_for_this_branch', Get.context!),
          Get.context!);
    }
  }

  static double getDeliveryCharge({
    required double orderAmount,
    required double distance,
    required double discount,
    required String? freeDeliveryType,
    required ConfigModel configModel,
  }) {
    final deliveryManagement = configModel.deliveryManagement;

    double deliveryCharge = distance * (deliveryManagement?.shippingPerKm ?? 0);

    if (deliveryCharge < (deliveryManagement?.minShippingCharge ?? 0)) {
      deliveryCharge = deliveryManagement?.minShippingCharge ?? 0;
    }

    final isDeliveryDisabled =
        !(deliveryManagement?.status ?? false) || distance == -1;

    if (isDeliveryDisabled || freeDeliveryType == 'free_delivery') {
      deliveryCharge = 0;
    }

    return deliveryCharge;
  }

  static selectDeliveryAddressAuto(
      {AddressModel? lastAddress,
      required bool isLoggedIn,
      required String? orderType}) async {
    final AddressProvider locationProvider =
        Provider.of<AddressProvider>(Get.context!, listen: false);
    final CheckoutProvider checkoutProvider =
        Provider.of<CheckoutProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(Get.context!, listen: false);

    AddressModel? deliveryAddress = CheckOutHelper.getDeliveryAddress(
      addressList: locationProvider.addressList,
      selectedAddress: checkoutProvider.orderAddressIndex == -1
          ? null
          : locationProvider.addressList?[checkoutProvider.orderAddressIndex],
      lastOrderAddress: lastAddress,
    );

    if (isLoggedIn &&
        orderType == 'delivery' &&
        deliveryAddress != null &&
        locationProvider.getAddressIndex(deliveryAddress) != null) {
      await CheckOutHelper.selectDeliveryAddress(
        isAvailable: true,
        index: locationProvider.getAddressIndex(deliveryAddress)!,
        configModel: splashProvider.configModel!,
        locationProvider: locationProvider,
        checkoutProvider: checkoutProvider,
        fromAddressList: false,
      );
    }
  }

  static bool isSelfPickup({required String? orderType}) =>
      orderType == 'self_pickup';
}
