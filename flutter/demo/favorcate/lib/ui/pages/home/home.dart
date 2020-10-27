import 'package:favorcate/ui/pages/home/home_app_bar.dart';
import 'package:flutter/material.dart';

import 'home_content.dart';
import 'home_drawer.dart';

class HYHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HYHomeAppBar(context),
      body: HYHomeContent(),
    );
  }
}
