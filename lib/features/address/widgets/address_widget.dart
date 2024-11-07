import 'package:zohbi_user/common/models/address_model.dart';
import 'package:zohbi_user/common/models/config_model.dart';
import 'package:zohbi_user/common/widgets/custom_loader_widget.dart';
import 'package:zohbi_user/features/checkout/providers/checkout_provider.dart';
import 'package:zohbi_user/helper/checkout_helper.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/features/address/providers/address_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_alert_dialog_widget.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel addressModel;
  final int index;
  final bool fromSelectAddress;
  const AddressWidget(
      {Key? key,
      required this.addressModel,
      required this.index,
      this.fromSelectAddress = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddressProvider addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final CheckoutProvider checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: () async {
          if (fromSelectAddress) {
            bool isAvailable = CheckOutHelper.isBranchAvailable(
              branches: configModel.branches ?? [],
              selectedBranch:
                  configModel.branches![checkoutProvider.branchIndex],
              selectedAddress: addressProvider.addressList![index],
            );

            CheckOutHelper.selectDeliveryAddress(
              isAvailable: isAvailable,
              index: index,
              configModel: configModel,
              locationProvider: addressProvider,
              checkoutProvider: checkoutProvider,
              fromAddressList: true,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            border: fromSelectAddress &&
                    index == addressProvider.selectAddressIndex
                ? Border.all(width: 1, color: Theme.of(context).primaryColor)
                : null,
            borderRadius: BorderRadius.circular(7),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 0.5,
                  blurRadius: 0.5)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fromSelectAddress
                          ? Radio(
                              activeColor: Theme.of(context).primaryColor,
                              value: index,
                              groupValue: addressProvider.selectAddressIndex,
                              onChanged: (_) {},
                            )
                          : Icon(Icons.location_on,
                              color: Theme.of(context).primaryColor, size: 25),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(addressModel.addressType!,
                              style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              )),
                          Text(addressModel.address!,
                              maxLines: fromSelectAddress ? 1 : 3,
                              style: rubikRegular.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withOpacity(0.6),
                                fontSize: Dimensions.fontSizeLarge,
                              )),
                        ],
                      ))
                    ],
                  )),
              if (!fromSelectAddress)
                PopupMenuButton<String>(
                  padding: const EdgeInsets.all(0),
                  onSelected: (String result) {
                    if (result == 'delete') {
                      ResponsiveHelper.showDialogOrBottomSheet(
                          context,
                          CustomAlertDialogWidget(
                            title:
                                getTranslated('remove_this_address', context),
                            subTitle: getTranslated(
                                'address_will_be_remove_from_list', context),
                            image: Images.locationDeleteIcon,
                            onPressRight: () {
                              Navigator.pop(context);

                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                        child: CustomLoaderWidget(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ));

                              addressProvider
                                  .deleteUserAddressByID(addressModel.id, index,
                                      (bool isSuccessful, String message) {
                                Navigator.pop(context);
                                showCustomSnackBar(message, context,
                                    isError: isSuccessful);
                              });
                            },
                          ));
                    } else {
                      addressProvider.setAddressStatusMessage = '';
                      Navigator.pushNamed(
                          context,
                          Routes.getAddAddressRoute(
                              'address', 'update', addressModel));
                    }
                  },
                  itemBuilder: (BuildContext c) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text(getTranslated('edit', context),
                          style: rubikMedium),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text(getTranslated('delete', context),
                          style: rubikMedium),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
