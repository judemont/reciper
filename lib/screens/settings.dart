import 'package:flutter/material.dart';
import 'package:reciper/screens/home.dart';
import 'package:reciper/screens/pages_layout.dart';
import 'package:reciper/utilities/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Import",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Utils.userImport().then((value) => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            const PagesLayout(child: HomePage()))));
              },
              child: const Text("Import recipes"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Export",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Utils.userExport();
              },
              child: const Text("Export recipes"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Utils.userPdfExport();
              },
              child: const Text("Export recipes to PDF"),
            ),
            const SizedBox(height: 20),
            const Text(
              "About",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reciper has been developed with ❤️ by Judemont",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse('https://github.com/judemont/reciper'),
                  ),
                  icon: const Icon(Icons.link),
                  label: const Text("Source code (GitHub)"),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(
                        'https://play.google.com/store/apps/details?id=jdm.apps.reciper'),
                  ),
                  icon: const Icon(Icons.star_rate_rounded),
                  label: const Text("Rate Reciper on Google Play"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
