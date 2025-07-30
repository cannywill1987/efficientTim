import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';

class FamousSentenceWidget extends StatefulWidget {
  @override
  _FamousSentenceWidgetState createState() => _FamousSentenceWidgetState();
}

class _FamousSentenceWidgetState extends State<FamousSentenceWidget> {
  List<String> quotes = [];
  String famousSentence = "";

  @override
  void initState() {
    super.initState();
    famousSentence = Utility.getSplashFamousSentence();
    // fetchQuotes();
  }

  // Future<void> fetchQuotes() async {
  //   final response = await http.get(Uri.parse('https://api.quotable.io/quotes?limit=20'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as List<dynamic>;
  //     setState(() {
  //       quotes = data.map((quote) => quote['content'] as String).toList();
  //     });
  //   } else {
  //     throw Exception('Failed to fetch quotes');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 250),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Utility.getSVGPicture(R.assetsImgIcQuoteLeft, size: 30),
          Text(
            this.famousSentence,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Utility.getSVGPicture(R.assetsImgIcQuoteRight, size: 30)
        ],
      ),
    );

  }
}
