part of MPD;

/**
 * This class allows a user to talk to MPD.
 * 
 * It allows for sending arbitrary requests to MPD and getting the data back
 * how you want it.
 * 
 * For documentation on MPD commands, visit the [MPD Documentation](http://www.musicpd.org/doc/protocol/ch03.html).
 */
class MPDTalker {
  String host;
  int port;
  
  MPDTalker({this.host: "localhost", this.port: 6600});

  /**
   * Send a request to MPD and get the output as a String.
   */
  Future<String> cmdStr(String cmd) {
    Completer<String> com = new Completer<String>();
    String data = "";
    
    Socket.connect(host, port)
      .then((Socket socket) {
        socket.write("$cmd\n");
        
        socket.listen((List<int> chars) {
          String line = new String.fromCharCodes(chars);
          data += line;
          
          if(_atEnd(line)) {
            socket.close();
          }
        },
        onDone: () {
          com.complete(data);
        });
      });
    
    return com.future;
  }
  
  /**
   * Check if MPD is done sending data.
   */
  bool _atEnd(String str) {
    return str.endsWith("OK\n"); //||
        // TODO This should work but it doesn't...
        //str.contains(new RegExp("ACK \[[0-9]?([0-9])@[0-9]?([0-9])\]"));
        //str.contains("ACK [");
  }
  
  /**
   * Send a request to MPD and get the output as a List of Strings.
   */
  Future<List<String>> cmdList(String cmd) {
    Completer com = new Completer();
    
    cmdStr(cmd).then((String dataStr) {
      List<String> data = new List<String>();
      for(String line in dataStr.split("\n")) {
        List<String> kv = line.split(":");
        if(kv.length > 1)
          data.add(kv[1].trim());
      }
      
      com.complete(data);
    });
    
    return com.future;
  }
  
  /**
   * Send a request to MPD and get the output as a Map of Strings keyed to Strings.
   */  
  Future<Map<String, String>> cmdMap(String cmd) {
    Completer com = new Completer();
    
    cmdStr(cmd).then((String dataStr) {
      Map<String, String> data = new Map<String, String>();
      for(String line in dataStr.split("\n")) {
        List<String> kv = line.split(":");
        if(kv.length > 1) {
          data[kv[0].trim()] = kv[1].trim();
        }
      }
      
      com.complete(data);
    });
    
    return com.future;
  }
  
  /**
   * Send a request to MPD and get the output as a List of Maps of Strings keyed to Strings.
   * 
   * String newKey: The key that defines a new item in the list. 
   */
  Future<List<Map<String, String>>> cmdListMap(String cmd, {String newKey: "file"}) {
    Completer com = new Completer();
    
    cmdStr(cmd).then((String dataStr) {
      List<Map<String, String>> data = new List<Map<String, String>>();
      
      for(String line in dataStr.split("\n")) {
        List<String> kv = line.split(":");
        if(kv.length > 1) {
          if(kv[0].trim() == newKey) {
            data.add(new Map<String, String>());
          }
          if(data.isNotEmpty) {
            data.last[kv[0].trim()] = kv[1].trim();
          }
        }
      }
    });
  }
}