import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListDisplay extends StatefulWidget {
  final String spotifyAuthToken;
  ListDisplay({
    required this.spotifyAuthToken,
  });

  @override
  State createState() => DyanmicList(spotifyAuthToken: spotifyAuthToken);
}

class DyanmicList extends State<ListDisplay> {
  List<String> litems = [];
  final String spotifyAuthToken;
  final TextEditingController myController = TextEditingController();

  DyanmicList({
    required this.spotifyAuthToken,
  });

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(_queryTracks);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    myController.dispose();
    super.dispose();
  }

  _queryTracks() async {
    if (myController.text.isNotEmpty) {
      String url =
          "https://api.spotify.com/v1/search?q=${myController.text.replaceAll(' ', '%20')}&type=track&market=SE&limit=5";
      final response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${this.spotifyAuthToken}'});
      final responseData = json.decode(response.body);

      setState(() {
        try {
          final tracks = responseData['tracks']['items'] as List;
          litems = tracks.map((t) => t['name'] as String).toList();
        } catch (error) {
          litems.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext ctxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Search for a song'),
          style: Theme.of(context).textTheme.bodyText1,
          controller: myController,
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 3,
          ),
          child: ListView.builder(
            itemCount: litems.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(
                litems[i],
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
