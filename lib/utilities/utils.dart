import 'dart:convert';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reciper/models/recipe.dart';
import 'package:reciper/utilities/database.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  static const Encoding _textFileEncoding = utf8;

  static Future<void> userExport() async {
    Directory directory = await getTemporaryDirectory();
    String appDocumentsPath = directory.path;
    String filePath = '$appDocumentsPath/Reciper_Export.json';

    File file = File(filePath);

    DatabaseService db = DatabaseService();
    String result = await db.export();
    var fileBytes = _textFileEncoding.encode(result);
    await file.writeAsBytes(fileBytes);
    await Share.shareXFiles([XFile(filePath)]);
  }

  static Future<Recipe?> userRecipeImport() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Reciper export',
      extensions: <String>['json'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file != null) {
      var fileBytes = await file.readAsBytes();
      String backupContent = _textFileEncoding.decode(fileBytes);

      Map<String, dynamic> jsonData = jsonDecode(backupContent);
      Recipe recipe = Recipe.fromMap(jsonData);
      return recipe;
    }
    return null;
  }

  static Future<int> userImport() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Reciper export',
      extensions: <String>['json'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file != null) {
      var fileBytes = await file.readAsBytes();
      String backupContent = _textFileEncoding.decode(fileBytes);
      DatabaseService db = DatabaseService();
      await db.import(backupContent);
    }
    return 1;
  }

  static Future<void> userRecipeExport(Recipe recipe) async {
    Directory directory = await getTemporaryDirectory();
    String appDocumentsPath = directory.path;
    String recipeName = recipe.title ?? "_";
    String filePath = '$appDocumentsPath/$recipeName Reciper.json';

    File file = File(filePath);

    DatabaseService db = DatabaseService();
    String result = await db.exportRecipe(recipe);
    var fileBytes = _textFileEncoding.encode(result);
    await file.writeAsBytes(fileBytes);
    await Share.shareXFiles([XFile(filePath)]);
  }

  static Future<void> userPdfExportRecipe(Recipe recipe) async {
    Directory directory = await getTemporaryDirectory();
    String appDocumentsPath = directory.path;

    String recipeName = recipe.title ?? "_";

    String filePath = '$appDocumentsPath/$recipeName.pdf';

    File file = File(filePath);

    final pdf = pw.Document();
    List<Recipe> recipes = await DatabaseService.getRecipes();

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
              pw.ListView(children: [
                pw.Text(recipe.title ?? "",
                    style: pw.TextStyle(
                        fontSize: 35, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                if (recipe.image != null)
                  pw.Image(
                      pw.MemoryImage(Base64Decoder().convert(recipe.image!)),
                      width: 300,
                      height: 300),
                pw.SizedBox(height: 60),
                pw.Text("Ingredients : ",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text(recipe.ingredients ?? "",
                    overflow: pw.TextOverflow.span),
                pw.SizedBox(height: 40),
                pw.Text("Instructions : ",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text(recipe.steps ?? "", overflow: pw.TextOverflow.span),
              ])
            ]));

    await file.writeAsBytes(await pdf.save());
    Share.shareXFiles([XFile(filePath)]);
  }

  static Future<void> userPdfExport() async {
    Directory directory = await getTemporaryDirectory();
    String appDocumentsPath = directory.path;
    String filePath = '$appDocumentsPath/recipes.pdf';

    File file = File(filePath);

    final pdf = pw.Document();
    List<Recipe> recipes = await DatabaseService.getRecipes();

    for (var recipe in recipes) {
      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
                pw.ListView(children: [
                  pw.Text(recipe.title ?? "",
                      style: pw.TextStyle(
                          fontSize: 35, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  if (recipe.image != null)
                    pw.Image(
                        pw.MemoryImage(Base64Decoder().convert(recipe.image!)),
                        width: 300,
                        height: 300),
                  pw.SizedBox(height: 60),
                  pw.Text("Ingredients : ",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text(recipe.ingredients ?? "",
                      overflow: pw.TextOverflow.span),
                  pw.SizedBox(height: 40),
                  pw.Text("Instructions : ",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text(recipe.steps ?? "", overflow: pw.TextOverflow.span),
                ])
              ]));
    }

    await file.writeAsBytes(await pdf.save());
    Share.shareXFiles([XFile(filePath)]);
  }
}
