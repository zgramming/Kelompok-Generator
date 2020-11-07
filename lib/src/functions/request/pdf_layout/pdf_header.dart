import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFHeader extends pw.StatelessWidget {
  final PdfImage logo;
  PDFHeader({this.logo});
  @override
  pw.Widget build(pw.Context context) {
    print(context.pageNumber);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        if (context.pageNumber == 1)
          pw.Text(
            'Kelompok generator',
            style: pw.Theme.of(context).header1,
          )
        else
          pw.SizedBox(),
        pw.ClipOval(
          child: pw.Container(
            width: 70,
            height: 70,
            child: pw.Image(logo),
          ),
        ),
      ],
    );
  }
}