import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';

import 'package:marenero/utils/spotify_api.dart';
//import 'package:spotify_sdk/models/track.dart';

class SearchTracks extends StatefulWidget {
  final String spotifyAuthToken;
  final String userid;
  final Function(MyTrack) callback;

  SearchTracks(
      {required this.spotifyAuthToken,
      required this.userid,
      required this.callback});

  @override
  State createState() => _SearchTracksState();
}

class _SearchTracksState extends State<SearchTracks> {
  List<MyTrack> searchedTracks = [];

  final TextEditingController myController = TextEditingController();

  _SearchTracksState();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(_searchTracks);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    myController.dispose();
    super.dispose();
  }

  _searchTracks() async {
    if (myController.text.isNotEmpty) {
      searchedTracks =
          await searchTracks(widget.spotifyAuthToken, myController.text);
      setState(() {});
    }
  }

  _selectTrack(int i) {
    widget.callback(searchedTracks[i]);
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
        Expanded(
          child: ListView.builder(
              itemCount: searchedTracks.length,
              itemBuilder: (_, i) => Card(
                  color: Colors.lightGreen,
                  child: ListTile(
                    key: Key(searchedTracks[i].spotifyURI),
                    //leading: FlutterLogo(size: 72.0), TODO: Album cover image?
                    title: Text(searchedTracks[i].name),
                    subtitle: Text(searchedTracks[i].artists.join(', ')),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () => _selectTrack(i),
                    ),
                  ))),
        ),
      ],
    );
  }
}
