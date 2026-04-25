import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatefulWidget {
  final String verifCode;
  final bool isTutor;
  final Function(String)? onCodeScanned;

  const QrCodeWidget({
    super.key,
    required this.verifCode,
    required this.isTutor,
    this.onCodeScanned,
  });

  @override
  State<QrCodeWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  bool _isProcessing = false;

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
          if (widget.isTutor)
            QrImageView(
              backgroundColor: Colors.white,
              data: widget.verifCode,
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
                  if (_isProcessing) return;

                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      setState(() {
                        _isProcessing = true;
                      });

                      // Invoca la función confirmSession del viewmodel
                      if (widget.onCodeScanned != null) {
                        widget.onCodeScanned!(barcode.rawValue!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Código escaneado: ${barcode.rawValue}',
                            ),
                          ),
                        );
                      }

                      // Permitir volver a escanear después de 3 segundos para evitar erroes
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          setState(() {
                            _isProcessing = false;
                          });
                        }
                      });

                      break; // Detener después de primer escaneo
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