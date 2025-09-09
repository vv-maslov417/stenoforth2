\ stenoforth32

0 WARNING !
REQUIRE STACK        ~stenoforth2\lib\cstack.f       \ �⥪� � �����
REQUIRE CASE         lib\ext\case.f                  \ ��������� CASE
REQUIRE {            lib\ext\locals.f                \ ������� ��६���� SPF
REQUIRE NUMBER?      ~mak\lib\fpcnum.f               \ �८�ࠧ������ ��ப � �᫠
REQUIRE LIKE         ~pinka\lib\like.f               \ �뤥����� �� ��᪥
REQUIRE M:           ~stenoforth2\lib\nf-name.f      \ ������, ᫮��-��ப�
REQUIRE $!           ~mak\place.f                    \ �⨫��� ��� �������室��� �������樨
REQUIRE 0SQRT        ~stenoforth2\assm\mp-assm.f     \ ���஥��� ����䨪�� ��ᥬ����( � ���⪠�� ����.�窨)
REQUIRE IDN          ~stenoforth2\assm\sp-assm.f     \ ���஥��� ����室�� ��ᥬ���� � ��⪠�� � ���⪨� ᨭ⠪�ᮬ ��� ������権
REQUIRE CHOOSE       lib\ext\rnd.f                   \ ��砩�� �롮�
REQUIRE randomize    ~stenoforth2\lib\nrand.f        \ ������஢���� ��砩�� �롮� ����襭���� ����த���⢨�
REQUIRE F.           lib\include\float2.f            \ ����⢥��� �᫠
REQUIRE instructions ~stenoforth2\lib\instructions.f \ ��� �ᯮ��㥬� ������樨 ������, ��ࠬ��ਧ㥬� � �⥪� ������
REQUIRE sd.          ~stenoforth2\lib\nloc25.f       \ ����᪨� ������� ��६����, ᫮��, ������, ��ப�
REQUIRE 1-!          ~stenoforth2\lib\man-ip.f       \ ���७�� �������� ᫮���� FORTH
REQUIRE pusto        ~stenoforth2\lib\staxy4.f       \ ��אַ� ������� �������権 ��ࠬ��ࠬ� �� �⥪� ��ࠬ��஢
REQUIRE sseet        ~stenoforth2\lib\seetl.f        \ �����⥫� �६��� �ᯮ������ ᫮�� �� ࠧ���� � 横���᪮� ��� �ᯮ������
REQUIRE fpoint       ~stenoforth2\lib\w-flo.f        \ ����� ��� ᫮� ����.�窨
REQUIRE recgen       ~stenoforth2\lib\recgen.f       \ ���७�� ��� �ନ஢���� ���ࠫ��� ᫮�
REQUIRE valuenames   ~stenoforth2\lib\c-fix.f        \ ����� ᨭ������ ��� ᦠ�� ᫮� ��� ࠡ��� � 䨪�.�窮� - ࠧ�來��� 32
REQUIRE mfvaluenames ~stenoforth2\lib\c-flo.f        \ ����� ᨭ������ ��� ᦠ�� ᫮� ��� ࠡ��� � ����.�窮�
REQUIRE dsynonyms    ~stenoforth2\lib\c-fixd.f       \ ����� ᨭ������ ��� ᦠ�� ᫮� ��� ࠡ��� � 䨪�.�窮� - ࠧ�來���� 64
REQUIRE SYNONYM      ~stenoforth2\lib\synonym.f      \ ��ॢ�� ���� �� ���孥�� ॣ���� � ������
REQUIRE 2VARIABLE    lib\include\double.f            \ ��६���� ������� ࠧ�來���
REQUIRE immediate    ~stenoforth2\lib\w-fix.f        \ ��ॢ�� ���� �� ���孥�� ॣ���� � ������ ��� ᫮� � 䨪�. �窮� - ࠧ�來��� 32
REQUIRE f.           ~stenoforth2\lib\r-flo.f        \ ��ॢ�� ���� �� ���孥�� ॣ���� � ������ ��� ᫮� � ����. �窮�
REQUIRE [type]       ~stenoforth2\math\matr.f        \ ����樨 ��� ����栬� � �᫠�� � 䨪�. �窮�
REQUIRE SEE          ~stenoforth2\lib\disasm.f       \ ��ࠡ�⠭�� SEE(���� ࠧ��� ���� � �᫮ ������権)
REQUIRE s-inv        ~stenoforth2\lib\string.f       \ ����樨 ��� ��ப���
REQUIRE }a           ~stenoforth2\lib\short-asm.f    \ ��� �ᯮ��㥬� ������樨 ������, ��ࠬ��ਧ㥬� � �⥪� ������ � �� �� ���

S" f:\spf429\devel\~stenoforth2\bin\spf486.exe" SAVE

BYE

\EOF

Порядок получения расширенной форт-системы spf-4.29(spf486.exe):

1. Пусть исходная форт-система расположена в папке f:\spf429(вместо f: д.б. быть указан ваш диск).
   После скачивания файлов из репозитория(github) нужно поменять формат строк во всех файлах на Dos/Windows(0Dh,0Ah).
   Если есть желание использовать кириллицу в именах слов и текстовых литералах(лексемах) в ваших программах,
   то можно поменять кодировку всех текстовых файлов на cp866 для корректного отображения кириллицы в консоли.

2. Скопировать скачанную из репозитория GIT папку ~stenoforth2, в каталог \spf429\devel\
   файл disasm.f из spf429\lib\ext\ заменить файлом disasm.f, из скачанного репозитория.

3. Исполнить файл compile.bat из папки \spf429\src

4. Увеличить размер образа форт-системы, исполнив из ком. строки команду:
   spf4.exe  IMAGE-SIZE 64 * TO IMAGE-SIZE S" spf4p.exe" SAVE BYE

5. Оттранслировать этот файл(Spf4290.f) c помощью spf4p.exe из папки \spf429


   
