import "dart:async";
import "dart:io";
import "package:mpd/mpd.dart";

void main() {
  // Create the object.
  MPDController controller = new MPDController();

  // Start MPD if you need to.
  controller.startMPD()
  .then((Process process) {
    // Start asking MPD for things.
    controller.clear();
    controller.add("path_to_file");
    controller.play();

    new Timer(new Duration(seconds: 10), () {
      controller.add("path_to_file_2");
      controller.next();      
    });
  });
}