import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CusttomSvgPicture extends StatelessWidget {
  const CusttomSvgPicture({
    super.key,
    required this.path,
    this.withColorFilter = true,
    this.width,
    this.height,
  });
  const CusttomSvgPicture.withColorFilter({
    super.key,
    required this.path,
    this.width,
    this.height,
  }):withColorFilter=false;

  final String path;
  final bool withColorFilter;
  final double? width;
  final double? height;


  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: withColorFilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
