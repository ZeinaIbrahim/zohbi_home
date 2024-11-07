import 'package:zohbi_user/common/models/address_model.dart';
import 'package:zohbi_user/common/models/config_model.dart';
import 'package:zohbi_user/features/address/providers/location_provider.dart';
import 'package:zohbi_user/features/checkout/providers/checkout_provider.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/features/address/providers/address_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AddressButtonWidget extends StatelessWidget {
  final bool isUpdateEnable;
  final bool fromCheckout;
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController floorNumberController;
  final AddressModel? address;
  final String location;

  const AddressButtonWidget({
    Key? key,
    required this.isUpdateEnable,
    required this.fromCheckout,
    required this.contactPersonNumberController,
    required this.contactPersonNameController,
    required this.streetNumberController,
    required this.floorNumberController,
    required this.houseNumberController,
    required this.address,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(builder: (context, addressProvider, _) {
      return Column(
        children: [
          addressProvider.addressStatusMessage != null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addressProvider.addressStatusMessage!.isNotEmpty
                        ? const CircleAvatar(
                            backgroundColor: Colors.green, radius: 5)
                        : const SizedBox.shrink(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        addressProvider.addressStatusMessage ?? "",
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Colors.green,
                            height: 1),
                      ),
                    )
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addressProvider.errorMessage!.isNotEmpty
                        ? const CircleAvatar(
                            backgroundColor: Colors.red, radius: 5)
                        : const SizedBox.shrink(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        addressProvider.errorMessage ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Colors.red,
                                height: 1),
                      ),
                    )
                  ],
                ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Container(
            height: 50.0,
            width: Dimensions.webScreenWidth,
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
              return CustomButtonWidget(
                isLoading: addressProvider.isLoading,
                btnTxt: isUpdateEnable
                    ? getTranslated('update_address', context)
                    : getTranslated('save_location', context),
                onTap: locationProvider.isLoading
                    ? null
                    : () async => _onPressAction(locationProvider, context),
              );
            }),
          )
        ],
      );
    });
  }

  Future<void> _onPressAction(
      LocationProvider locationProvider, BuildContext context) async {
    final AddressProvider addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final CheckoutProvider checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);
    List<Branches> branches =
        Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .branches!;
    bool isAvailable = branches.length == 1 &&
        (branches[0].latitude == null || branches[0].latitude!.isEmpty);

    if (!isAvailable) {
      for (Branches branch in branches) {
        double distance = Geolocator.distanceBetween(
              double.parse(branch.latitude!),
              double.parse(branch.longitude!),
              locationProvider.currentPosition.latitude,
              locationProvider.currentPosition.longitude,
            ) /
            1000;

        if (distance < branch.coverage!) {
          isAvailable = true;
          break;
        }
      }
    }
    if (!isAvailable) {
      showCustomSnackBar(
          getTranslated('service_is_not_available', context), context);
    } else {
      AddressModel addressModel = AddressModel(
        addressType: addressProvider
            .getAllAddressType[addressProvider.selectAddressIndex],
        contactPersonName: contactPersonNameController.text,
        contactPersonNumber: contactPersonNumberController.text,
        address: location,
        latitude: isUpdateEnable
            ? locationProvider.currentPosition.latitude.toString()
            : locationProvider.currentPosition.latitude.toString(),
        longitude: locationProvider.currentPosition.longitude.toString(),
        floorNumber: floorNumberController.text,
        houseNumber: houseNumberController.text,
        streetNumber: streetNumberController.text,
      );

      if (isUpdateEnable) {
        addressModel.id = address?.id;
        addressModel.userId = address?.userId;
        addressModel.method = 'put';

        await addressProvider.updateAddress(context,
            addressModel: addressModel, addressId: addressModel.id);
      } else {
        await addressProvider.addAddress(addressModel, context).then((value) {
          if (value.isSuccess) {
            if (fromCheckout) {
              addressProvider.initAddressList();
              checkoutProvider.setOrderAddressIndex(-1);
            }

            Navigator.pop(context);
            showCustomSnackBar(value.message, context, isError: false);
          } else {
            showCustomSnackBar(value.message, context);
          }
        });
      }
    }
  }
}
