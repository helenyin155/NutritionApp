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

    // OPEN FOOD FACTS API

    try {
      final response = await http.get(Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'));
      print('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        var data = res['product'];
        
        final NutritionData product = NutritionData(
          itemCode: res['code'],
          brandName: data['brands'] ?? 'Unknown Brand Name',
          itemName: data['product_name_en'] ?? data['product_name'] ?? "Unknown Product Name", 
          caloriesPerServing: data['energy-kcal_serving'] ?? -1,
          caloriesPer100g: data['energy-kcal_100g'] ?? -1,
          proteinPerServing: data['proteins_serving'] ?? -1, 
          proteinPer100g: data['proteins_100g'] ?? -1, 
          carbsPerServing: data['carbohydrates_serving'] ?? -1,
          carbsPer100g: data['carbohydrates_100g'] ?? -1,
          fatPerServing: data['fat_serving'] ?? -1,
          fatPer100g: data['fat_100g'] ?? -1, 
          );
        return product;
      } else {
        print("There was an error fetching product data.");
        return -1;
      }
    } catch (e) {
      print("There was an error: $e");
    }

    

    // NUTRITIONIX API

    /*
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
    */

    

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
              print(value.itemName)
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NutritionInformation(data: value))
              // )
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

class NutritionData {
  String itemCode;

  String brandName;
  String itemName;

  int caloriesPerServing;
  int caloriesPer100g;

  int proteinPerServing;
  int proteinPer100g;

  int carbsPerServing;
  int carbsPer100g;

  int fatPerServing;
  int fatPer100g;
  
  NutritionData(
    {
      required this.itemCode,
      required this.brandName,
      required this.itemName,
      required this.caloriesPerServing,
      required this.caloriesPer100g,
      required this.proteinPerServing,
      required this.proteinPer100g,
      required this.carbsPerServing,
      required this.carbsPer100g,
      required this.fatPerServing,
      required this.fatPer100g
      });

  
}

