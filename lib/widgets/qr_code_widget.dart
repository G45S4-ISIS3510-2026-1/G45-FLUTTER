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
        color: Colors.black.withAlpha(128), // 0.5 opacity is 128
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
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isTutor
                ? QrImageView(
                    data: verifCode,
                    version: QrVersions.auto,
                    size: 200.0,
                    gapless: false,
                  )
                : MobileScanner(
                    // The onDetect callback provides the scanned barcode result.
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        // Process the scanned value here
                        SnackBar(
                          content: Text(
                            'Barcode found! Value: ${barcode.rawValue}',
                          ),
                        );
                        // You can add logic to display the result in the UI
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
