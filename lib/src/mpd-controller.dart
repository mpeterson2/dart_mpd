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
    if(args == null)
      args = ["--no-daemon", "mpd.conf"];
    return Process.start(mpdCommand, args, workingDirectory: mpdPath);
  }
  
  /*
   * Status Commands
   */
  
  /**
   * Clears the current error message in status.
   */
  Future<String> clearError() {
    return cmdStr('clearerror');
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
  Future<String> consume(bool consume) {
    if(consume)
      return cmdStr('consume 1');
    else
      return cmdStr('consume 0');
  }
  
  /**
   * Sets crossfading between songs.
   */
  Future<String> crossFade(int seconds) {
    return cmdStr('crossfade $seconds');
  }
  
  /**
   * Sets the threshold at which songs will be overlapped.
   */  
  Future<String> mixRampDB(int decibels) {
    return cmdStr('mixrampdb $decibels');
  }
  
  /**
   * Additional time subtracted from the overlap calculated by mixrampdb.
   */
  Future<String> mixRampDelay({int seconds, bool enabled: true}) {
    if(enabled)
      return cmdStr('mixrampdelay $seconds');
    else
      return cmdStr('mixrampdelay nan');
  }
  
  /**
   * Sets random state.
   */
  Future<String> random(bool enabled) {
    if(enabled)
      return cmdStr('random 1');
    else
      return cmdStr('random 0');
  }
  
  /**
   * Sets repeat state.
   */
  Future<String> repeat(bool enabled) {
    if (enabled)
      return cmdStr('repeat 1');
    else
      return cmdStr('repeat 0');
  }
  
  /**
   * Sets the volume.
   */
  Future<String> setVol(int vol) {
    if(vol > 100 || vol < 0)
      throw new MPDError('Invalid volume range. The range is 0 - 100.');
    else
      return cmdStr('setvol $vol');
  }
  
  /**
   * When single is activated, playback is stopped after current song,
   * or song is repeated if the 'repeat' mode is enabled.
   */
  Future<String> single(bool enable) {
    if(enable)
      return cmdStr('single 1');
    else
      return cmdStr('single 0');
  }

  static final String REPLAY_GAIN_MODE_ALBUM = "album";
  static final String REPLAY_GAIN_MODE_AUTO = "auto";
  static final String REPLAY_GAIN_MODE_OFF = "off";
  static final String REPLAY_GAIN_MODE_TRACK = "track";
  
  /**
   * Sets the replay gain mode.
   */
  Future<String> replayGainMode(String mode) {
    if(mode != REPLAY_GAIN_MODE_ALBUM || mode != REPLAY_GAIN_MODE_AUTO || 
        mode != REPLAY_GAIN_MODE_OFF || mode != REPLAY_GAIN_MODE_TRACK)
      throw new MPDError("Invalid replay gain mode. Valid modes are: "
          "$REPLAY_GAIN_MODE_ALBUM, $REPLAY_GAIN_MODE_AUTO, "
          "$REPLAY_GAIN_MODE_OFF, $REPLAY_GAIN_MODE_TRACK");
    else
      return cmdStr('replay_gain_mode $mode');
      
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
  Future<String> next() {
    return cmdStr('next');
  }
  
  /**
   * Toggles pause/resumes playing.
   */
  Future<String> pause({bool enabled: true}) {
    if(enabled)
      return cmdStr('pause 1');
    else
      return cmdStr('pause 0');
  }
  
  /**
   * Begins playing the playlist.
   */
  Future<String> play({int songPos}) {
    if(songPos != null)
      return cmdStr('play $songPos');
    else
      return cmdStr('play');
  }
  
  /**
   * Begins playing the playlist.
   */
  Future<String> playID(int songID) {
    return cmdStr('playid $songID');
  }
  
  /**
   * Plays previous song in the playlist.
   */
  Future<String> previous() {
    return cmdStr('previous');
  }
  
  /**
   * Seeks to the position time (in seconds) of entry songPos in the playlist
   */
  Future<String> seek(int songPos, int time) {
    return cmdStr('seek $songPos $time');
  }
  
  /**
   * Seeks to the position time (in seconds) of song songID.
   */
  Future<String> seekID(int songID, int time) {
    return cmdStr('seekid $songID $time');
  }
  
  /**
   * Seeks to the position time within the current song.
   */
  Future<String> seekCur(int time) {
    return cmdStr('seekcur $time');
  }
  
  /**
   * Stops playing.
   */
  Future<String> stop() {
    return cmdStr('stop');
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
  Future<Map<String, String>> addID(String uri, int pos) {
    return cmdMap('addid, "$uri" $pos');
  }
  
  /**
   * Clears the current playlist.
   */
  Future<String> clear() {
    return cmdStr('clear');
  }
  
  /**
   * Deletes a song from the playlist.
   */
  Future<String> delete(int start, {int end}) {
    if(end != null) {
      if(end < start)
        throw new MPDError('Invalid input. start must be less than end.');
      else
        return cmdStr('delete $start $end');
    }
    else
      return cmdStr('delete $start');
  }
  
  /**
   * Deletes a song from the playlist.
   */
  Future<String> deleteID(int songID) {
    return cmdStr('deleteid $songID');
  }
  
  /**
   * Moves a song in the playlist.
   */
  Future<String> move(int start, int to, {int end}) {
    if(end != null) {
      if(end < start)
        throw new MPDError('Invalid input. start must be less than end.');
      else
        return cmdStr('move $start $end $to');
    }
    else
      return cmdStr('move $start $to');
  }
  
  /**
   * Moves a song in the playlist.
   */
  Future<String> moveID(int songID, int to) {
    return cmdStr('moveid $songID $to');
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
    if(start != null && end != null) {
      if(end < start)
        throw new MPDError('Invalid input. start must be less than end.');
      else
        return cmdListMap('playlistinfo $start $end');
    }
    else if(start != null)
      return cmdListMap('playlistinfo $start');
    else
      return cmdListMap('playlistinfo');
  }
  
  /**
   * Searches case-sensitively for partial matches in the current playlist.
   */
  Future<List<Map<String, String>>> playlistSearch(int start, {int end}) {
    if(end != null) {
      if(end < start)
        throw new MPDError('Invalid input. start must be less than end.');
      else
        return cmdListMap('playlistsearch $start $end');
    }
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
  Future<String> prio(int priority, int start, {int end}) {
    if(priority < 0 || priority > 255)
      throw new MPDError('Invalid priority range. The range is 0 - 255.');
    else if(end < start)
      throw new MPDError('Invalid input. start must be less than end.');
    else if(end != null)
      return cmdStr('prio $priority $start $end');
    else
      return cmdStr('prio $priority $start');
  }
  
  /**
   * Set the priority of the specified songs.
   * 
   * A higher priority means that it will be played first when "random" mode is enabled.
   * A priority is an integer between 0 and 255. The default priority of new songs is 0.
   */
  Future<String> prioID(int priority, int songID) {
    if(priority < 0 || priority > 255)
      throw new MPDError('Invalid priority range. The range is 0 - 255.');
    else
      return cmdStr('prioID $priority $songID');
  }
  
  /**
   * Shuffles the current playlist.
   */
  Future<String> shuffle({int start, int end}) {
    if(start != null && end != null) {
      if(end < start)
        throw new MPDError('Invalid input. start must be less than end.');
      else
        return cmdStr('shuffle $start $end');
    }
    else if(start != null)
      return cmdStr('shuffle $start');
    else
      return cmdStr('shuffle');
  }
  
  /**
   * Swaps the positions of two songs.
   */
  Future<String> swap(int song1, int song2) {
    return cmdStr('swap $song1 $song2');
  }
  
  /**
   * Swaps the positions of two songs.
   */
  Future<String> swapID(int songID1, int songID2) {
    return cmdStr('swap $songID1 $songID2');    
  }
  
  /**
   * Adds a tag to the specified song.
   */
  Future<String> addTagID(int songID, String tag, String value) {
    return cmdStr('addtagid $songID "$tag" "$value"');
  }
  
  /**
   * Removes tags from the specified song.
   */
  Future<String> clearTagID(int songID, String tag) {
    return cmdStr('cleartagid $songID "$tag"');
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
  Future<List<String>> listPlaylists() {
    return cmdList('listplaylists');
  }
  
  /**
   * Loads the playlist into the current queue.
   */
  Future<String> load(String name, {int start, int end}) {
    if(start != null && end != null) {
      if(end < start)
        throw new MPDError('Invalid input. start must be less than end.');
      else
        return cmdStr('load "$name" $start $end');
    }
    else if(start != null)
      return cmdStr('load "$name" $start');
    else
      return cmdStr('load');
  }
  
  /**
   * Adds URI to a playlist
   */
  Future<String> playlistAdd(String name, String uri) {
    return cmdStr('playlistadd "$name" "$uri"');
  }
  
  /**
   * Clears a playlist.
   */
  Future<String> playlistClear(String name) {
    return cmdStr('playlistclear "$name"');
  }
  
  /**
   * Deletes a song from a playlist.
   */
  Future<String> playlistDelete(String name, int songPos) {
    return cmdStr('playlistdelete "$name" $songPos');
  }
  
  /**
   * Moves a song in a playlist to a new position.
   */
  Future<String> playlistMove(String name, int songID, int songPos) {
    return cmdStr('playlistmove "$name" $songID $songPos');
  }
  
  /**
   * Renames a playlist.
   */
  Future<String> playlistRename(String name, String newName) {
    return cmdStr('rename "$name" "$newName"');
  }
  
  /**
   * Deletes a playlist.
   */
  Future<String> playlistRemove(String name) {
    return cmdStr('rm "$name"');
  }
  
  /**
   * Saves a playlist.
   */
  Future<String> playlistSave(String name) {
    return cmdStr('save $name');
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
  Future<String> findAdd(String request) {
    return cmdStr('findadd $request');
  }
  
  /**
   * Lists all tags of a specified type.
   */
  Future<List<String>> list(String type, {String artist}) {
    if(artist != null) {
      if(type.toLowerCase() == "album")
        return cmdList('list "$type" "$artist"');
      else
        throw new MPDError('list should be "Album" for 3 arguments');
    }
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
  Future<String> searchAdd(String request) {
    return cmdStr('searchadd $request');
  }
  
  /**
   * Searches for and adds a song to the specified playlist.
   */
  Future<String> searchAddPlaylist(String name, String request) {
    return cmdStr('searchaddpl "$name" $request');
  }
  
  /**
   * Updates the database excluding unmodified files.
   */
  Future<String> update({String uri}) {
    if(uri != null)
      return cmdStr('update "$uri"');
    else
      return cmdStr('update');
  }
  
  /**
   * Updates the database including unmodified files.
   */
  Future<String> rescan({String uri}) {
    if(uri != null)
      return cmdStr('rescan "$uri"');
    else
      return cmdStr('rescan');
  }
}