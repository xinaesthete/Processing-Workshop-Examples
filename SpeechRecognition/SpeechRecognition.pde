/** 

Speech recognition example... copied from http://stt.getflourish.com
uses to connect to a websocket in a webpage ("sender.html") running in Chrome... 
This won't work if you just open the html page from file://... it needs to be run
from a web server... quick way of doing that if you have Python installed (eg, if 
you're on a mac you probably do) is to go to the folder of this sketch in Terminal
and run "python -m SimpleHTTPServer", then open "localhost:8000/sender.html" in
your browser.


websocketP5 library from http://muthesius.github.io/WebSocketP5/websocketP5-0.2.0/
needs to be copied into Processing sketchbook libraries folder.
You can find where that is by looking at the setting in Processing Preferences: 
~/Documents/Processing/libraries on OSX (& probably linux)

It would probably be better to package up these examples as a sketchbook, so that
the deps could go into git.

*/


import muthesius.net.*;
import org.webbitserver.*;

WebSocketP5 server;
String lastMsg;

void setup() {
  size(400, 300);
  server = new WebSocketP5(this,8080);
}

void draw() {
  background(255);
  fill(0);
  if (lastMsg != null) {
    text(lastMsg, 10, 10);
  }
}

void stop(){
  server.stop();
}

void mousePressed(){
  server.broadcast("hello from processing!");
}

void websocketOnMessage(WebSocketConnection con, String msg){
  println(msg);
  lastMsg = msg;
}

void websocketOnOpen(WebSocketConnection con){
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con){
  println("A client left");
}