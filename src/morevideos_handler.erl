-module(morevideos_handler).
-author("chanakyam@koderoom.com").
-include("includes.hrl").
-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=1&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	Latest_videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=12&format=short&skip=0",
	{ok, "200", _, Response_Latest_videos} = ibrowse:send_req(Latest_videos_Url,[],get,[],[]),
	ResponseParams_Latest_videos = jsx:decode(list_to_binary(Response_Latest_videos)),	
	LatestNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Latest_videos),	

	Latest_Videos_Url1 = "http://api.contentapi.ws/videos?channel=world_news&limit=2&format=short&skip=0",
	{ok, "200", _, Response_Latest_Videos1} = ibrowse:send_req(Latest_Videos_Url1,[],get,[],[]),
	ResponseParams_Latest_Videos1 = jsx:decode(list_to_binary(Response_Latest_Videos1)),
	LatestVideosParams1 = proplists:get_value(<<"articles">>, ResponseParams_Latest_Videos1),
	

	Latest_Popular_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=4&format=short&skip=2",

	{ok, "200", _, Response_Latest_Popular_Videos} = ibrowse:send_req(Latest_Popular_Videos_Url,[],get,[],[]),
	ResponseParams_Latest_Popular_Videos = jsx:decode(list_to_binary(Response_Latest_Popular_Videos)),
	LatestPopularVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Latest_Popular_Videos),

	% Gallery_Url = "http://api.contentapi.ws/news?channel=image_galleries&skip=0&format=short&limit=2",
	Gallery_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_music/_view/short?descending=true&limit=2&skip=0",

	{ok, "200", _, Response_Gallery} = ibrowse:send_req(Gallery_Url,[],get,[],[]),
	ResponseParams_Gallery = jsx:decode(list_to_binary(Response_Gallery)),	
	GalleryParams = proplists:get_value(<<"rows">>, ResponseParams_Gallery),

	% Latest_Beauty_News_Url1 = "http://api.contentapi.ws/news?channel=fashion&skip=0&limit=2&format=long",
	Latest_Beauty_News_Url1 = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_entertainment_film/_view/full_composite_article?descending=true&limit=2&skip=0",

	{ok, "200", _, Response_Latest_Beauty_News1} = ibrowse:send_req(Latest_Beauty_News_Url1,[],get,[],[]),
	ResponseParams_Latest_Beauty_News1 = jsx:decode(list_to_binary(Response_Latest_Beauty_News1)),
	LatestBeautyNews1 = proplists:get_value(<<"rows">>, ResponseParams_Latest_Beauty_News1),


	{ok, Body} = morevideos_dtl:render([{<<"videoParam">>,Params},{<<"latestnews">>,LatestNewsParams},{<<"latestVideos">>,LatestVideosParams1},{<<"latestPopularVideos">>,LatestPopularVideosParams},{<<"gallery">>,GalleryParams},{<<"latestbeautynews1">>,LatestBeautyNews1}]),
    {Body, Req, State}.




