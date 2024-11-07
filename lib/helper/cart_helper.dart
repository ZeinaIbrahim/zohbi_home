import 'package:zohbi_user/common/models/cart_model.dart';
import 'package:zohbi_user/common/models/product_model.dart';
import 'package:zohbi_user/helper/price_converter_helper.dart';

class CartHelper {
  static CartModel? getCartModel(Product product,
      {List<int>? variationIndexList, int? quantity}) {
    CartModel? cartModel;
    List<Variation> variation = [];

    int? stock = 0;
    List variationList = [];

    double? price = product.price;
    stock = product.totalStock;

    for (int index = 0; index < product.choiceOptions!.length; index++) {
      if (product.choiceOptions![index].options != null &&
          product.choiceOptions![index].options!.isNotEmpty) {
        if (product.choiceOptions![index].options!.first.length > index) {
          if (variationIndexList != null) {
            variationList.add(product
                .choiceOptions![index].options![variationIndexList[index]]
                .replaceAll(' ', ''));
          } else {
            variationList.add(product.choiceOptions![index].options![index]
                .replaceAll(' ', ''));
          }
        }
      }
    }

    String variationType = '';
    bool isFirst = true;
    for (var variation in variationList) {
      if (isFirst) {
        variationType = '$variationType$variation';
        isFirst = false;
      } else {
        variationType = '$variationType-$variation';
      }
    }

    for (Variation variationValue in product.variations!) {
      if (variationValue.type == variationType) {
        price = variationValue.price;
        variation.add(variationValue);
        stock = variationValue.stock;
        break;
      }
    }

    cartModel = CartModel(
      product.id,
      price,
      PriceConverterHelper.convertWithDiscount(
          price, product.discount, product.discountType),
      variation,
      (price! -
          PriceConverterHelper.convertWithDiscount(
              price, product.discount, product.discountType)!),
      quantity ?? 1,
      price -
          PriceConverterHelper.convertWithDiscount(
              price, product.tax, product.taxType)!,
      stock,
      product,
    );

    return cartModel;
  }

  static int getCartItemCount(List<CartModel?> cartList) {
    int item = 0;
    for (CartModel? cart in cartList) {
      item = item + (cart?.quantity ?? 0);
    }
    return item;
  }
}
