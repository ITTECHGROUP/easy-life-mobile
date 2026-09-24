import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class CommentProvider extends ChangeNotifier {
  final String _baseUrl = Constants.baseUrl;

  CommentProvider();

  postComment(String comment, String id, String token) async {
    var url = Uri.parse('$_baseUrl/api/v1/comment/register/');

    final response = await http.post(
      url,
      body: {
        "comment": comment,
        "account": id,
      },
      headers: {
        'Authorization': 'Token $token',
      },
    );

    return response.statusCode == 201 ? false : true;
  }
}
