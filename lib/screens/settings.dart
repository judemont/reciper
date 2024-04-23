import 'package:flutter/material.dart';
import 'package:reciper/utilities/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
                Utils.import();
                Navigator.pop(context);
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
                Utils.export();
              },
              child: const Text("Export recipes"),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
