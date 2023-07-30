import 'package:easy_ticket/page/checking/checking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'checking_manual.dart';

class ScanTicket extends StatefulWidget {
  const ScanTicket({Key? key}) : super(key: key);

  @override
  State<ScanTicket> createState() => _ScanTicketState();
}

class _ScanTicketState extends State<ScanTicket> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitor de QR Code'),
      ),
      body: Stack(
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20), // Espaçamento do botão para a parte inferior da tela
              child: ElevatedButton(
                onPressed: _renderManuallyChecking,
                child: const Text('Digite o código do ingresso'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _renderManuallyChecking() async {
    _stopCamera();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckingManual(),
      ),
    );
    _startCamera();
  }

  void _startCamera() {
    setState(() {
      _controller?.resumeCamera();
    });
  }

  void _stopCamera() {
    setState(() {
      _controller?.stopCamera();
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    _controller!.scannedDataStream.listen((scanData) async {
      if (mounted) {
        var ticketUuid = scanData.code;
        if (ticketUuid != null && ticketUuid.length == 36) {
          _stopCamera();
           await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Checking(ticketUuid: ticketUuid),
            )
          );
          _startCamera();
        }
      }
    });
  }
}