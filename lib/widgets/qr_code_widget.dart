import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final String verifCode;
  final bool isTutor;
  const QrCodeWidget({
    super.key,
    required this.verifCode,
    required this.isTutor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(128), // opacidad 0.5
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            "Confirmación de Asistencia",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          // test
          if (isTutor)
            QrImageView(
              data: verifCode,
              version: QrVersions.auto,
              size: 200.0,
              gapless: false,
            )
          else
            SizedBox(
              width: 250,
              height: 250,
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Barcode found! Value: ${barcode.rawValue}',
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}



// child: isTutor
//                 ? QrImageView(
//                     data: verifCode,
//                     version: QrVersions.auto,
//                     size: 200.0,
//                     gapless: false,
//                   )
//                 : MobileScanner(
//                     onDetect: (capture) {
//                       final List<Barcode> barcodes = capture.barcodes;
//                       for (final barcode in barcodes) {
//                         SnackBar(
//                           content: Text(
//                             'Barcode found! Value: ${barcode.rawValue}',
//                           ),
//                         );
//                       }
//                     },
//                   ),