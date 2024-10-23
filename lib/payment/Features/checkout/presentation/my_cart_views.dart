import 'package:arrhythmia/payment/Features/checkout/presentation/views/My_cart_view_body.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Checkout', context: context),
      body: const MyCartViewBody(),
    );
  }
}
