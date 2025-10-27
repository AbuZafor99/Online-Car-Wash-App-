import 'package:flutter/material.dart';
import 'custom_floting_action.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? drawer;
  final bool removePadding;
  final bool showFloatingActionButton;
  final Widget? bottomNavigationBar;
  final VoidCallback? onFabTap;

  const AppScaffold({
    super.key,
    this.appBar,
    this.drawer,
    required this.body,
    this.removePadding = false,
    this.showFloatingActionButton = false,
    this.bottomNavigationBar,
    this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: removePadding ? 0 : 18),
        child: body,
      ),
      floatingActionButton: showFloatingActionButton
          ? Padding(
              padding: const EdgeInsets.only(bottom: 150),
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hoverColor: Colors.transparent,
                onPressed: onFabTap ?? () {},
                child: CustomFlotingActionButton(onTap: onFabTap ?? () {}),
              ),
            )
          : null,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
