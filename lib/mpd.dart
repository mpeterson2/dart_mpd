library MPD;

import "dart:async";
import "dart:io";

part "src/mpd-controller.dart";
part "src/mpd-talker.dart";


/**
 * An error for MPD.
 */
class MPDError extends Error {
  String msg;
  MPDError(this.msg) : super();
  
  String toString() {
    return "MPD Error: $msg";
  }
}