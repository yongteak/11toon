11toon (for erlang)
======

http://11toon.com 사이트의 만화책을 로컬에 다운로드 (선택한 만화의 페이징에 들어있는 모든 컨텐츠 다운로드)

* 윈도우 지원하지 않음
* osx에서 테스트됨
* erlang 20.0 이상에서 테스트됨

## Usage

``` bash
$ ./rebar get-deps compile
$ ./11toon.escript [만화책 URL주소]
```

## Usage

* stx는 되도록이면 인코딩된 상태로 넣어주세요.
``` bash
$ ./11toon.escript "http://www.11toon4.com/bbs/board.php?bo_table=toons&wr_id=224472&stx=%EA%B3%A0%EC%BF%A0%EC%84%BC%28%EC%A1%B0%ED%8F%AD+%EC%84%A0%EC%83%9D%EB%8B%98%29&is=11057"
```
