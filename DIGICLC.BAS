10 'save"AUTOEXEC.BAS"
20 _IOTINIT()
30 WIDTH 32:KEY OFF:COLOR 1,2,2:SCREEN 5:_KANJI
40 CLEAR 2048,&HB000:DEFINT A-Z
50 BLOAD "JSON.BIN",R
60 BLOAD "LDIRSTR.BIN":DEFUSR3=&HD800
70 DIM KY$(100)
80 DQ$=CHR$(&H22):NL$=CHR$(13)+CHR$(10):HE$=NL$+NL$
90 'user setting
100 LC$="280010"
110 '
120 PA$="msx/me/if/NET0/"  'path
130 UR$="weather.tsukumijima.net"
140 'create message
150 UR$="weather.tsukumijima.net"
160 SM$(0)="GET /api/forecast/city/"+LC$+" HTTP/1.0"+NL$
170 SM$(1)="Host: "+UR$+NL$
180 SM$(2)=""+NL$
190 SM$(3)=CN$
200 SM$(4)=""
210 '
220 ON INTERVAL=36000! GOSUB 440
230 SET PAGE 0,1
240 BLOAD "FONT.SC5",S
250 COLOR=RESTORE
260 SETPAGE 0,0
270 COPY (8,136)-(98,164),1 TO (10,90),0
280 COPY (60,90)-(90,120),1 TO (210,90),0
290 COPY (8,166)-(98,194),1 TO (10,150),0
300 COPY (30,90)-(60,120),1 TO (210,150),0
310 INTERVAL ON:DO$=""
320 GET TIME DT$:IF DO$<>DT$ THEN DO$=DT$:DX=0:DY=20:GOSUB 370 ELSE 320
330 _IOTGET("device/dht/temperature",A):DT$=RIGHT$("   "+STR$(A),3):DX=110:DY=80:GOSUB 370
340 _IOTGET("device/dht/humidity",A):DT$=RIGHT$("   "+STR$(A),3):DX=110:DY=140:GOSUB 370
350 IF ID$="" THEN GOSUB 440
360 GOTO 320
370 FOR DI=1 TO LEN(DT$):A$=MID$(DT$,DI,1)
380 IF A$=":" THEN PX=0:PY=83:GOTO 420
390 IF A$=" " THEN PX=150:PY=0:GOTO 420
400 IF A$="-" THEN PX=150:PY=40:GOTO 420
410 A=VAL(A$):PX=(AMOD5)*30:PY=-(A>4)*40
420 COPY (PX,PY+1)-(PX+29,PY+42),1 TO (DX+DI*30-30,DY),0
430 NEXT:RETURN
440 '--------
450 'connet
460   _IOTPUT(PA$+ "conf/addr",UR$)
470   _IOTPUT(PA$+ "conf/port",80)
480   _IOTPUT(PA$+ "connect",1)
490 'check connect status
500   FOR I=0 TO 1000:NEXT
510   _IOTGET(PA$+ "connect",S)
520   IF S<>1 THEN 710
530 'send message
540   I=0
550   IF SM$(I)<>"" THEN _IOTPUT(PA$+ "msg",SM$(I)):I=I+1:GOTO 550
560   FOR I=0 TO 1000:NEXT
570 'receive message
580 P=0:NM$="":AL=0
590 AD=USR3(&HB000):MD=0:RM$=""
600 MO$=RM$:_IOTGET(PA$+ "msg",RM$):L=LEN(RM$):AL=AL+L:IF L=0 THEN 650
610 IF MD=1 THEN 630
620 R$=MO$+RM$:HP=INSTR(R$,HE$):IF HP<>0 THEN RM$=RIGHT$(R$,LEN(R$)-HP-3):MD=1 ELSE 600
630 A$=USR3(RM$)
640  GOTO 600
650 IF AL>0 THEN A=USR(&HB000) ELSE 710
660 'IF USR1("&location&city")<>0 THEN CT$=USR2("&location&city")
670 IF USR1("&forecasts#0&image&url")<>0 THEN ID$=RIGHT$(USR2("&forecasts#0&image&url"),7):GOSUB 770
680 'IF USR1("&forecasts#1&image&url")<>0 THEN ID$=RIGHT$(USR2("&forecasts#1&image&url"),7):PRINTID$
690 'IF USR1("&forecasts#2&image&url")<>0 THEN ID$=RIGHT$(USR2("&forecasts#2&image&url"),7):PRINTID$
700 'disconnet
710 _IOTPUT(PA$+ "connect",0)
720 RETURN
730 'system reboot
740 _IOTPUT("host/power/wait", WT)
750 _IOTPUT("host/power/reboot",1)
760 RETURN
770 '----
780 RESTORE 810:II$=LEFT$(ID$,3)
790 READ A$,W$
800 IF A$=II$ OR A$="000" THEN COLOR 1,15,2:LINE(0,190)-(255,210),15,BF:_KLEN(L,W$):LOCATE 16-L,12:PRINT W$;:BEEP:RETURN ELSE 790
810 '-----
820 DATA 100,晴れ
830 DATA 101,晴れ時々くもり
840 DATA 102,晴れ一時雨
850 DATA 103,晴れ時々雨
860 DATA 104,晴れ一時雪
870 DATA 105,晴れ時々雪
880 DATA 106,晴れ一時雨か雪
890 DATA 107,晴れ時々雨か雪
900 DATA 108,晴れ一時雨か雷雨
910 DATA 110,晴れのち時々くもり
920 DATA 111,晴れのちくもり
930 DATA 112,晴れのち一時雨
940 DATA 113,晴れのち時々雨
950 DATA 114,晴れのち雨
960 DATA 115,晴れのち一時雪
970 DATA 116,晴れのち時々雪
980 DATA 117,晴れのち雪
990 DATA 122,晴れ夕方一時雨
1000 DATA 123,晴れ山沿い雷雨
1010 DATA 124,晴れ山沿い雪
1020 DATA 125,晴れ午後は雷雨
1030 DATA 126,晴れ昼頃から雨
1040 DATA 127,晴れ夕方から雨
1050 DATA 128,晴れ夜は雨
1060 DATA 129,晴れ夜半から雨
1070 DATA 130,朝の内霧後晴れ
1080 DATA 132,晴れ朝夕くもり
1090 DATA 140,晴れ時々雨で雷を伴う
1100 DATA 160,晴れ一時雪か雨
1110 DATA 170,晴れ時々雪か雨
1120 DATA 181,晴れのち雪か雨
1130 DATA 200,くもり
1140 DATA 201,くもり時々晴
1150 DATA 202,くもり一時雨
1160 DATA 203,くもり時々雨
1170 DATA 204,くもり一時雪
1180 DATA 205,くもり時々雪
1190 DATA 206,くもり一時雨か雪
1200 DATA 207,くもり時々雨か雪
1210 DATA 208,くもり一時雨か雷雨
1220 DATA 209,霧
1230 DATA 210,くもりのち時々晴れ
1240 DATA 211,くもりのち晴れ
1250 DATA 212,くもりのち一時雨
1260 DATA 213,くもりのち時々雨
1270 DATA 214,くもりのち雨
1280 DATA 215,くもりのち一時雪
1290 DATA 216,くもりのち時々雪
1300 DATA 217,くもりのち雪
1310 DATA 218,くもりのち雨か雪
1320 DATA 219,くもりのち雨か雷雨
1330 DATA 220,くもり朝夕一時雨
1340 DATA 221,くもり朝の内一時雨
1350 DATA 222,くもり夕方一時雨
1360 DATA 223,くもり日中時々晴れ
1370 DATA 224,くもり昼頃から雨
1380 DATA 225,くもり夕方から雨
1390 DATA 226,くもり夜は雨
1400 DATA 227,くもり夜半から雨
1410 DATA 228,くもり昼頃から雪
1420 DATA 229,くもり夕方から雪
1430 DATA 230,くもり夜は雪
1440 DATA 231,くもり海上海岸は霧か霧雨
1450 DATA 260,くもり一時雪か雨
1460 DATA 270,くもり時々雪か雨
1470 DATA 281,くもりのち雪か雨
1480 DATA 300,雨
1490 DATA 301,雨時々晴れ
1500 DATA 302,雨時々止む
1510 DATA 303,雨時々雪
1520 DATA 304,雨か雪
1530 DATA 306,大雨
1540 DATA 307,風雨共に強い
1550 DATA 308,雨で暴風を伴う
1560 DATA 309,雨一時雪
1570 DATA 311,雨のち晴れ
1580 DATA 313,雨のちくもり
1590 DATA 314,雨のち時々雪
1600 DATA 315,雨のち雪
1610 DATA 316,雨か雪のち晴れ
1620 DATA 317,雨か雪のちくもり
1630 DATA 320,朝の内雨のち晴れ
1640 DATA 321,朝の内雨のちくもり
1650 DATA 322,雨朝晩一時雪
1660 DATA 323,雨昼頃から晴れ
1670 DATA 324,雨夕方から晴れ
1680 DATA 325,雨夜は晴
1690 DATA 326,雨夕方から雪
1700 DATA 327,雨夜は雪
1710 DATA 328,雨一時強く降る
1720 DATA 329,雨一時みぞれ
1730 DATA 340,雪か雨
1740 DATA 350,雨で雷を伴う
1750 DATA 361,雪か雨のち晴れ
1760 DATA 371,雪か雨のちくもり
1770 DATA 400,雪
1780 DATA 401,雪時々晴れ
1790 DATA 402,雪時々止む
1800 DATA 403,雪時々雨
1810 DATA 405,大雪
1820 DATA 406,風雪強い
1830 DATA 407,暴風雪
1840 DATA 409,雪一時雨
1850 DATA 411,雪のち晴れ
1860 DATA 413,雪のちくもり
1870 DATA 414,雪のち雨
1880 DATA 420,朝の内雪のち晴れ
1890 DATA 421,朝の内雪のちくもり
1900 DATA 422,雪昼頃から雨
1910 DATA 423,雪夕方から雨
1920 DATA 424,雪夜半から雨
1930 DATA 425,雪一時強く降る
1940 DATA 426,雪のちみぞれ
1950 DATA 427,雪一時みぞれ
1960 DATA 450,雪で雷を伴う
1970 DATA 000,--------
