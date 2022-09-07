import 'package:flutter/material.dart';
import 'package:flutter_media_player/view/home_view/home_view_model.dart';
import 'package:stacked/stacked.dart';

class CustomButton extends ViewModelWidget<HomeViewModel> {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textColor;
  final int? selectedIndex;
  final TextStyle? textStyle;
  final double? radius;
  const CustomButton({
    Key? key,
    this.onPressed,
    this.selectedIndex,
    this.textColor = Colors.white,
    this.text,
    this.radius = 80,
    this.color,
    this.child,
    this.width = double.infinity,
    this.height,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          height: height ?? 45,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius!),
          ),
          child: MaterialButton(
            onPressed: onPressed,
            color: viewModel.selectedIndex == selectedIndex
                ? Colors.indigo
                : Colors.transparent,
            elevation: 0,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius!),
                borderSide: BorderSide(
                    color: viewModel.selectedIndex == selectedIndex
                        ? Colors.indigo
                        : Colors.indigo,
                    width: 1.8)),
            child: child ??
                Text(text!,
                    style: textStyle ??
                        TextStyle(
                            color: viewModel.selectedIndex == selectedIndex
                                ? Colors.white
                                : Colors.indigo,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
