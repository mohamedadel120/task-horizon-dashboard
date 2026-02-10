import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageButton extends StatelessWidget {
  final String image;
  final VoidCallback? function;
  IconData? icon;
  double? width;
  double? height;

  ImageButton({
    super.key,
    required this.image,
    this.function,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Column(
        children: [
          image.isNotEmpty
              ? image.endsWith(".svg")
                    ? SvgPicture.asset(image, width: width, height: height)
                    : Image.asset(image, width: width, height: height)
              : Icon(icon),
        ],
      ),
    );
  }
}

