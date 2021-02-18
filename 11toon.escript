#!/usr/bin/env escript
%% ./11toon.escript "http://www.11toon4.com/bbs/board.php?bo_table=toons&wr_id=224472&stx=%EA%B3%A0%EC%BF%A0%EC%84%BC%28%EC%A1%B0%ED%8F%AD+%EC%84%A0%EC%83%9D%EB%8B%98%29&is=11057"
main([URL])->
    code:add_path("deps/qrly/ebin"),
    code:add_path("deps/mochiweb/ebin"),
    inets:start(),
    ssl:start(),
    io:format("~ts~n",[URL]),
    try 
        {MainTitle,SeriseURLs} = serise(URL),
        io:format("working serise urls => ~p~n",[length(SeriseURLs)]),
        _ = create_directory(MainTitle),
        _ = view({MainTitle,SeriseURLs})
    catch Class:Reason ->
        io:format("Class ~p, Reason ~p~n",[Class,Reason])
    end.
view({_,[]}) -> end_of_all_task;
view({MainTitle,[ViewURL|T]}) ->
    Qrly1 = qrly_html:parse_string(req(erlang:binary_to_list(ViewURL))),
    [{<<"span">>,_,[Title]}|_] = qrly_html:filter(Qrly1, ".viewer-header__title"),

    FileName = lists:concat(["/tmp/",rand_str(),".html"]),
    {ok,_} = qrly_html:to_file(Qrly1,FileName),
    {_Status, Content} = file:read_file(FileName),
    SubDir = <<MainTitle/binary, $/, Title/binary>>,
    _ = create_directory(SubDir),
    _ = file:delete(FileName),
    
    L = re:split(Content,"(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"),
    ImgURLs = re:split(lists:nth(2,L),"\",\""),
    _ = save(SubDir,ImgURLs),
    view({MainTitle,T}).

serise(URL) ->
    serise1(URL,1,[]).

serise1(URL,PageNum,Acc) ->
    {NextPageNum,URL1} = next(URL,PageNum),
    Qrly = qrly_html:parse_string(req(URL1)),
    [{_,_,[MainTitle]}|_] = qrly_html:filter(Qrly, ".title"),
    case qrly_html:filter(Qrly, "button .episode .is-series") of
        [] -> 
            {MainTitle,Acc};
        Qrly1 ->
            serise1(URL,NextPageNum,
                Acc ++ extract(Qrly1,[])
            )
    end.

extract([],Acc) -> Acc;
extract([{<<"button">>,Prop,_}|T],Acc) ->
    Base = <<"http://11toon.com/bbs">>,
    Location = proplists:get_value(<<"onclick">>,Prop),
    SubSize = erlang:size(Location) - 17,
    <<_:16/binary,Bin1:(SubSize)/binary,_/binary>> = Location,
    extract(T,Acc ++ [<< Base/binary, Bin1/binary >>]).
    
next(URL,PageNum) ->
    {PageNum + 1,lists:concat([URL,"&page=",PageNum])}.

create_directory(Name) ->
    case file:make_dir(Name) of
        {error,eexist} -> todo;
        _ -> todo
    end.

rand_str() ->
    re:replace(base64:encode(
        crypto:strong_rand_bytes(6)),"\\W","",[global,{return,list}]).

req(URL) ->
    io:format("URL > ~p~n",[erlang:list_to_binary(URL)]),
    {ok, {_,_,BodyStr}} = httpc:request(get, {URL,[{"User-Agent", "Chrome"},{"Cookie", ""}]}, [], []),
    BodyStr.

% compress(Filename) ->
% 	ZipFilename = Filename ++ ".zip",
% 	zip:zip( ZipFilename, [ Filename ] ),
% 	ZipFilename.

save(_,[]) -> end_of_save_task;
save(Path,[H|T]) ->
    URI = erlang:binary_to_list(H),
    SavePath = unicode:characters_to_list(Path) ++ "/" ++ filename:basename(URI),
    io:format("Remain ~p,Saved File .. ~p~n",[length(T),filename:basename(URI)]),
    {ok, _} = httpc:request(get, {URI, []}, [], [{stream, SavePath}]),
    save(Path,T).
