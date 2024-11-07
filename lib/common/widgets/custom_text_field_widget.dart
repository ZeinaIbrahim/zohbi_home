import 'package:zohbi_user/utill/styles.dart';
import 'package:zohbi_user/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:zohbi_user/provider/language_provider.dart';
import 'package:zohbi_user/utill/dimensions.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Color? prefixColor;
  final Function? onTap;
  final Function? onChanged;
  final Function? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final IconData? prefixIconData;
  final bool isSearch;
  final Function? onSubmit;
  final bool? isEnabled;
  final TextCapitalization capitalization;
  final LanguageProvider? languageProvider;
  final double? hintFontSize;
  final Color? borderColor;
  final TextStyle? style;

  const CustomTextFieldWidget({
    Key? key,
    this.hintText = 'Write something...',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTap,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIconUrl,
    this.prefixIconUrl,
    this.isSearch = false,
    this.languageProvider,
    this.hintFontSize,
    this.borderColor,
    this.prefixIconData,
    this.prefixColor,
    this.style,
  }) : super(key: key);

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: widget.style ??
          rubikMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: Dimensions.fontSizeLarge),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
            ]
          : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeDefault, horizontal: 10),
        enabledBorder: !widget.isShowBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.radiusSizeDefault),
                borderSide: BorderSide(
                    width: 1,
                    color: widget.borderColor ??
                        Theme.of(context).hintColor.withOpacity(0.2)),
              ),
        focusedBorder: !widget.isShowBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.radiusSizeDefault),
                borderSide: BorderSide(
                    width: 1,
                    color: widget.borderColor ??
                        Theme.of(context).primaryColor.withOpacity(0.5)),
              ),
        border: !widget.isShowBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.radiusSizeDefault),
                borderSide: BorderSide(
                    width: 1,
                    color: widget.borderColor ??
                        Theme.of(context).hintColor.withOpacity(0.2)),
              ),
        hoverColor: Colors.transparent,
        isDense: true,
        hintText: widget.hintText,
        fillColor: widget.fillColor ?? Theme.of(context).cardColor,
        hintStyle: rubikRegular.copyWith(
            fontSize: widget.hintFontSize ?? Dimensions.fontSizeSmall,
            color: Theme.of(context).hintColor.withOpacity(0.7)),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon
            ? Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeLarge,
                    right: Dimensions.paddingSizeSmall),
                child: widget.prefixIconData != null
                    ? Icon(
                        widget.prefixIconData,
                        color: widget.prefixColor ??
                            Theme.of(context).iconTheme.color?.withOpacity(0.4),
                      )
                    : CustomAssetImageWidget(widget.prefixIconUrl!,
                        color: widget.prefixColor ??
                            Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(0.4)),
              )
            : const SizedBox.shrink(),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).hintColor.withOpacity(0.3)),
                    onPressed: _toggle)
                : widget.isIcon
                    ? IconButton(
                        onPressed: widget.onSuffixTap as void Function()?,
                        icon: Image.asset(
                          widget.suffixIconUrl!,
                          width: 15,
                          height: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : null
            : null,
      ),
      onTap: widget.onTap as void Function()?,
      onSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null
              ? widget.onSubmit!(text)
              : null,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
