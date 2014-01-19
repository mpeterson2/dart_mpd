import "package:mpd/mpd.dart";

import "dart:io";

void main() {
  MPDController controller = new MPDController();
  
  // Start MPD.
  controller.startMPD()
    .then((Process p) {
      // Print MPD's stdout.
      p.stdout.listen((List<int> ints) {
        print("MPD: ${new String.fromCharCodes(ints)}");
      });

      // Print MPD's stderr.
      p.stderr.listen((List<int> ints) {
        print("MPD: ${new String.fromCharCodes(ints)}");
      });
    });
  
  // Run commands through stdin and prints the response.
  stdin.listen((List<int> ints) {
    controller.cmdStr(new String.fromCharCodes(ints).trim())
      .then((String response) {
        print(response);
      },
      onError: (error) {
        print(error);
      });
  });
}