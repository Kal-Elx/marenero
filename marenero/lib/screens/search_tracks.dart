import 'package:flutter/material.dart';

import '../models/my_track.dart';
import '../utils/spotify_api.dart';
import '../widgets/track_list_tile.dart';

class SearchTracks extends StatefulWidget {
  final String spotifyToken;
  final String userid;
  final Function(MyTrack) selectTrackCallback;
  final Function(bool)? onFocusChange;

  SearchTracks({
    required this.spotifyToken,
    required this.userid,
    required this.selectTrackCallback,
    this.onFocusChange,
  });

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
          await searchTracks(widget.spotifyToken, myController.text);
      setState(() {});
    }
  }

  _selectTrack(int i) {
    widget.selectTrackCallback(searchedTracks[i]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Focus(
          onFocusChange: widget.onFocusChange,
          child: Row(
            children: [
              Icon(Icons.search),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search for a song'),
                style: Theme.of(context).textTheme.bodyText1,
                controller: myController,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            itemCount: searchedTracks.length,
            itemBuilder: (_, i) => TrackListTile(
              title: searchedTracks[i].name,
              artists: searchedTracks[i].artists,
              cover: Image.network(
                searchedTracks[i]
                        .imageObjects[searchedTracks[i].imageObjects.length - 1]
                    ['url'],
                height: 50.0,
                width: 50.0,
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_circle_outline),
                color: Colors.white,
                onPressed: () {
                  widget.onFocusChange?.call(false);
                  FocusManager.instance.primaryFocus?.unfocus();
                  _selectTrack(i);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
