import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Center(
        child: CupertinoSwitch(
          value: Provider.of<Themeprovider>(context, listen: false).isDarkMode,
          onChanged: (value) =>
              Provider.of<Themeprovider>(context, listen: false).toggleTheme(),
        ),
      ),
    );
  }
}
