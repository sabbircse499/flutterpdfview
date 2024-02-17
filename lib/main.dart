import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Viewer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PdfList(),
    );
  }
}

class PdfList extends StatefulWidget {
  const PdfList({Key? key}) : super(key: key);

  @override
  State<PdfList> createState() => _PdfListState();
}

class _PdfListState extends State<PdfList> {
  List<String> pdfPaths = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _getPdfFiles();
  }

  Future<void> _getPdfFiles() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    setState(() {
      pdfPaths = appDocDir
          .listSync()
          .where((entity) => entity is File && entity.path.endsWith('.pdf'))
          .map((entity) => entity.path)
          .toList();
      isLoading = false; // Set isLoading to false after files are fetched
    });

    // Debugging: Print out the paths of PDF files
    print('PDF Paths:');
    pdfPaths.forEach((path) => print(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF List'),
      ),
      body: isLoading // Show progress indicator only while loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : pdfPaths.isNotEmpty
          ? ListView.builder(
        itemCount: pdfPaths.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pdfPaths[index]),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PdfViewer(pdfPath: pdfPaths[index]),
              ),
            ),
          );
        },
      )
          : Center(
        child: Text('No PDF files found.'),
      ),
    );
  }
}

class PdfViewer extends StatelessWidget {
  final String pdfPath;

  const PdfViewer({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.file(File(pdfPath)),
    );
  }
}
