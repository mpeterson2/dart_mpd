import "dart:async";
import "dart:io";
import "package:mpd/mpd.dart";

void main() {
  // Create the object.
  MPDController controller = new MPDController();

  // Start MPD.
  controller.startMPD()
  .then((Process process) {
    // Start asking MPD for things.
    
    // Clear the current playlist.
    controller.clear();
    
    // Add the song with an ID of 0. You can also use `add` to add a file path.
    controller.addID(0);
    
    // Start playing.
    controller.play();

    // Wait so we can listen to the first 10 seconds of the first song.
    new Timer(new Duration(seconds: 10), () {
      // Add a song with an ID of 1.
      controller.addID(1);
      
      // Play the next song.
      controller.next();      
    });
  });
}