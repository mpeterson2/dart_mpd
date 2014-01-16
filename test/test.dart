import "dart:async";
import "dart:io";
import "package:dart_mpd/mpd.dart";
import "package:unittest/unittest.dart";


void main() {
  List<Future> waitFor = new List<Future>();
  
  test("Start", () {
    MPDController controller = new MPDController();
    
    Future startMPD = controller.startMPD();
    waitFor.add(startMPD);
    startMPD.then((Process pro) {
      if(pro == null || pro.pid == null)
        fail("MPD did not start");
    });
  });
  
  test("Commands", () {
    MPDController controller = new MPDController();Future startMPD = controller.startMPD();
    startMPD.then((Process pro) {
      waitFor.add(controller.play());
      waitFor.add(controller.next());
      waitFor.add(controller.add("dsf"));
    });
    waitFor.add(startMPD);
  });

  Future.wait(waitFor);
}