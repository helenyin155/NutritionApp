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

class _CameraPageState extends State<CameraPage> {

  Future<dynamic> fetchProductFromBarcode(String barcode) async {
    const String appId = '3450e0e3';
    const String apiKey = '419aaaf150a658af0e727a6c5ba7afc0';
    const String url = 'https://trackapi.nutritionix.com/v2/search/item';

    
    try {
      final response = await http.get(Uri.parse('$url?upc=$barcode'), headers: {
        'x-app-id': appId,
        'x-app-key': apiKey,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['foods'][0];
        
      } else {
        print('There was an error fetching product data.');
        return 0;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ffffff", "Cancel", false, ScanMode.BARCODE);
      print(barcodeScanRes);

      fetchProductFromBarcode(barcodeScanRes).then((value) => {
            if (value == 0) 
            {
              print("Error")
            }
             else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NutritionInformation(data: value))
              )
            }
          });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
            child:
                TextButton(onPressed: scanBarcode, child: Text("Scan Barcode")))
      ],
    ));
  }
}

class NutritionInformation extends StatefulWidget {
  final Map<String, dynamic> data;
  
  NutritionInformation({Key? key, required this.data}) : super(key: key);

  @override
  State<NutritionInformation> createState() => _NutritionInformationState();
}

class _NutritionInformationState extends State<NutritionInformation> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: 
          [
            Text('${widget.data['brand_name']} ${widget.data['food_name']}'),
            Text('${widget.data['nf_calories'].toString()} calories'),
            Text('${widget.data['nf_total_carbohydrate'].toString()}g Carbohydrates'),
            Text('${widget.data['nf_protein'].toString()}g Protein'),
            Text('${widget.data['nf_total_fat'].toString()}g Total Fat'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back"))
          ],
        ),
      )
    );
  }
}

