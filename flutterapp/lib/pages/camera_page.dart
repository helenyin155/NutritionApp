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

  Future<void> fetchProductFromBarcode(String barcode) async {
    const String appId = '81477e08'; 
    const String apiKey = '7e42a19f2cb6049ff6f8128d0f146110'; 
    const String url = 'https://trackapi.nutritionix.com/v2/search/item';

    // curl -X GET "https://trackapi.nutritionix.com/v2/search/item?upc=0064042555140" -H "x-app-id: 81477e08" -H "x-app-key: 7e42a19f2cb6049ff6f8128d0f146110"

    //{"foods":[{"food_name":"Celebration Mini Chocolate Chip Cookies","brand_name":"Leclerc","serving_qty":1,"serving_unit":"pouch","serving_weight_grams":26
    //,"nf_metric_qty":26,"nf_metric_uom":"g","nf_calories":130,"nf_total_fat":7,"nf_saturated_fat":4.5,"nf_cholesterol":5,"nf_sodium":105,"nf_total_carbohydrate":17
    //,"nf_dietary_fiber":1,"nf_sugars":10,"nf_protein":1,"nf_potassium":null,"nf_p":null,"full_nutrients":[{"attr_id":203,"value":1},{"attr_id":204,"value":7}
    //,{"attr_id":205,"value":17},{"attr_id":208,"value":130},{"attr_id":269,"value":10},{"attr_id":291,"value":1},{"attr_id":301,"value":20},{"attr_id":303,"value":1.08},
    //{"attr_id":307,"value":105},{"attr_id":318,"value":100},{"attr_id":324,"value":0},{"attr_id":328,"value":0},{"attr_id":401,"value":0},{"attr_id":601,"value":5}
    //,{"attr_id":605,"value":0},{"attr_id":606,"value":4.5}],"nix_brand_name":"Leclerc","nix_brand_id":"51db37b9176fe9790a898c6d","nix_item_name":"Celebration Mini Chocolate Chip Cookies",
    //"nix_item_id":"54e87b195af0cf56477f84d4","metadata":{},"source":8,"ndb_no":null,"tags":null,"alt_measures":null,"lat":null,"lng":null,"photo":
    //{"thumb":"https://nutritionix-api.s3.amazonaws.com/54eb698ac3965b7654a0bd0b.jpeg","highres":null,"is_user_uploaded":false},"note":null,"class_code":null,"brick_code":null,"tag_id":null,
    //"updated_at":"2021-10-03T13:54:50+00:00","nf_ingredient_statement":"ENRICHED WHEAT FLOUR (WHEAT FLOUR, NIACIN, REDUCED IRON, THIAMINE MONONITRATE, RIBOFLAVIN, FOLIC ACID), 
    //NESTLÉ® TOLL HOUSE® SEMI-SWEET CHOCOLATE MORSELS (SUGAR, CHOCOLATE, MILKFAT, COCOA BUTTER, SOY LECITHIN, NATURAL FLAVORS), BROWN SUGAR, SUGAR, VEGETABLE SHORTENING 
    //(PALM OIL, SOYBEAN OIL, BETA CAROTENE [COLOR], WHEY), WATER, BUTTER (CREAM, SALT), EGGS, 2% OR LESS OF SALT, BAKING SODA (CONTAINS SOY LECITHIN), NATURAL FLAVOR, VANILLA EXTRACT"}]}%

    try {
      final response = await http.get(
        Uri.parse('$url?upc=$barcode'),
        headers: {
          'x-app-id': appId,
          'x-app-key' : apiKey,
          }
        );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);


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
      print(barcodeScanRes);
      fetchProductFromBarcode(barcodeScanRes);
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