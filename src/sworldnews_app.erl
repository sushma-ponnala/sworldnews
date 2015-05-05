-module(sworldnews_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_',[
                {"/", home_page_handler, []},
                {"/api/latestnews/channel", channel_latestnews_handler, []},
                {"/api/latestvideos/channel", channel_latestvideos_handler, []},
                {"/news/:id", fashiontips_handler, []},
                {"/beauty/:id", beauty_handler, []},
                {"/morepeople", morefashiontips_handler, []},
                {"/morenews", morebeauty_handler, []},
                {"/moremusic", photo_gallery_handler, []},
                {"/morevideos", morevideos_handler, []},
                {"/api/news/count", news_count_handler, []},
                {"/api/beauty/count", beauty_count_handler, []},
                {"/api/videos/count", videos_count_handler, []},
                {"/playvideo/:id", play_video_handler, []},
                {"/api/gallery/channel", channel_gallery_handler, []},
                {"/termsandconditions", tnc_page_handler, []},
                {"/api/latestbeautynews/channel", channel_latestbeautynews_handler, []},               
                %%
                %% Release Routes
                %%
                {"/css/[...]", cowboy_static, {priv_dir, sworldnews, "static/css"}},
                {"/images/[...]", cowboy_static, {priv_dir, sworldnews, "static/images"}},
                {"/js/[...]", cowboy_static, {priv_dir, sworldnews, "static/js"}},
				{"/fonts/[...]", cowboy_static, {priv_dir, sworldnews, "static/fonts"}}
				%%
				%% Dev Routes
				%%
				% {"/css/[...]", cowboy_static, {dir, "priv/static/css"}},
    %             {"/images/[...]", cowboy_static, {dir, "priv/static/images"}},
    %             {"/js/[...]", cowboy_static, {dir,"priv/static/js"}},
				% {"/fonts/[...]", cowboy_static, {dir, "priv/static/fonts"}}
        ]}		
	]),    

	{ok, _} = cowboy:start_http(http,100, [{port, 11002}],[{env, [{dispatch, Dispatch}]}
              ]),
    sworldnews_sup:start_link().

stop(_State) ->
    ok.
