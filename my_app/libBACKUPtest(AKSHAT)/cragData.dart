import 'dart:convert'; 
import 'dart:io';
  
import 'package:flutter/services.dart' as root_bundle; 

class CragData {

  Map<int, String> table = {
    16: '4a',
    17: '4b',
    18: '4c',
    19: '5a',
    20: '5b',
    21: '5c',
    22: '6a',
    23: '6b',
    24: '6c',
    25: '7a',
    26: '7b',
    27: '7c',
    28: '8a',
    29: '8b',
    30: '8c',
    31: '9a',
    32: '9b',
    33: '9c',
    34: '10a',
    35: '10b',
    36: '10c',
    37: '11a',
    38: '11b',
    39: '11c',
    40: '12a',
    41: '12b',
    42: '12c',
    43: '13a',
    44: '13b',
    45: '13c',
    46: '14a',
    47: '14b',
    48: '14c',
    49: '15a',
    50: '15b',
    51: '15c',
    52: '16a',
    53: '16b',
    54: '16c',
    55: '17a',
    56: '17b',
    57: '17c',
    58: '18a',
    59: '18b',
    60: '18c'
  };


  Map<dynamic, dynamic> get() {
    Map<dynamic, dynamic> v =  json.decode(new File("././assets/crags.json").readAsStringSync());
    print(v);
    return v["crags"];
  }

  String parseDifficulty(int diff) {
    return table[diff]!;
  }
}