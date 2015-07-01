-module(plumtree_default_peer_service).
-behavior(plumtree_peer_behaviour).

-export([get_peer_state/0,
	 register_changes/1,
	 get_members/1]).

%-spec get_peer_state() -> peer_state().
get_peer_state() ->
%% Dom some real error handling here.
    {ok, LocalState} = plumtree_peer_service_manager:get_local_state(),
    LocalState.

%-spec register_changes(update_callback())-> ok.
register_changes(Callback)->
%% Do some real error handlding here.
    plumtree_peer_service_events:add_sup_callback(Callback),
    ok.

get_members(State) ->
    riak_dt_orswot:value(State).
