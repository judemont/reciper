import 'package:flutter/material.dart';
import 'package:reciper/screens/home.dart';
import 'package:reciper/screens/recipe_editor.dart';
import 'package:reciper/screens/settings.dart';
import 'package:reciper/widgets/bottom_nav_bar.dart';

class PagesLayout extends StatefulWidget {
  final Widget? child;
  final bool displayBottomNavBar;

  const PagesLayout({super.key, this.child, this.displayBottomNavBar = true});

  @override
  State<PagesLayout> createState() => _PagesLayoutState();
}

class _PagesLayoutState extends State<PagesLayout> {
  int? currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPageIndex == null
          ? widget.child
          : [
              const HomePage(),
              const RecipeEditorPage(),
              const Settings()
            ][currentPageIndex!],
      bottomNavigationBar: widget.displayBottomNavBar
          ? BottomNavBar(
              selectedIndex: currentPageIndex ?? 0,
              onDestinationSelected: (index) => setState(() {
                currentPageIndex = index;
              }),
            )
          : null,
    );
  }
}
