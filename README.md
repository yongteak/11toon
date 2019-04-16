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
$ ./11toon.escript "http://11toon.com/bbs/board.php?bo_table=toons&stx=%EB%B0%94%EC%9D%B4%EC%98%A4%EB%A9%94%EA%B0%80&is=4228"
```
