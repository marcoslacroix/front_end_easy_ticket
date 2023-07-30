
Map<String, String> convertMapToStrings(Map<dynamic, dynamic> map) {
  final convertedMap = <String, String>{};
  map.forEach((key, value) {
    convertedMap[key.toString()] = value.toString();
  });
  return convertedMap;
}
