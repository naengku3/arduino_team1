import processing.serial.*;
import processing.net.*;
Serial p;
Server s;
Client c;

void setup() {
  p = new Serial(this, "COM11", 9600);
  s = new Server(this, 123);
}

String msg="hi"; //초기값 hi
void draw() {
  c = s.available();
  if (c!=null) {
    
    String m = c.readString();
    if (m.indexOf("GET /")==0) {
      c.write("HTTP/1.1 200 OK\r\n\r\n"); //스마트폰으로 보내기
      c.write(msg);
    }
    c.stop(); //요청을 무한대로 받지않기 위해 닫았다 열어주기
    
    if (m.indexOf("PUT /")==0) { //아두이노로 보내기
      int n = m.indexOf("\r\n\r\n")+4; // on-off 위치
      //4바이트의 구분자 HTTP요청 본문 잘라내기
      m = m.substring(n); // on-off 잘라 내는 위치   //
      m += '\n';           // 표시할 문자
      p.write(m); // 시리얼 포트로 on-off 보내기 
      print(m);
    }
  }
  if (p.available()>0) { // 시리얼 데이터 읽기
    String m = p.readStringUntil('\n');
    if (m!=null)  msg = m; //hi값을 아두이노에서 받은 데이터로
    print(msg);
  }
}
