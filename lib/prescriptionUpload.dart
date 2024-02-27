import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class PrescriptionUpload extends StatefulWidget {
  @override
  _PrescriptionUploadState createState() => _PrescriptionUploadState();
}

class _PrescriptionUploadState extends State<PrescriptionUpload> {
  String _pdfText = '';

  void _getPdfText() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    /*if (result != null) {
      String path = result.files.single.path!;
      FlutterOcrPlugin ocrPlugin = FlutterOcrPlugin();
      String text = await ocrPlugin.extractText(path);

      List<String> lines = text.split('\n');
      List<String> drugNames = lines.where((line) => line.contains('Nom du médicament')).toList();

      setState(() {
        _pdfText = drugNames.join('\n');
      });
    } else {
      // User canceled the picker
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Prescription'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getPdfText,
              child: Text('Select Prescription'),
            ),
            Text(_pdfText),
          ],
        ),
      ),
    );
  }
}
