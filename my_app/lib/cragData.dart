import 'dart:convert'; 
import 'dart:io';
  
import 'package:flutter/services.dart' as root_bundle; 

class CragData {
  Map<dynamic, dynamic> get() {
    Map<dynamic, dynamic> v =  json.decode(new File("././assets/crags.json").readAsStringSync());
    print(v);
    return v["crags"];
  }
}