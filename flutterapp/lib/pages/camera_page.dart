import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';



class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  Future<NutritionData?> fetchProductFromBarcode(String barcode) async {

    // OPEN FOOD FACTS API

    try {
      
      final response = await http.get(Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'));
      print('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
      
      

      
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        var data = res['product'];
        var nutritionalData = data['nutriments'];

        try {
          final ingredientsResponse = await http.get(Uri.parse('https://cb4e-2620-101-f000-700-3fb9-eca2-34f0-878b.ngrok-free.app/get-ingredients/$barcode'));
          
        } catch (e) {
          print(e);
        }
        
        final NutritionData product = NutritionData(
          itemCode: res['code'],
          imgURL: data['image_url'] ?? 'No Image',
          brandName: data['brands'] ?? 'Unknown Brand Name',
          itemName: data['product_name_en'] ?? data['product_name'] ?? "Unknown Product Name", 
          caloriesPerServing: (nutritionalData['energy-kcal_serving'] as num?)?.toDouble() ?? -1.0,
          caloriesPer100g: (nutritionalData['energy-kcal_100g'] as num?)?.toDouble() ?? -1.0,
          proteinPerServing: (nutritionalData['proteins_serving'] as num?)?.toDouble() ?? -1.0, 
          proteinPer100g: (nutritionalData['proteins_100g'] as num?)?.toDouble() ?? -1.0, 
          carbsPerServing: (nutritionalData['carbohydrates_serving'] as num?)?.toDouble() ?? -1.0,
          carbsPer100g: (nutritionalData['carbohydrates_100g'] as num?)?.toDouble() ?? -1.0,
          fatPerServing: (nutritionalData['fat_serving'] as num?)?.toDouble() ?? -1.0,
          fatPer100g: (nutritionalData['fat_100g'] as num?)?.toDouble() ?? -1.0, 
          );
        return product;
      } else {
        
        return null;
        
      }
    } catch (e) {
      return null;
      
      
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
            if (value == null) 
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ErrorPage())
              )
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

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Could not find product."),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("Scan Another Item"))

          ],
        )
      )
    );
  }
}



class NutritionInformation extends StatefulWidget {
  final NutritionData data;
  
  NutritionInformation({Key? key, required this.data}) : super(key: key);

  @override
  State<NutritionInformation> createState() => _NutritionInformationState();
}

class _NutritionInformationState extends State<NutritionInformation> {

  final List<String> nutritionList = ['caloriesPerServing', 'caloriesPer100g', 'proteinPerServing', 'proteinPer100g', 'carbsPerServing' ,'carbsPer100g', 'fatPerServing', 'fatPer100g'];
  final List<String> labelList = [
    'Calories Per Serving: ',
    'Calories Per 100g: ', 
    'Protein Per Serving (g):', 
    'Protein Per 100g (g): ', 
    'Carbohydrates Per Serving (g): ', 
    'Carbohydrates Per 100g (g): ', 
    'Total Fat Per Serving (g): ', 
    'Total Fat Per 100g (g):'];




  @override
  Widget build(BuildContext context) {

    List<Widget> itemInformation;
    List<Widget> macroData;

    if (widget.data.getProperty('imgURL') == 'No Image') {
      itemInformation = [
        Text(
          "Here's what we found:"
        ),
        Container(
          child: Text("No Image"),
          ),
        Text(widget.data.getProperty('itemCode'),
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500
          ),), 
        Text(widget.data.getProperty('itemName'),
         style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700
          ),),];
    } else {
      itemInformation = [
        Text(
          "Here's what we found",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700
          ),
        ),
        Container(
          height: 200,
          child: Image.network(widget.data.getProperty('imgURL'),
          fit: BoxFit.contain,),
        ),
        Text(widget.data.getProperty('itemCode'),
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500
          ),), 
        Text(widget.data.getProperty('itemName'),
         style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700
          ),),];

    }

  double roundDouble(double value, int places){ 
   num mod = pow(10, places); 
   return ((value * mod).round().toDouble() / mod); 
  }

    macroData = [];
    for (int i = 0; i < nutritionList.length; i++) {
      if (widget.data.getProperty(nutritionList[i]) == -1.0) {
        // collectedData.add(Text("Error"));
        continue;
      } else {
        print(nutritionList[i]);
        macroData.add(Text("${labelList[i]}${roundDouble(widget.data.getProperty(nutritionList[i]), 2).toString()}"));
      }
    }

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: 
          [
            Container(
              child: Column(
                children: itemInformation
                )
            ),
            Container(
              
              height: 400,
              width: 300,
              
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  const BoxShadow( 
                    color: Colors.grey,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 1.0

                  )
                ]
                

              ),
              child: Column(
                children: macroData,
            ),



            )
            ,
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
  String imgURL;

  String brandName;
  String itemName;

  double caloriesPerServing;
  double caloriesPer100g;

  double proteinPerServing;
  double proteinPer100g;

  double carbsPerServing;
  double carbsPer100g;

  double fatPerServing;
  double fatPer100g;
  
  NutritionData(
    {
      required this.itemCode,
      required this.imgURL,
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
  
  dynamic getProperty(String propertyName) {
    switch (propertyName) {
      case 'itemCode':
        return itemCode;
      case 'imgURL':
        return imgURL;
      case 'brandName':
        return brandName;
      case 'itemName':
        return itemName;
      case 'caloriesPerServing':
        return caloriesPerServing;
      case 'caloriesPer100g':
        return caloriesPer100g;
      case 'proteinPerServing':
        return proteinPerServing;
      case 'proteinPer100g':
        return proteinPer100g;
      case 'carbsPerServing':
        return carbsPerServing;
      case 'carbsPer100g':
        return carbsPer100g;
      case 'fatPerServing':
        return fatPerServing;
      case 'fatPer100g':
        return fatPer100g;
      default:
        throw Exception('Property not found');
    }
  }

  
}

