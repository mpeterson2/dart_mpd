#dart_mpd


A [MPD](http://www.musicpd.org/) wrapper for [Dart](http://dartlang.org).

## What does it do?

dart_mpd is a wrapper for MPD. It just makes it easy for someone to start up mpd and control it. Instead of having to deal with the protocol yourself, you can let dart_mpd handle it.

## How to use it

Just import the package, create an `MPDController` object, and start using it.

```dart
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
```

More examples can be found [here](https://github.com/mpeterson2/dart_mpd/tree/master/example).

## Contributing

If you would like to contribute, feel free to fork it and send me a pull request. Everything is pretty well documented.