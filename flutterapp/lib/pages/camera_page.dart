import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>  {

  Future<void> getBarcodeInfo(String barcode) async {
    final String url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 1) {
          final productData = data['product'];
          final macroData = productData['nutriments'];
          print(productData['product_name']);
          print(macroData['carbohydrates']);

          
        } else {
          print('product not found');
        }


      } else {
        print('There was an error fetching product data.');
      }

      

    } catch (e) {
      print(e);
    }
  }
  

  Future<void> scanBarcode() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ffffff", 
        "Cancel", 
        false, 
        ScanMode.BARCODE
        );
      getBarcodeInfo(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: TextButton(onPressed: scanBarcode, child: Text("Scan Barcode")))
        ],
      )
    );
  }
}