import 'package:zohbi_user/common/models/address_model.dart';
import 'package:zohbi_user/common/widgets/custom_asset_image_widget.dart';
import 'package:zohbi_user/features/address/providers/address_provider.dart';
import 'package:zohbi_user/features/address/providers/location_provider.dart';
import 'package:zohbi_user/features/address/screens/select_location_screen.dart';
import 'package:zohbi_user/features/address/widgets/location_permission_dialog_widget.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/utill/color_resources.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddressMapWidget extends StatefulWidget {
  final bool isUpdateEnable;
  final bool fromCheckout;
  final AddressModel? address;
  final TextEditingController locationTextController;

  const AddressMapWidget({
    Key? key,
    required this.isUpdateEnable,
    required this.address,
    required this.fromCheckout,
    required this.locationTextController,
  }) : super(key: key);

  @override
  State<AddressMapWidget> createState() => _AddressMapWidgetState();
}

class _AddressMapWidgetState extends State<AddressMapWidget> {
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  late LatLng _initialPosition;
  bool _updateAddress = true;

  @override
  void initState() {
    super.initState();

    if (widget.address != null) {
      _initialPosition = LatLng(double.parse(widget.address!.latitude!),
          double.parse(widget.address!.longitude!));
    } else {
      _initialPosition = LatLng(
        double.parse(Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .branches![0]
                .latitude ??
            '0'),
        double.parse(Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .branches![0]
                .longitude ??
            '0'),
      );
    }

    if (widget.isUpdateEnable && widget.address != null) {
      _updateAddress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10)
              ],
            )
          : const BoxDecoration(),
      padding: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeLarge,
            )
          : EdgeInsets.zero,
      child: Consumer<AddressProvider>(builder: (context, addressProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<LocationProvider>(builder: (context, locationProvider, _) {
              return SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 130 : 250,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeSmall),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GoogleMap(
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: widget.isUpdateEnable
                              ? LatLng(
                                  double.parse(widget.address?.latitude ??
                                      locationProvider.currentPosition.latitude
                                          .toString()),
                                  double.parse(widget.address?.longitude ??
                                      locationProvider.currentPosition.longitude
                                          .toString()),
                                )
                              : _initialPosition,
                          zoom: 16,
                        ),
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        onCameraIdle: () => _onCameraIdle(locationProvider),
                        onCameraMove: ((position) =>
                            _cameraPosition = position),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          if (!widget.isUpdateEnable && _controller != null) {
                            _checkPermission(() {
                              locationProvider.getCurrentLocation(context, true,
                                  mapController: _controller);
                            });
                          }
                        },
                      ),
                      if (locationProvider.isLoading)
                        Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        child: const CustomAssetImageWidget(Images.marker,
                            width: 25, height: 35),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 0,
                        child: InkWell(
                          onTap: () => _checkPermission(() {
                            locationProvider.getCurrentLocation(context, true,
                                mapController: _controller);
                          }),
                          child: Container(
                            width:
                                ResponsiveHelper.isDesktop(context) ? 40 : 30,
                            height:
                                ResponsiveHelper.isDesktop(context) ? 40 : 30,
                            margin: const EdgeInsets.only(
                                right: Dimensions.paddingSizeLarge),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.my_location,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.getSelectLocationRoute(),
                              arguments: SelectLocationScreen(
                                  googleMapController: _controller),
                            );
                          },
                          child: Container(
                            width:
                                ResponsiveHelper.isDesktop(context) ? 40 : 30,
                            height:
                                ResponsiveHelper.isDesktop(context) ? 40 : 30,
                            margin: const EdgeInsets.only(
                                right: Dimensions.paddingSizeLarge),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.fullscreen,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                  child: Text(
                getTranslated('add_the_location_correctly', context),
                style: rubikMedium.copyWith(
                    color: ColorResources.getGreyBunkerColor(context),
                    fontSize: Dimensions.fontSizeSmall),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                getTranslated('label_as', context),
                style: rubikRegular.copyWith(
                    color: ColorResources.getGreyBunkerColor(context),
                    fontSize: Dimensions.fontSizeLarge),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: addressProvider.getAllAddressType.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => addressProvider.updateAddressIndex(index, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                        horizontal: Dimensions.paddingSizeLarge),
                    margin: const EdgeInsets.only(right: 17),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.paddingSizeSmall),
                      border: Border.all(
                        color: addressProvider.selectAddressIndex == index
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor.withOpacity(0.5),
                      ),
                      color: addressProvider.selectAddressIndex == index
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                    child: Text(
                      getTranslated(
                          addressProvider.getAllAddressType[index]
                              .toLowerCase(),
                          context),
                      style: rubikMedium.copyWith(
                        color: addressProvider.selectAddressIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      widget.locationTextController.clear();
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => const LocationPermissionDialogWidget());
    } else {
      callback();
    }
  }

  void _onCameraIdle(LocationProvider locationProvider) {
    if (widget.address != null && !widget.fromCheckout) {
      locationProvider.updatePosition(_cameraPosition, true, null, true);
      _updateAddress = true;
    } else {
      if (_updateAddress) {
        locationProvider.updatePosition(_cameraPosition, true, null, true);
      } else {
        _updateAddress = true;
      }
    }
  }
}
