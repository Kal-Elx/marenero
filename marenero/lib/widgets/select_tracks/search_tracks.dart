import 'package:flutter/material.dart';
import 'package:marenero/models/my_track.dart';

import 'package:marenero/utils/spotify_api.dart';
//import 'package:spotify_sdk/models/track.dart';

class SearchTracks extends StatefulWidget {
  final String spotifyAuthToken;
  final String userid;
  SearchTracks({required this.spotifyAuthToken, required this.userid});

  @override
  State createState() =>
      _SearchTracksState(spotifyAuthToken: spotifyAuthToken, userid: userid);
}

class _SearchTracksState extends State<SearchTracks> {
  final String spotifyAuthToken;
  final String userid;

  List<MyTrack> searchedTracks = [];

  final TextEditingController myController = TextEditingController();

  _SearchTracksState({required this.spotifyAuthToken, required this.userid});

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
      setState(() async {
        searchedTracks =
            await searchTracks(this.spotifyAuthToken, myController.text);
      });
    }
  }

  _selectTrack(MyTrack track) {
    print("User with ID \"${this.userid}\" selected track: ${track.name}.");
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
        ListView.builder(
          itemCount: searchedTracks.length,
          shrinkWrap: true,
          itemBuilder: (_, i) => Card(
            child: ListTile(
              //leading: FlutterLogo(size: 72.0), TODO: Album cover image?
              title: Text(searchedTracks[i].name),
              subtitle: Text(searchedTracks[i].artists.join(', ')),
              trailing: IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () => _selectTrack(searchedTracks[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}