import 'package:global_template/global_template.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFFooter extends pw.StatelessWidget {
  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.RichText(
          text: pw.TextSpan(
            text: '${GlobalFunction.formatYearMonthDay(DateTime.now())} | ',
            children: [
              pw.TextSpan(
                text: '${GlobalFunction.formatHoursMinutesSeconds(DateTime.now())}',
              )
            ],
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: pw.Theme.of(context).defaultTextStyle.copyWith(
                color: PdfColors.grey,
              ),
        ),
      ],
    );
  }
}
