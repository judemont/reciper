import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  final Function backup;
  final Function restore;

  const Settings({super.key, required this.backup, required this.restore});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _displayedTabIndex = 0;

  void setDisplayedTab(int index) {
    setState(() {
      if (_displayedTabIndex == index) {
        _displayedTabIndex = 0;
      } else {
        _displayedTabIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              selected: _displayedTabIndex == 1,
              onTap: () {
                setDisplayedTab(1);
              },
              title: const Text("Import"),
            ),
            Visibility(
              visible: _displayedTabIndex == 1,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    ListTile(
                        title: const Text("Import recipes"),
                        onTap: () {
                          widget.restore().then(() => Navigator.pop(context));
                        }),
                  ],
                ),
              ),
            ),
            ListTile(
              selected: _displayedTabIndex == 2,
              onTap: () {
                setDisplayedTab(2);
              },
              title: const Text("Export"),
            ),
            Visibility(
              visible: _displayedTabIndex == 2,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Export recipes"),
                      onTap: () => widget.backup(),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              selected: _displayedTabIndex == 3,
              onTap: () {
                setDisplayedTab(3);
              },
              title: const Text("About"),
            ),
            Visibility(
              visible: _displayedTabIndex == 3,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    const ListTile(
                      title: Text(
                          "Reciper is an open source, simple (but powerful), privacy friendly Recipe management app developed with ❤️ by Judemont and Rdemont"),
                    ),
                    ListTile(
                      title: const Text(
                        "Source code (GitHub)",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => launchUrl(
                          Uri.parse('https://github.com/judemont/reciper')),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
