import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:marenero/models/track.dart';

class ListDisplay extends StatefulWidget {
  final String spotifyAuthToken;
  ListDisplay({
    required this.spotifyAuthToken,
  });

  @override
  State createState() => DyanmicList(spotifyAuthToken: spotifyAuthToken);
}

class DyanmicList extends State<ListDisplay> {
  List<Track> queriedTracks = [];
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
          "https://api.spotify.com/v1/search?q=${myController.text.replaceAll(' ', '%20')}&type=track&market=SE&limit=10";
      final response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${this.spotifyAuthToken}'});
      final responseData = json.decode(response.body);

      setState(() {
        try {
          final trackObjects = responseData['tracks']['items'] as List;
          queriedTracks = trackObjects.map((t) => Track.fromJson(t)).toList();
        } catch (error) {
          queriedTracks.clear();
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
            itemCount: queriedTracks.length,
            itemBuilder: (_, i) => Card(
              child: ListTile(
                //leading: FlutterLogo(size: 72.0), TODO: Album cover image?
                title: Text(queriedTracks[i].name),
                subtitle: Text(queriedTracks[i].artists.join(', ')),
                trailing: Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
