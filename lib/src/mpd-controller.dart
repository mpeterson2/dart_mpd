part of MPD;

/**
 * This class allows a user to talk to MPD.
 * 
 * It has numerous methods on it to send requests and retrieve data from MPD.
 * For more documentation about the methods, visit the
 * [MPD Documentation](http://www.musicpd.org/doc/protocol/ch03.html)
 */
class MPDController extends MPDTalker {
  
  /**
   * Create an [MPDController]
   * 
   * String host: The host you are connecting to. Default: "localhost".
   * int port: The control port you are connecting to. Default: 6600.
   */
  MPDController({host: "localhost", port: 6600}) : super(host: host, port: port);
  
  /**
   * Starts MPD as and returns it's [Process].
   * 
   * String mpdCommand: The command to start MPD.
   * String mpdPath: The path to the folder where your mpd.conf file is located. Default: "mpd".
   * List<String> args: Arguments to pass to MPD. Default: ["--no-daemon", "mpd.conf"].
   */
  Future<Process> startMPD({String mpdCommand: "mpd", String mpdPath: "mpd", List<String> args}) {
    // Set args default here because it cannot be modifiable in the parameters list. 
    if(args == null)
      args = ["--no-daemon", "mpd.conf"];
    
    // Start MPD.
    return Process.start(mpdCommand, args, workingDirectory: mpdPath);
  }
  
  /*
   * Status Commands
   */
  
  /**
   * Clears the current error message in status.
   */
  Future clearError() {
    return cmd('clearerror');
  }
  /**
   * Displays the song info of the current song.
   */
  Future<Map<String, String>> currentSong() {
    return cmdMap('currentsong');
  }
  /**
   * Waits until there is a noteworthy change in one or more of MPD's subsystems. 
   * As soon as there is one, it response with it.
   */
  Future<Map<String, String>> idle({String subsystems}) {
    return cmdMap('idle $subsystems');
  }
  
  /**
   * Reports the current status of the player and the volume level.
   */
  Future<Map<String, String>> status() {
    return cmdMap('status');
  }
  
  /**
   * Displays statistics.
   */
  Future<Map<String, String>> stats() {
    return cmdMap('stats');
  }
  
  /*
   * Playback Options
   */
  
  /**
   * When consume is activated, each song played is removed from playlist.
   */
  Future consume(bool consume) {
    if(consume)
      return cmd('consume 1');
    else
      return cmd('consume 0');
  }
  
  /**
   * Sets crossfading between songs.
   */
  Future crossFade(int seconds) {
    return cmd('crossfade $seconds');
  }
  
  /**
   * Sets the threshold at which songs will be overlapped.
   */  
  Future mixRampDB(int decibels) {
    return cmd('mixrampdb $decibels');
  }
  
  /**
   * Additional time subtracted from the overlap calculated by mixrampdb.
   */
  Future mixRampDelay({int seconds, bool enabled: true}) {
    if(enabled)
      return cmd('mixrampdelay $seconds');
    else
      return cmd('mixrampdelay nan');
  }
  
  /**
   * Sets random state.
   */
  Future random(bool enabled) {
    if(enabled)
      return cmd('random 1');
    else
      return cmd('random 0');
  }
  
  /**
   * Sets repeat state.
   */
  Future repeat(bool enabled) {
    if (enabled)
      return cmd('repeat 1');
    else
      return cmd('repeat 0');
  }
  
  /**
   * Sets the volume.
   */
  Future setVol(int vol) {
    return cmd('setvol $vol');
  }
  
  /**
   * When single is activated, playback is stopped after current song,
   * or song is repeated if the 'repeat' mode is enabled.
   */
  Future single(bool enable) {
    if(enable)
      return cmd('single 1');
    else
      return cmd('single 0');
  }
  
  /**
   * Sets the replay gain mode.
   */
  Future replayGainMode(String mode) {
    return cmd('replay_gain_mode $mode');
  }
  
  /**
   * Prints replay gain options.
   */
  Future<Map<String, String>> replayGainStatus() {
    return cmdMap('replay_gain_status');
  }

  /*
   * Controlling Playback
   */
  
  /**
   * Plays next song in the playlist.
   */
  Future next() {
    return cmd('next');
  }
  
  /**
   * Toggles pause/resumes playing.
   */
  Future pause({bool enabled: true}) {
    if(enabled)
      return cmd('pause 1');
    else
      return cmd('pause 0');
  }
  
  /**
   * Begins playing the playlist.
   */
  Future play({int songPos}) {
    if(songPos != null)
      return cmd('play $songPos');
    else
      return cmd('play');
  }
  
  /**
   * Begins playing the playlist.
   */
  Future playID(int songID) {
    return cmd('playid $songID');
  }
  
  /**
   * Plays previous song in the playlist.
   */
  Future previous() {
    return cmd('previous');
  }
  
  /**
   * Seeks to the position time (in seconds) of entry songPos in the playlist
   */
  Future seek(int songPos, int time) {
    return cmd('seek $songPos $time');
  }
  
  /**
   * Seeks to the position time (in seconds) of song songID.
   */
  Future seekID(int songID, int time) {
    return cmd('seekid $songID $time');
  }
  
  /**
   * Seeks to the position time within the current song.
   */
  Future seekCur(int time) {
    return cmd('seekcur $time');
  }
  
  /**
   * Stops playing.
   */
  Future stop() {
    return cmd('stop');
  }
  
  /*
   *  The Current Playlist
   */
  
  /**
   * Adds the file URI to the playlist.
   */
  Future<String> add(String uri) {
    return cmdStr('add "$uri"');
  }
  
  /**
   * Adds a song to the playlist and returns the song id.
   */
  Future<Map<String, String>> addID(int songID, {int pos}) {
    if(pos != null)
      return cmdMap('addid $songID $pos');
    else
      return cmdMap('addid $songID');
  }
  
  /**
   * Clears the current playlist.
   */
  Future clear() {
    return cmd('clear');
  }
  
  /**
   * Deletes a song from the playlist.
   */
  Future delete(int start, {int end}) {
    if(end != null)
      return cmd('delete $start $end');
    else
      return cmd('delete $start');
  }
  
  /**
   * Deletes a song from the playlist.
   */
  Future deleteID(int songID) {
    return cmd('deleteid $songID');
  }
  
  /**
   * Moves a song in the playlist.
   */
  Future move(int start, int to, {int end}) {
    if(end != null)
      return cmd('move $start $end $to');
    else
      return cmd('move $start $to');
  }
  
  /**
   * Moves a song in the playlist.
   */
  Future moveID(int songID, int to) {
    return cmd('moveid $songID $to');
  }
  
  /**
   * Finds songs in the current playlist with strict matching.
   */
  Future<List<Map<String, String>>> playlistFind(String tag, String what) {
    return cmdListMap('playlistfind "$tag" "$what"');
  }
  
  /**
   * Displays a list of songs in the playlist.
   */
  Future<List<Map<String, String>>> playlistID({int songID}) {
    if(songID != null)
      return cmdListMap('playlistid $songID');
    else
      return cmdListMap('playlistid');
  }
  
  /**
   * Displays a list of all songs in the playlist.
   */
  Future<List<Map<String, String>>> playlistInfo({int start, int end}) {
    if(start != null && end != null)
      return cmdListMap('playlistinfo $start $end');
    else if(start != null)
      return cmdListMap('playlistinfo $start');
    else
      return cmdListMap('playlistinfo');
  }
  
  /**
   * Searches case-sensitively for partial matches in the current playlist.
   */
  Future<List<Map<String, String>>> playlistSearch(int start, {int end}) {
    if(end != null)
      return cmdListMap('playlistsearch $start $end');
    else
      return cmdListMap('playlistsearch $start');
  }
  
  /**
   * Displays changed songs currently in the playlist since version.
   */
  Future<List<Map<String, String>>> plChanges(int version) {
    return cmdListMap('playlistchanges $version');
  }
  
  /**
   * Displays changed songs currently in the playlist since version.
   */
  Future<List<Map<String, String>>> plChangesPosID(int version) {
    return cmdListMap('playlistchangesposid $version", newKey: "cpos');
  }
  
  /**
   * Set the priority of the specified songs.
   * 
   * A higher priority means that it will be played first when "random" mode is enabled.
   * A priority is an integer between 0 and 255. The default priority of new songs is 0.
   */
  Future prio(int priority, int start, {int end}) {
    if(end != null)
      return cmd('prio $priority $start $end');
    else
      return cmd('prio $priority $start');
  }
  
  /**
   * Set the priority of the specified songs.
   * 
   * A higher priority means that it will be played first when "random" mode is enabled.
   * A priority is an integer between 0 and 255. The default priority of new songs is 0.
   */
  Future prioID(int priority, int songID) {
    return cmd('prioID $priority $songID');
  }
  
  /**
   * Shuffles the current playlist.
   */
  Future shuffle({int start, int end}) {
    if(start != null && end != null)
      return cmd('shuffle $start $end');
    else if(start != null)
      return cmd('shuffle $start');
    else
      return cmd('shuffle');
  }
  
  /**
   * Swaps the positions of two songs.
   */
  Future swap(int song1, int song2) {
    return cmd('swap $song1 $song2');
  }
  
  /**
   * Swaps the positions of two songs.
   */
  Future swapID(int songID1, int songID2) {
    return cmd('swap $songID1 $songID2');    
  }
  
  /**
   * Adds a tag to the specified song.
   */
  Future addTagID(int songID, String tag, String value) {
    return cmd('addtagid $songID "$tag" "$value"');
  }
  
  /**
   * Removes tags from the specified song.
   */
  Future clearTagID(int songID, String tag) {
    return cmd('cleartagid $songID "$tag"');
  }
  
  /*
   *  Stored Playlists
   */
  
  /**
   * Lists the songs in the playlist.
   */
  Future<List<Map<String, String>>> listPlaylist(String name) {
    return cmdListMap('listplaylist "$name"');
  }
  
  /**
   * Lists the songs with metadata in the playlist.
   */
  Future<List<Map<String, String>>> listPlaylistInfo(String name) {
    return cmdListMap('listplaylistinfo "$name"');
  }
  
  /**
   * Prints a list of the playlist directory.
   */
  Future<List<Map<String, String>>> listPlaylists() {
    return cmdListMap('listplaylists', newKey: 'playlist');
  }
  
  /**
   * Loads the playlist into the current queue.
   */
  Future load(String name, {int start, int end}) {
    if(start != null && end != null)
      return cmd('load "$name" $start $end');
    else if(start != null)
      return cmd('load "$name" $start');
    else
      return cmd('load');
  }
  
  /**
   * Adds URI to a playlist
   */
  Future playlistAdd(String name, String uri) {
    return cmd('playlistadd "$name" "$uri"');
  }
  
  /**
   * Clears a playlist.
   */
  Future playlistClear(String name) {
    return cmd('playlistclear "$name"');
  }
  
  /**
   * Deletes a song from a playlist.
   */
  Future playlistDelete(String name, int songPos) {
    return cmd('playlistdelete "$name" $songPos');
  }
  
  /**
   * Moves a song in a playlist to a new position.
   */
  Future playlistMove(String name, int songID, int songPos) {
    return cmd('playlistmove "$name" $songID $songPos');
  }
  
  /**
   * Renames a playlist.
   */
  Future playlistRename(String name, String newName) {
    return cmd('rename "$name" "$newName"');
  }
  
  /**
   * Deletes a playlist.
   */
  Future playlistRemove(String name) {
    return cmd('rm "$name"');
  }
  
  /**
   * Saves a playlist.
   */
  Future playlistSave(String name) {
    return cmd('save $name');
  }
  
  /*
   *  The Music Database
   */
  
  /**
   * Counts the number of songs and their total playtime in the db matching tag.
   */
  Future<Map<String, String>> count(String tag, String what) {
    return cmdMap('count "$tag" "$what"');
  }
  
  /**
   * Finds a song in the database.
   */
  Future<List<Map<String, String>>> find(String request) {
    return cmdListMap('find $request');
  }
  
  /**
   * Finds a song in the database and adds it to the current playlist.
   */
  Future findAdd(String request) {
    return cmd('findadd $request');
  }
  
  /**
   * Lists all tags of a specified type.
   */
  Future<List<String>> list(String type, {String artist}) {
    if(artist != null)
      return cmdList('list "$type" "$artist"');
    else
      return cmdList('list $type');
  }
  
  /**
   * Lists all songs and directories in uri.
   */
  Future<List<String>> listAll({String uri}) {
    if(uri != null)
      return cmdList('listall "$uri"');
    else
      return cmdList('listall');
  }
  
  /**
   * Lists all songs and directories in uri with metadata.
   */
  Future<List<Map<String, String>>> listAllInfo({String uri}) {
    if(uri != null)
      return cmdListMap('listallinfo "$uri"');
    else
      return cmdListMap('listallinfo');
  }
  
  /**
   * Lists the contents of the directory URI.
   */
  Future<List<Map<String, String>>> lsInfo({String uri}) {
    if(uri != null)
      return cmdListMap('lsinfo "$uri"');
    else
      return cmdListMap('lsinfo');
  }
  
  /**
   * Reads a file's comments.
   */
  Future<Map<String, String>> readComments(String uri) {
    return cmdMap('readcomments "$uri"');
  }
  
  /**
   * Searches for a song.
   */
  Future<List<Map<String, String>>> search(String request) {
    return cmdListMap('search $request');
  }
  
  /**
   * Searches for and adds a song to the current playlist.
   */
  Future searchAdd(String request) {
    return cmd('searchadd $request');
  }
  
  /**
   * Searches for and adds a song to the specified playlist.
   */
  Future searchAddPlaylist(String name, String request) {
    return cmd('searchaddpl "$name" $request');
  }
  
  /**
   * Updates the database excluding unmodified files.
   */
  Future update({String uri}) {
    if(uri != null)
      return cmd('update "$uri"');
    else
      return cmd('update');
  }
  
  /**
   * Updates the database including unmodified files.
   */
  Future rescan({String uri}) {
    if(uri != null)
      return cmd('rescan "$uri"');
    else
      return cmd('rescan');
  }
}