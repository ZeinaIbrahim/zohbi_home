import 'package:zohbi_user/common/widgets/custom_button_widget.dart';
import 'package:zohbi_user/features/checkout/providers/checkout_provider.dart';
import 'package:zohbi_user/features/coupon/providers/coupon_provider.dart';
import 'package:zohbi_user/features/splash/providers/splash_provider.dart';
import 'package:zohbi_user/helper/custom_snackbar_helper.dart';
import 'package:zohbi_user/helper/price_converter_helper.dart';
import 'package:zohbi_user/localization/language_constrants.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonViewWidget extends StatelessWidget {
  final double itemPrice;
  final double total;
  final double deliveryCharge;
  final double discount;

  const ButtonViewWidget({
    Key? key,
    required this.itemPrice,
    required this.total,
    required this.deliveryCharge,
    required this.discount,
  }) : super(key: key);

  Future<void> _sendOrderToWhatsApp(BuildContext context) async {
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    final CheckoutProvider checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);
    final CouponProvider couponProvider =
        Provider.of<CouponProvider>(context, listen: false);

    String itemPriceString = PriceConverterHelper.convertPrice(itemPrice);
    String totalString = PriceConverterHelper.convertPrice(total);
    String deliveryChargeString =
        PriceConverterHelper.convertPrice(deliveryCharge);
    String discountString = PriceConverterHelper.convertPrice(discount);

    StringBuffer message = StringBuffer("Order Invoice:\n\n");

    if (cartProvider.cartList.isNotEmpty) {
      for (var cartItem in cartProvider.cartList) {
        String productName = cartItem!.product?.name ?? 'Unknown';
        String productPrice =
            PriceConverterHelper.convertPrice(cartItem.price ?? 0);
        int productQuantity = cartItem.quantity ?? 0;
        String productVariation =
            cartItem.variation?.map((v) => v.type).join(', ') ?? 'None';

        message.write("Product: $productName\n");
        message.write("Price: $productPrice\n");
        message.write("Quantity: $productQuantity\n");
        message.write("Variation: $productVariation\n\n");
      }
    }

    message.write("Item Price: $itemPriceString\n");
    message.write("Delivery Charge: $deliveryChargeString\n");
    message.write("Coupon Code: ${couponProvider.coupon?.code ?? 'None'}\n");
    message.write("Discount: $discountString\n");
    message.write("Order Type: ${checkoutProvider.orderType}\n");
    message.write("\n--------------------------------------\n");
    message.write("Total: $totalString\n");

    final String whatsappUrl =
        "https://wa.me/9613160666?text=${Uri.encodeComponent(message.toString())}";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final CheckoutProvider checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);
    final CouponProvider couponProvider =
        Provider.of<CouponProvider>(context, listen: false);

    return Container(
      width: Dimensions.webScreenWidth,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomButtonWidget(
              btnTxt: getTranslated('proceed_to_checkout', context),
              onTap: () {
                if (itemPrice <
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel!
                        .minimumOrderValue!) {
                  showCustomSnackBar(
                    'Minimum order amount is ${PriceConverterHelper.convertPrice(Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue)}, you have ${PriceConverterHelper.convertPrice(itemPrice)} in your cart, please add more items.',
                    context,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    Routes.getCheckoutRoute(
                      amount: total,
                      deliveryCharge: deliveryCharge,
                      type: checkoutProvider.orderType,
                      discount: discount,
                      code: couponProvider.coupon?.code,
                      fromCart: true,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          // WhatsApp Button
          Expanded(
            child: CustomButtonWidget(
              backgroundColor: Colors.green,
              btnTxt: "Send to WhatsApp",
              onTap: () => _sendOrderToWhatsApp(context),
            ),
          ),
        ],
      ),
    );
  }
}
