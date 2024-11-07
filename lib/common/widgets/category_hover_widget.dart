import 'package:zohbi_user/common/models/category_model.dart';
import 'package:zohbi_user/main.dart';
import 'package:zohbi_user/utill/color_resources.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:zohbi_user/utill/routes.dart';
import 'package:zohbi_user/common/widgets/text_hover_widget.dart';
import 'package:flutter/material.dart';

class CategoryHoverWidget extends StatelessWidget {
  final List<CategoryModel>? categoryList;
  const CategoryHoverWidget({Key? key, required this.categoryList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      child: Column(
          children: categoryList!
              .map((category) => InkWell(
                    onTap: () async {
                      Future.delayed(const Duration(milliseconds: 100))
                          .then((value) async {
                        await Navigator.of(context)
                            .pushNamed(Routes.getCategoryRoute(category));
                        Navigator.of(Get.context!).pop();
                        Navigator.of(Get.context!)
                            .pushNamed(Routes.getCategoryRoute(category));
                      });
                    },
                    child: TextHoverWidget(builder: (isHover) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall,
                            horizontal: Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                            color: isHover
                                ? ColorResources.getGreyColor(context)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 200,
                                child: Text(
                                  category.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        ),
                      );
                    }),
                  ))
              .toList()),
    );
  }
}
