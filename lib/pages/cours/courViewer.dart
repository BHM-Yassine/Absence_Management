import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import '../../models/cours.dart';

class CourViewer extends StatelessWidget {
  final Cour cour;

  CourViewer(this.cour);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        elevation: 0,
        backgroundColor: Color(0xffED3C63),
        title: Text(cour.courName, style: TextStyle(color: Colors.white),),
      ),
      path: cour.courPath,
    );
  }
}
