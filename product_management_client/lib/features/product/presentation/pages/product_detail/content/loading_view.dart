import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';

class ProductDetailLoadingView extends StatelessWidget {
  const ProductDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(DefaultColors.buttonColor),
        ),
      ),
    );
  }
}
