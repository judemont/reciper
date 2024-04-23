import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reciper/utilities/database.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  static Future<void> export() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/Reciper_Export.json';

    File file = File(filePath);

    DatabaseService db = DatabaseService();
    db.export().then((String result) {
      file.writeAsString(result);
      Share.shareXFiles([XFile(filePath)]);
    });
  }

  static Future<int> import() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Reciper export',
      extensions: <String>['json'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file != null) {
      String backupContent = await file.readAsString();
      DatabaseService db = DatabaseService();
      db.import(backupContent);
    }
    return 1;
  }
}
