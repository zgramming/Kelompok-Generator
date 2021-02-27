import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import '../../../functions/functions.dart';
import '../../../network/models/models.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    @required this.index,
    @required this.history,
  });

  final int index;
  final HiveHistoryModel history;

  @override
  Widget build(BuildContext context) {
    print('ismobiledesign ${sizes.isMobileLayout(context)}');
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(60),
          left: Radius.circular(15),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20.0),
        leading: CircleAvatar(
          backgroundColor: colorPallete.accentColor,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${index + 1}',
                style: appTheme.headline6(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorPallete.white,
                    ),
              ),
            ),
          ),
        ),
        title: Text(
          history.nameGroup,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${GlobalFunction.formatHMS(history.createdAt)} |'),
                TextSpan(
                  text: ' Generate ulang',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => FunctionRequest.reGenerate(
                          context,
                          history: history,
                          onCompeleted: () => Navigator.of(context).pop(),
                        ),
                  style: appTheme.caption(context).copyWith(
                        color: colorPallete.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        trailing: Container(
          height: double.infinity,
          child: Wrap(
            runAlignment: WrapAlignment.center,
            children: [
              ActionCircleButton(
                radius: sizes.isMobileLayout(context)
                    ? sizes.width(context) * .035
                    : sizes.width(context) * .0175,
                backgroundColor: colorPallete.white,
                foregroundColor: colorPallete.accentColor,
                icon: Icons.search,
                onTap: () async {
                  try {
                    final pathPDF = await FunctionRequest.previewPDF(history);
                    Navigator.of(context).pushNamed(
                      PDFPreviewScreen.routeNamed,
                      arguments: pathPDF,
                    );
                  } catch (e) {
                    await GlobalFunction.showToast(
                      message: e.toString(),
                      toastType: ToastType.error,
                      isLongDuration: true,
                    );
                  }
                },
              ),
              SizedBox(width: sizes.width(context) / 40),
              ActionCircleButton(
                radius: sizes.isMobileLayout(context)
                    ? sizes.width(context) * .035
                    : sizes.width(context) * .0175,
                icon: Icons.picture_as_pdf,
                backgroundColor: colorPallete.red,
                foregroundColor: colorPallete.white,
                onTap: () async {
                  try {
                    await FunctionRequest.printHistoryPDF(history);
                  } catch (e) {
                    await GlobalFunction.showToast(
                      message: e.toString(),
                      isLongDuration: true,
                      toastType: ToastType.error,
                    );
                  }
                },
              ),
              SizedBox(width: sizes.width(context) / 40),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFPreviewScreen extends StatefulWidget {
  static const routeNamed = '/pdf-preview-screen';
  final String pathPDF;
  PDFPreviewScreen({
    @required this.pathPDF,
  });
  @override
  _PDFPreviewScreenState createState() => _PDFPreviewScreenState();
}

class _PDFPreviewScreenState extends State<PDFPreviewScreen> {
  PdfController _pdfController;
  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(document: PdfDocument.openFile(widget.pathPDF));
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Preview PDF'),
      ),
      body: PdfView(
        controller: _pdfController,
        documentLoader: Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (error) => Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
    );
  }
}
