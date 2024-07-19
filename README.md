# DigitalClock_forMSX0
-- MSX0を身近にするためのデジタル時計 --  
MSX0の機能としてある、HTTP通信とSCREEN5のグラフィック、それと温度・湿度の取得を使って時計に仕立てました。  
<img src="https://github.com/IKATEN-X/DigitalClock_forMSX0/blob/main/image.jpg?raw=true" width="300">  
  
本プログラムを、完全な状態で利用するためには、以下の環境を整える必要があります。    
* Wifi・インターネット接続  
MSX0は、起動時にインターネット上のNTPサーバーへ時間を取りに行っています。Wifi接続していないと、0時からスタートしてしまい、時計として使えなくなります。  
また、https://weather.tsukumijima.net/ で提供されている天気情報のJSONを取得しています。  
MSX0はHTTPS通信が行えず、HTTP通信のみしかできません。なので、HTTPで情報を取得できるこちらからデータを頂いています。  
  
* msxjson  
https://github.com/ricbit/msxjson こちらで公開されているmsxjsonを使用して、JSONデータをパースしています。  
DigitalClock_forMSX0のディスクイメージには、同梱していないので、msxjsonからjson.binを入手して、ディスクイメージ内に入れてください。  
ディスクイメージへのアクセスは、GIGAMIXさんのnf_banさんが<a href="https://gigamix.hatenablog.com/entry/devmsx/floppydiskimage-tools">まとめ</a>られていますので、そこから使いやすいものをインストールして使用してください。  

* 温湿度センサー（DHT11もしくは、DHT20）
冒頭の写真はDHT11をBOTTOM2にあるPortCに挿しています。  
また、PortAにGrove Beginner Kit for MSX0にある、DHT20を接続しても使用できます。
DHT20を使い場合は、MSX0への電源投入前に挿しておく必要があります。  
<img src="https://github.com/IKATEN-X/DigitalClock_forMSX0/blob/main/image2.jpg?raw=true" width="300">  
※このように接続する場合は、Arduino Unoに空スケッチなどを流し込んで、不活性化しておく必要があります。  
<br>
  
■天気予報について  
取得したい場所の設定が必要です。メインのBASICプログラムの100行目で変数LC$に設定をしています。   
"280010"は神戸のコードとなっております。その他の場所のコードは https://weather.tsukumijima.net/primary_area.xml で確認することができますのでお住いの場所に近い所を設定してください。  

■ディスクイメージ DIGI_CLC.dsk の中身  
* AUTOEXEC.BAS  
  メインのBASICプログラムです。
* FONT.SC5  
  デジタル時計のグラフィック素材です。起動して、SCREEN5のPAGE1に書き込まれ、そこから文字をPAGE0に持ってきています。
* LDIRSRT.BIN  
  文字列を指定のアドレスに書き込むマシン語プログラムです。
　メインのBASICではDEFUSR3=&HD800で呼び出すようにしています。
  A=USR3(アドレス) で、書き込む先頭アドレスを指定して、A$=USR3(文字列) で指定したアドレスに文字列を格納します。その時、格納アドレスは自動的に進むので、連続してA$=USR3(文字列)をすることで、長い文字列をユーザーエリアに書き込むことができます。
* JOSN.BIN  
 JSONパーサーです。（入っていません）

■最後に...  
一応半日程度のテストをして、止まらず動いているものを公開していますが、まだ、稀に止まってしまうことがあるようです。  
バグなのか、MSX0の問題なのかは、現時点把握しきれていません。ご了承ください。  
また、受信したJSONはメモリ番地B000HからCFFFHに格納します。原理上8KBまで受信できます。  
テスト（神戸）では5KBほどのデータを受信していましたが、場所によりサイスが大きくなり、処理できない可能性があります。  
https://weather.tsukumijima.net/ では、受信するデータを選別することができないため、JSONが大きすぎで処理できない場合はBASICプログラムの改良が必要になってきます。  
受信先をOpenWeatherMAPなどをにし、パース処理と値の取得を変更する必要があります。  
  
その他、ご質問などは https://x.com/ikaten_retro へご連絡ください。
