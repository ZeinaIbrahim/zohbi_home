import 'package:zohbi_user/common/enums/footer_type_enum.dart';
import 'package:zohbi_user/common/models/address_model.dart';
import 'package:zohbi_user/common/widgets/custom_app_bar_widget.dart';
import 'package:zohbi_user/common/widgets/custom_web_title_widget.dart';
import 'package:zohbi_user/common/widgets/footer_web_widget.dart';
import 'package:zohbi_user/features/address/providers/address_provider.dart';
import 'package:zohbi_user/features/address/providers/location_provider.dart';
import 'package:zohbi_user/features/address/widgets/address_button_widget.dart';
import 'package:zohbi_user/features/address/widgets/address_details_widget.dart';
import 'package:zohbi_user/features/address/widgets/address_map_widget.dart';
import 'package:zohbi_user/features/profile/providers/profile_provider.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isUpdateEnable;
  final bool fromCheckout;
  final AddressModel? address;
  const AddNewAddressScreen(
      {Key? key,
      this.isUpdateEnable = true,
      this.address,
      this.fromCheckout = false})
      : super(key: key);

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController =
      TextEditingController();
  final TextEditingController _contactPersonNumberController =
      TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _florNumberController = TextEditingController();

  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initLoading();

    if (widget.address != null && !widget.fromCheckout) {
      _locationTextController.text = widget.address!.address!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBarWidget(
          title: widget.isUpdateEnable
              ? getTranslated('update_address', context)
              : getTranslated('add_new_address', context)),
      body: Consumer<AddressProvider>(
        builder: (context, locationProvider, child) {
          return Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight:
                        !ResponsiveHelper.isDesktop(context) && height < 600
                            ? height
                            : height - 400),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Center(
                      child: SizedBox(
                          width: Dimensions.webScreenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWebTitleWidget(
                                  title: getTranslated(
                                      widget.isUpdateEnable
                                          ? 'update_address'
                                          : 'add_new_address',
                                      context)),

                              if (!ResponsiveHelper.isDesktop(context))
                                AddressMapWidget(
                                  isUpdateEnable: widget.isUpdateEnable,
                                  address: widget.address,
                                  fromCheckout: widget.fromCheckout,
                                  locationTextController:
                                      _locationTextController,
                                ),

                              // for label us
                              if (!ResponsiveHelper.isDesktop(context))
                                AddressDetailsWidget(
                                  contactPersonNameController:
                                      _contactPersonNameController,
                                  contactPersonNumberController:
                                      _contactPersonNumberController,
                                  addressNode: _addressNode,
                                  nameNode: _nameNode,
                                  numberNode: _numberNode,
                                  fromCheckout: widget.fromCheckout,
                                  address: widget.address,
                                  isUpdateEnable: widget.isUpdateEnable,
                                  locationTextController:
                                      _locationTextController,
                                  streetNumberController:
                                      _streetNumberController,
                                  houseNumberController: _houseNumberController,
                                  houseNode: _houseNode,
                                  stateNode: _stateNode,
                                  florNumberController: _florNumberController,
                                  florNode: _floorNode,
                                ),

                              if (ResponsiveHelper.isDesktop(context))
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 6,
                                        child: AddressMapWidget(
                                          isUpdateEnable: widget.isUpdateEnable,
                                          address: widget.address,
                                          fromCheckout: widget.fromCheckout,
                                          locationTextController:
                                              _locationTextController,
                                        )),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeDefault),
                                    Expanded(
                                      flex: 4,
                                      child: AddressDetailsWidget(
                                        contactPersonNameController:
                                            _contactPersonNameController,
                                        contactPersonNumberController:
                                            _contactPersonNumberController,
                                        addressNode: _addressNode,
                                        nameNode: _nameNode,
                                        numberNode: _numberNode,
                                        isUpdateEnable: widget.isUpdateEnable,
                                        address: widget.address,
                                        fromCheckout: widget.fromCheckout,
                                        locationTextController:
                                            _locationTextController,
                                        streetNumberController:
                                            _streetNumberController,
                                        houseNumberController:
                                            _houseNumberController,
                                        houseNode: _houseNode,
                                        stateNode: _stateNode,
                                        florNumberController:
                                            _florNumberController,
                                        florNode: _floorNode,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ))),
                ),
              ),
              const FooterWebWidget(footerType: FooterType.nonSliver),
            ]))),
            if (!ResponsiveHelper.isDesktop(context))
              AddressButtonWidget(
                isUpdateEnable: widget.isUpdateEnable,
                fromCheckout: widget.fromCheckout,
                contactPersonNumberController: _contactPersonNumberController,
                contactPersonNameController: _contactPersonNameController,
                address: widget.address,
                location: _locationTextController.text,
                streetNumberController: _streetNumberController,
                houseNumberController: _houseNumberController,
                floorNumberController: _florNumberController,
              ),
          ]);
        },
      ),
    );
  }

  void _initLoading() async {
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final AddressProvider addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final userModel =
        Provider.of<ProfileProvider>(context, listen: false).userInfoModel;

    if (widget.address == null) {
      locationProvider.setLocationData(false);
    }

    await addressProvider.initializeAllAddressType(context: context);
    addressProvider.setAddressStatusMessage = '';
    addressProvider.setErrorMessage = '';

    if (widget.isUpdateEnable && widget.address != null) {
      locationProvider.updatePosition(
          CameraPosition(
              target: LatLng(double.parse(widget.address!.latitude!),
                  double.parse(widget.address!.longitude!))),
          true,
          widget.address!.address,
          false);

      _contactPersonNameController.text =
          '${widget.address!.contactPersonName}';
      _contactPersonNumberController.text =
          '${widget.address!.contactPersonNumber}';
      _streetNumberController.text = widget.address!.streetNumber ?? '';
      _houseNumberController.text = widget.address!.houseNumber ?? '';
      _florNumberController.text = widget.address!.floorNumber ?? '';

      if (widget.address!.addressType == 'Home') {
        addressProvider.updateAddressIndex(0, false);
      } else if (widget.address!.addressType == 'Workplace') {
        addressProvider.updateAddressIndex(1, false);
      } else {
        addressProvider.updateAddressIndex(2, false);
      }
    } else {
      _contactPersonNameController.text = '${userModel!.fName ?? ''}'
          ' ${userModel.lName ?? ''}';
      _contactPersonNumberController.text = userModel.phone ?? '';
      _streetNumberController.text = widget.address!.streetNumber ?? '';
      _houseNumberController.text = widget.address!.houseNumber ?? '';
      _florNumberController.text = widget.address!.floorNumber ?? '';
    }
  }
}
