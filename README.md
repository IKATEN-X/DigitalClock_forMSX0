# DigitalClock_forMSX0
-- MSX0を身近にするためのデジタル時計 --  
MSX0の機能としてある、HTTP通信とSCREEN5のグラフィック、それと温度・湿度の取得を使って時計に仕立てました。  
<img src="https://github.com/IKATEN-X/DigitalClock_forMSX0/blob/main/image.jpg?raw=true" width="300">  
  
本プログラムを、完全な状態で利用するためには、以下の環境を整える必要があります。    
* Wifi接続  
MSX0は起動時にNTPにて時間を取得しています。Wifi接続していないと、０時からスタートしてしまい、時計として使えなくなります。  
また、https://weather.tsukumijima.net/ で提供されている天気予報のJSONを取得しています。  
MSX0はHTTPS通信が行えず、HTTP通信のみしかできません。なので、HTTPで情報を取得できるこちらからデータを頂いています。  
  
* msxjson  
https://github.com/ricbit/msxjson こちらで公開されているmsxjsonを使用して、JSONデータをパースしています。  
DigitalClock_forMSX0のディスクイメージには、同梱していないので、msxjsonからjson.binを入手して、ディスクイメージ内に入れてください。  
ディスクイメージへのアクセスは、GIGAMIXさんのnf_banさんが<a href="https://gigamix.hatenablog.com/entry/devmsx/floppydiskimage-tools">まとめ</a>られていますので、そこから使いやすいものをインストールして使用してください。  

* 温湿度センサー（DHT11もしくは、DHT20）
冒頭の写真はDHT11をBOTTOM2にある、PortCに挿しています。  
また、PortAにGrove Beginner Kit for MSX0にある、DHT20を接続しても使用できます。
<img src="https://github.com/IKATEN-X/DigitalClock_forMSX0/blob/main/image2.jpg?raw=true" width="300">  

■天気予報について  
取得したい場所の指定が必要です。メインのBASICプログラムの100行目に場所のコードを格納する変数LC$に設定をしています。   
"280010"は神戸のコードとなっております。その他の場所のコードは https://weather.tsukumijima.net/primary_area.xml で参照することができます。  

■最後に...  
一応半日程度のテストをして、止まらず動いているものを公開していますが、稀に止まってしまうことが、まだあるようです。  
バグなのか、MSX0の問題なのかは、現時点把握しきれていません。ご了承ください。  
また、受信したJSONはメモリ番地B000HからCFFFHに格納します。原理上8KBまで受信できます。  
テスト（神戸）では5KBほどのデータを受信していましたが、場所によりサイスが大きくなり、処理できない可能性があります。  
https://weather.tsukumijima.net/ では、受信するデータを選別することができないため、その場合はBASICプログラムの改良が必要になってきます。  
受信先をOpenWeatherMAPなどをにし、パース処理と値の取得を変更する必要があります。  
