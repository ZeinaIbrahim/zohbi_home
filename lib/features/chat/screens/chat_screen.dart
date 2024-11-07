import 'dart:io';
import 'package:zohbi_user/common/models/order_model.dart';
import 'package:zohbi_user/common/widgets/custom_app_bar_widget.dart';
import 'package:zohbi_user/features/chat/widgets/message_bubble_widget.dart';
import 'package:zohbi_user/features/chat/widgets/message_bubble_shimmer_widget.dart';
import 'package:zohbi_user/helper/responsive_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/features/auth/providers/auth_provider.dart';
import 'package:zohbi_user/features/chat/providers/chat_provider.dart';
import 'package:zohbi_user/features/profile/providers/profile_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/images.dart';
import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/common/widgets/not_logged_in_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel? orderModel;
  const ChatScreen({Key? key, required this.orderModel}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputMessageController = TextEditingController();
  late bool _isLoggedIn;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        Provider.of<ChatProvider>(context, listen: false)
            .getMessages(1, widget.orderModel?.id, false);
      });
    }
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if (_isLoggedIn) {
      if (_isFirst) {
        Provider.of<ChatProvider>(context, listen: false)
            .getMessages(1, widget.orderModel?.id, true);
      } else {
        Provider.of<ChatProvider>(context, listen: false)
            .getMessages(1, widget.orderModel?.id, false);
        _isFirst = false;
      }
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    final bool isAdmin = widget.orderModel == null;
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const CustomAppBarWidget()
          : AppBar(
              title: Text(
                isAdmin
                    ? '${splashProvider.configModel?.ecommerceName}'
                    : '${widget.orderModel?.deliveryMan?.fName} ${widget.orderModel?.deliveryMan?.lName}',
                style: rubikMedium.copyWith(
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              leading: BackButton(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              width: 2, color: Theme.of(context).cardColor),
                          color: Theme.of(context).cardColor),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: isAdmin ? Images.logo : Images.profile,
                          image: isAdmin
                              ? ''
                              : '${splashProvider.baseUrls!.deliveryManImageUrl}/${widget.orderModel!.deliveryMan!.image}',
                          imageErrorBuilder: (c, t, o) => Image.asset(
                              isAdmin ? Images.logo : Images.profile),
                        ),
                      ),
                    ),
                  )
                ]),
      body: _isLoggedIn
          ? Center(
              child: SizedBox(
                width: ResponsiveHelper.isDesktop(context)
                    ? 1170
                    : MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Consumer<ChatProvider>(
                        builder: (context, chatProvider, child) {
                      return chatProvider.messageList == null
                          ? Expanded(
                              child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: 24,
                              itemBuilder: (context, index) =>
                                  MessageBubbleShimmerWidget(isMe: index.isOdd),
                            ))
                          : Expanded(
                              child: ListView.builder(
                                  reverse: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: chatProvider.messageList!.length,
                                  itemBuilder: (context, index) {
                                    return MessageBubbleWidget(
                                        messages:
                                            chatProvider.messageList![index],
                                        isAdmin: isAdmin);
                                  }),
                            );
                    }),
                    Container(
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                          Consumer<ChatProvider>(
                              builder: (context, chatProvider, _) {
                            return chatProvider.chatImage!.isNotEmpty
                                ? SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: chatProvider.chatImage!.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return chatProvider
                                                .chatImage!.isNotEmpty
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    Dimensions
                                                                        .paddingSizeDefault)),
                                                        child: ResponsiveHelper
                                                                .isWeb()
                                                            ? Image.network(
                                                                chatProvider
                                                                    .chatImage![
                                                                        index]
                                                                    .path,
                                                                width: 100,
                                                                height: 100,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.file(
                                                                File(chatProvider
                                                                    .chatImage![
                                                                        index]
                                                                    .path),
                                                                width: 100,
                                                                height: 100,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: InkWell(
                                                        onTap: () =>
                                                            chatProvider
                                                                .removeImage(
                                                                    index),
                                                        child: Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                        Dimensions
                                                                            .paddingSizeDefault))),
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Icon(
                                                                Icons.clear,
                                                                color:
                                                                    Colors.red,
                                                                size: 15,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox();
                                      },
                                    ),
                                  )
                                : const SizedBox();
                          }),
                          Row(children: [
                            InkWell(
                              onTap: () async {
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .pickImage(false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                                child: Image.asset(Images.image,
                                    width: 25,
                                    height: 25,
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              child: VerticalDivider(
                                  width: 0,
                                  thickness: 1,
                                  color: Theme.of(context).hintColor),
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeDefault),
                            Expanded(
                              child: TextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      Dimensions.messageInputLength)
                                ],
                                controller: _inputMessageController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: rubikRegular,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: getTranslated('type_here', context),
                                  hintStyle: rubikRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: Dimensions.fontSizeLarge),
                                ),
                                onSubmitted: (String newText) {
                                  if (newText.trim().isNotEmpty &&
                                      !Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .isSendButtonActive) {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .toggleSendButtonActivity();
                                  } else if (newText.isEmpty &&
                                      Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .isSendButtonActive) {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .toggleSendButtonActivity();
                                  }
                                },
                                onChanged: (String newText) {
                                  if (newText.trim().isNotEmpty &&
                                      !Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .isSendButtonActive) {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .toggleSendButtonActivity();
                                  } else if (newText.isEmpty &&
                                      Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .isSendButtonActive) {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .toggleSendButtonActivity();
                                  }
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .isSendButtonActive) {
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .sendMessage(
                                          _inputMessageController.text,
                                          context,
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .getUserToken(),
                                          widget.orderModel);
                                  _inputMessageController.clear();
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .toggleSendButtonActivity();
                                } else {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'write_somethings', context),
                                      context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                                child: Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .isLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Image.asset(
                                        Images.send,
                                        width: 25,
                                        height: 25,
                                        color:
                                            Provider.of<ChatProvider>(context)
                                                    .isSendButtonActive
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context).hintColor,
                                      ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const NotLoggedInScreen(),
    );
  }
}
