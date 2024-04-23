import 'package:flutter/material.dart';
import 'package:reciper/screens/home.dart';
import 'package:reciper/screens/recipe_editor.dart';
import 'package:reciper/screens/settings.dart';
import 'package:reciper/widgets/bottom_nav_bar.dart';

class PagesLayout extends StatefulWidget {
  final Widget? child;
  final bool displayBottomNavBar;
  final int currentSection;

  const PagesLayout(
      {super.key,
      this.child,
      this.displayBottomNavBar = true,
      this.currentSection = 0});

  @override
  State<PagesLayout> createState() => _PagesLayoutState();
}

class _PagesLayoutState extends State<PagesLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: widget.displayBottomNavBar
          ? BottomNavBar(
              selectedIndex: widget.currentSection,
              onDestinationSelected: (index) => setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PagesLayout(
                      currentSection: index,
                      child: [
                        const HomePage(),
                        const RecipeEditorPage(),
                        const Settings(),
                      ][index]),
                ));
              }),
            )
          : null,
    );
  }
}
