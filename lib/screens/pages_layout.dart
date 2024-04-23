import 'package:flutter/material.dart';
import 'package:reciper/screens/home.dart';
import 'package:reciper/screens/recipe_editor.dart';
import 'package:reciper/screens/settings.dart';
import 'package:reciper/widgets/bottom_nav_bar.dart';

class PagesLayout extends StatefulWidget {
  final Widget child;
  final bool displayBottomNavBar;
  final int? currentSection;

  const PagesLayout({
    super.key,
    required this.child,
    this.displayBottomNavBar = true,
    this.currentSection,
  });

  @override
  State<PagesLayout> createState() => _PagesLayoutState();
}

class _PagesLayoutState extends State<PagesLayout> {
  late int currentPageIndex;
  late Widget currentChild;
  List<Widget> pages = [
    const HomePage(),
    const RecipeEditorPage(),
    const Settings()
  ];

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.currentSection ?? 0;
    currentChild = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentChild,
      bottomNavigationBar: widget.displayBottomNavBar
          ? BottomNavBar(
              selectedIndex: currentPageIndex,
              onDestinationSelected: (index) => setState(() {
                currentPageIndex = index;
                currentChild = pages[currentPageIndex];
              }),
            )
          : null,
    );
  }
}
