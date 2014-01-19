import "dart:async";
import "dart:io";
import "package:mpd/mpd.dart";

void main() {
  MPDController controller = new MPDController();
  
  // Start MPD.
  controller.startMPD()
  .then((Process mpdProcess) {
    // Print artists, then print a blank line, then albums.
    printArtists(controller).then((_) {
      print("");
      // Print albums.
      printAlbums(controller);      
    });
  });
}

/**
 * Prints all the artists in MPD's database.
 */
Future<List<String>> printArtists(MPDController controller) {
  // controller.list("artist") returns a future with all the artists in a list.
  return controller.list("artist")
      ..then((List<String> artists) {
        for(String artist in artists) {
          print(artist);
        }
      });  
}

/**
 * Prints all the albums in MPD's database.
 */
Future<List<String>> printAlbums(MPDController controller) {
  // controller.list("album") returns a future with all the albums in a list.
  return controller.list("album")
      ..then((List<String> albums) {
        for(String album in albums) {
          print(album);
        }
      });  
}