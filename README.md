# TDDD27 2021 Marenero

## TL;DR
Marenero is a web application where a group of friends (e.g., on a pre-party) creates and joins a game session, chooses a few banger Spotify songs each, and then competes in guessing who in the group queued which song. The preliminary idea is to develop it using Flutter and Firebase.
Terms of Service Dealbreaker?
Spotify Developer Terms of Service > Section IV: Restrictions > 3. Spotify content restrictions > c. Games and trivia quizzes:
"Unless you receive Spotify’s written approval, you shall not use the Spotify Platform to incorporate Spotify Content into any game functionality (including trivia quizzes)."


## Background / Description (functional)
The idea behind Marenero is the pre-party compatible “queueing game” where the phone belonging to the evening’s Spotify DJ is passed around to the party participants who queues three songs each, without peeking at what has been searched for and queued so far. When the owner gets the phone back, he or she does his or her best to manually shuffle the queue order – something that is easier said than done (and that can cause Spotify to crash). Then the songs in the queue are played and after about 1 minute into each song, the participants must guess who queued the song by pointing at that person. Marenero intends to "appify" this game.
Marenero takes inspiration from other semi-social mobile games such as Kahoot, Photo Roulette and Psych! where the participants – preferably in each other's presence – join a session led by a host. Before the start of the game, all participants can search for songs that are on Spotify (via the Web API, should not require being signed-in?) and select these as their contributions to the game. (Alternatively, perhaps, you could agree to log in with Spotify to get song suggestions based on what you are listening to most right now, or simply let the application choose songs for you.)
All participants' song entries are collected, the order randomized, and they are placed on some kind of queue or list (the most suitable Web API solution). If not before, then about now the host would need to log in / give access to their Spotify account so that the music can be played and / or a playlist generated, etc. Then there will be a Kahoot-like competition in guessing (fastest?) who queued the currently playing song. There is room for point streaks and other fun stuff. And at the end, the winner and other fun statistics are presented.

## Development (technological)
The preliminary idea is to develop Marenero using Flutter, a development kit for developing cross-platform applications for mobile, web and desktop with a single (Dart) code base. If Flutter is found insufficient, the back-up option is React based development.
On the serverside there will be a serverless Firebase setup using Firestore and Cloud Functions together with Spotify’s Web API.
