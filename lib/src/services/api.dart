import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixels_assignment/src/model/model.dart';

Future<UserDetails> fetchdetails() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/users'));
  if (response.statusCode == 200) {
    return UserDetails.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else { 
    throw Exception('Failed to load album');
  }
}