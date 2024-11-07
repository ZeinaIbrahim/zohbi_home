import 'package:audioplayers/audioplayers.dart';
import 'package:zohbi_user/features/notification/domain/models/payload_model.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/common/widgets/custom_directionality_widget.dart';
import 'package:zohbi_user/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';

class NotificationPopUpDialogWidget extends StatefulWidget {
  final PayloadModel payloadModel;
  const NotificationPopUpDialogWidget(this.payloadModel, {Key? key})
      : super(key: key);

  @override
  State<NotificationPopUpDialogWidget> createState() =>
      _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NotificationPopUpDialogWidget> {
  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  void _startAlarm() async {
    AudioPlayer audio = AudioPlayer();
    audio.play(AssetSource('notification.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
      //insetPadding: EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.notifications_active,
              size: 60, color: Theme.of(context).primaryColor),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge),
            child: CustomDirectionalityWidget(
                child: Text(
              '${widget.payloadModel.title} ${widget.payloadModel.orderId != '' ? '(${widget.payloadModel.orderId})' : ''}',
              textAlign: TextAlign.center,
              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                Text(
                  widget.payloadModel.body!,
                  textAlign: TextAlign.center,
                  style:
                      rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                if (widget.payloadModel.image != 'null')
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                  ),
                if (widget.payloadModel.image != 'null')
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSizeDefault)),
                            child: Container(
                              width: 700,
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraLarge),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        icon: const Icon(Icons.close),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CustomImageWidget(
                                        image: widget.payloadModel.image!,
                                        width: 700,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CustomImageWidget(
                        image: widget.payloadModel.image!,
                        height: 200,
                        width: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
              child: SizedBox(
                width: 120,
                height: 40,
                child: CustomButtonWidget(
                  backgroundColor:
                      Theme.of(context).disabledColor.withOpacity(0.3),
                  btnTxt: getTranslated('cancel', context),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            const SizedBox(width: 20),
            if (widget.payloadModel.orderId != null ||
                widget.payloadModel.type == 'message')
              Flexible(
                child: SizedBox(
                  width: 120,
                  height: 40,
                  child: CustomButtonWidget(
                    // textColor: Colors.white,
                    btnTxt: getTranslated('go', context),
                    onTap: () {
                      Navigator.pop(context);

                      try {
                        if (widget.payloadModel.type == 'general' &&
                            widget.payloadModel.orderId == '') {
                          Navigator.pushNamed(
                              context, Routes.getNotificationRoute());
                        } else if (widget.payloadModel.type == 'message' &&
                            widget.payloadModel.orderId == '') {
                          Navigator.pushNamed(
                              context, Routes.getChatRoute(orderModel: null));
                        } else {
                          Navigator.pushNamed(
                              context,
                              Routes.getOrderDetailsRoute(
                                  int.tryParse(widget.payloadModel.orderId!)));
                        }
                      } catch (e) {
                        debugPrint('error ===> $e');
                      }
                    },
                  ),
                ),
              ),
          ]),
        ]),
      ),
    );
  }
}
