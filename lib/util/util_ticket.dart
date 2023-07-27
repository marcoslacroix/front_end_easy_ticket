
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:easy_ticket/util/urls.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

String getTypeFormated(type) {
  String typeFormated;
  switch (type) {
    case "FEMALE":
      typeFormated = "Feminino";
      break;
    case "MALE":
      typeFormated = "Masculino";
      break;
    default:
      typeFormated = "Unisex";
  }
  return typeFormated;
}

double centsToReal(int cents) {
  return cents / 100.0;
}

Future<String> fetchTicketQrcode(uuid, token) async {
  try {
    var params = {"uuid": uuid};
    final url = Uri.parse(ticketQrCodeUrl)
        .replace(queryParameters: _convertMapToStrings(params));
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: token
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<int> dataArray = jsonData['qrCode']['data'].cast<int>();
      // Converta a lista de inteiros para uma String usando UTF-8 encoding
      String qrCodeData = String.fromCharCodes(dataArray);
      return qrCodeData;
    } else {
      print('Failed to fetch qrcode. Status code: ${response.statusCode}');
      throw Exception('Falha ao obter os dados do arquivo blob');
    }
  } catch (e) {
    print('Failed to fetch qrcode');
    throw Exception('Falha ao obter os dados do arquivo blob');
  }
}

Map<String, String> _convertMapToStrings(Map<dynamic, dynamic> map) {
  final convertedMap = <String, String>{};
  map.forEach((key, value) {
    convertedMap[key.toString()] = value.toString();
  });
  return convertedMap;
}


