# arduino_team1

---제작과정---
 
먼저 센싱부분에서 아두이노를 작업해주겠습니다. 구현해야하는것은 


스마트폰에서 
[On] 버튼을 누르면 아두이노의 13번 LED가 켜진다.
[Off] 버튼을 누르면 아두이노의 13번 LED가 꺼진다.
[Song] 버튼을 누르면 "도도솔솔라라솔"이 연주 된다.

 

아두이노에서
스위치를 붙이면 스마트폰 화면이 분홍색으로 바뀐다.
스위치를 떼면 스마트폰 화면이 하늘색으로 바뀐다.


이므로, 아두이노의 13번 LED를 작동하고, 노래가 연주되어야 하기때문에 피에조 스피커를 연결해야합니다. 4번핀으로 설정합니다. 
그리고 스위치를 붙이고 떼야하므로 스위치를 7번핀으로 설정해서 달아줄 것입니다.

LED는 보드에 있는걸 사용하고, 선을 아래와 같이 달아줍니다.

![20231010_204641_HDR](https://github.com/naengku3/arduino_team1/assets/127822478/c60362cd-b5a5-4138-a576-f1ab8ae82ac9)

위와같이 GND 2개와 7번핀 4번핀입니다.

![20231010_204645_HDR](https://github.com/naengku3/arduino_team1/assets/127822478/f80bcf96-4797-45ad-b282-fd77f4704848)

스피커에는 + -극을 주의해서 4번핀은 +극에, GND는 -극으로 연결해줍니다.

다음으로는 코드를 작성해야 합니다.


```c++
void setup() {  // 처음 한번실행

  pinMode(13, OUTPUT);   // 13번을 OUTPUT으로 지정 
  pinMode(7, INPUT_PULLUP);    // 7번을 INPUT으로 지정
  Serial.begin(9600);   // Serial 사용을 위해 시작
  
}

void loop() {   // 여러번 실행

  int sw = digitalRead(7);   // 7번핀으로 부터의 디지털정보를 읽고 변수 sw에 저장
    Serial.println(sw);   // Serial에 출력
    delay(1000);   // 1초의 딜레이

  String m = Serial.readStringUntil('\n');   // Serial 정보를 '\n'이 나올때까지 읽고 문자열 변수 m에 저장.
  if(m == "on") digitalWrite(13, HIGH);   // m이 "on"이면 13번 LED를 켜기
  if(m == "off") digitalWrite(13, LOW);   // m이 "off"이면 13번 LED를 끄기
  
  if(m == "song") {     // m이 "song"면 4번 피에조 스피커를 연주
    tone(4, 261, 500);   // 도
    delay(500);         // delay를 걸지않으면 겹쳐서 제일 앞의 하나만 출력 될 위험!
    tone(4, 261, 500);   // 도
    delay(500);
    tone(4, 392, 500);   // 솔
    delay(500);
    tone(4, 392, 500);   // 솔
    delay(500);
    tone(4, 440, 500);   // 라
    delay(500);
    tone(4, 440, 500);   // 라
    delay(500);
    tone(4, 392, 500);   // 솔
    delay(500);
  }
}
```
위와같이 아두이노의 코드를 작성해주었습니다. 각각의 설명은 주석을 참고해주세요.

이제 위에서 작성한 코드를 통해 서버와 Serial통신으로 데이터를 주고받을 준비가 되었습니다.
따라서 이번에는 서버의 코드를 processing으로 작성해줍니다.


```processing
import processing.serial.*;   //Serial 추가
import processing.net.*; //net 추가
Serial p; //Serial 변수 p지정
Server s; //Server 변수 s지정
Client c; //Client 변수 c지정

void setup() {
  p = new Serial(this, "COM11", 9600); //Serial 객체 생성
  s = new Server(this, 123); //Server 객체 생성
}

String msg="hi"; //초기문자열 "hi"
void draw() {
  c = s.available(); // Server가 사용할 수 있는 상태인지를 c에 저장
  if (c!=null) { // Server가 작동하면
    
    String m = c.readString(); // Client의 데이터를 m에 저장 
    if (m.indexOf("GET /")==0) { // GET으로 요청
      c.write("HTTP/1.1 200 OK\r\n\r\n"); // Client로 HTTP프로토콜을 통해 요청을 수락 보내기
      c.write(msg); // 본문에 Client 메세지를 보내기
    }
    c.stop(); //요청을 무한대로 받아 오류가 생기지 않기 위해 닫았다 열어주기
    
    if (m.indexOf("PUT /")==0) { //PUT으로 요청 
      int n = m.indexOf("\r\n\r\n")+4;
      // indexOf를 통해 "\r\n\r\n"구분자의 위치를 찾아주고 거기에 \r\n\r\n 만큼의 4바이트를 추가해주어서 HTTP 메시지 본문의 시작부분을 n에 저장 

      m = m.substring(n); // n부터시작해서 메시지 본문의 데이터(문자열)을 m에 저장
      m += '\n';           // 문자열 m에 띄어쓰기 추가
      p.write(m); // 시리얼 포트로 문자열 보내기
      print(m); // 문자열 processing에 출력
    }
  }
  if (p.available()>0) { // Serial 사용가능한지 확인
    String m = p.readStringUntil('\n'); // Serial을 통해 읽은 데이터를 m에 저장
    if (m!=null)  msg = m; // msg 값을 Serial을 통해 읽은 데이터로 저장
    print(msg); // 위의 값을 출력
  }
}
```
위와같이 processing의 코드를 작성해주었습니다. 각각의 설명은 주석을 참고해주세요. 
위에서 http 프로토콜로 요청하고 있는데, 구조는 이렇습니다.

[HTTP 요청 라인]
\r\n
[헤더 1: 값 1]
\r\n
[헤더 2: 값 2]
\r\n
...
\r\n
[HTTP 메시지 본문]
따라서 \r\n\r\n의 위치를 찾아주었던 것입니다.


다음으로는 마지막으로 Client 측의 앱인벤터를 통한 코드만 작성해주면 됩니다. 전체적인 것은 레파지토리에 첨부 된 파일을 참고해주세요.

![image](https://github.com/naengku3/arduino_team1/assets/127822478/760edc96-f9dc-4222-a34a-b6987b521abf)
버튼을 on off song 이렇게 세개 만들어줍니다.

![image](https://github.com/naengku3/arduino_team1/assets/127822478/b16a4dc0-336c-4db9-b64b-d53c7d78f4bd)
components 에는 web과 clock도 있습니다.

![image](https://github.com/naengku3/arduino_team1/assets/127822478/7452c12c-4818-4d7a-bdf0-0896c1350168)
web의 Url은 wife로 통신하기 때문에, 자신의 IPv4주소로 합니다.

![image](https://github.com/naengku3/arduino_team1/assets/127822478/df898d2b-3837-4bb9-9653-9e6a942040bd)
각 버튼에 대한 Client에서 Server로 문자열을 보내는 코드를 작성합니다.

![image](https://github.com/naengku3/arduino_team1/assets/127822478/8d8d2cc1-3cf6-4be4-8ec4-8bf89f543ba9)
Server에서 Client로는 1초마다 데이터를 받아오고, 받은 데이터를 비교하여, 스마트폰 배경의 색상을 변경합니다.


이렇게 모든 작업이 완료되었습니다. 이제 실행을 시켜보면, 스마트폰의 On버튼을 누르면, Client에서 "on"이라는 문자열을 wifi를 통해 보내 Server에서 받아 Serial통신으로 아두이노로 보내서. 
아래와같이 불이 켜지고
![20231010_203305_HDR](https://github.com/naengku3/arduino_team1/assets/127822478/a50bddf1-5544-428e-8043-326945d24f9e)

스마트폰의 Off버튼을, 누르면 "off"를 보내서, 아래와같이 불이 꺼집니다.
![20231010_203313_HDR](https://github.com/naengku3/arduino_team1/assets/127822478/8c037b27-e548-4382-b761-32e90233b0a4)

스마트폰의 Song버튼을, 누르면 "song"를 보내서, 아래와같이 피에조 스피커에서 노래가 나옵니다.
https://github.com/naengku3/arduino_team1/assets/127822478/58f31f41-68bf-4e8b-a341-783821cb84d3


역으로 아두이노에서 스위치를 떼면, Serial 통신을 통해 '1'을 보내고, Server에서 wifi를 통해 Client로 1을 보내, 아래와같이 스마트폰 화면이 하늘색으로 바뀝니다. 
![Screenshot_20231010-203205](https://github.com/naengku3/arduino_team1/assets/127822478/866ca15b-5144-4c15-aafa-ac17b8386653)

스위치를 붙이면 Serial 통신을 통해 '0'을 보내고, Server에서 wifi를 통해 Client로 0을 보내, 아래와같이 스마트폰 화면이 분색으로 바뀝니다. 
![Screenshot_20231010-203239](https://github.com/naengku3/arduino_team1/assets/127822478/993863bd-f593-4774-bceb-8fb59d0af13c)

지금까지 읽어주셔서 감사합니다. 아래는 소감입니다.

--------- 소감 ----------

김도현 : 처음에는 HTTP프로토콜 자체도 어떻게 되는지 몰라서 헤메고 앱인벤터도 변수로 받은걸 문자로 비교하고 있는등.. 모르는것 투성이었지만,
        카페에 올려져있는 코드를 보고 조금씩 바꿔보고, 모르는건 찾아보고 해서, 완벽하다고 할 수 있을지는 모르겠지만, 적어도 코드가 왜 이렇게
        구성이 되었는지를 이해하고, 또 그걸통해 다른 팀원이 작성한 코드도 보면서 응용할 수 있도록 노력해보았습니다. 처음엔 매우 힘들었지만
        차차 알아가니 해결이 되는부분이 많았습니다. 노력한 보람이있습니다!

김유찬 : 이 프로젝트를 진행하면서 아두이노와 스마트폰을 연결하여 간단한 기능을 구현하는 것이 정말 재미있었습니다. 
        아두이노의 13번 LED를 제어하고 스마트폰 화면의 색을 변화시키는 것은 실제로 동작하는 것을 보면서 더욱 신기했습니다.  
        팀플로서 협업하면서 의사소통과 협력의 중요성을 깨달았습니다.


