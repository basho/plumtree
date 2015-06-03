%% -------------------------------------------------------------------
%%
%% Copyright (c) 2015 Helium Systems, Inc.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(plumtree_sup).

-behaviour(supervisor).

-export([start_link/0, start_link/1]).

-export([init/1]).

-define(CHILD(I, Type, Timeout), {I, {I, start_link, []}, permanent, Timeout, Type, [I]}).
-define(CHILD(I, Type), ?CHILD(I, Type, 5000)).

start_link() ->
    start_link(plumtree_default_peer_service).

start_link(PeerService)->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [PeerService]).

init([PeerService]) ->
    _State = plumtree_peer_service_manager:init(),
    Broadcast = {plumtree_broadcast,
		 {plumtree_broadcast, start_link,[PeerService]}, 
		 permanent, 5000, worker, [plumtree_broadcast]}, 
    Children = lists:flatten(
                 [
                 ?CHILD(plumtree_peer_service_gossip, worker),
                 ?CHILD(plumtree_peer_service_events, worker),
                 Broadcast,
                 ?CHILD(plumtree_metadata_manager, worker),
                 ?CHILD(plumtree_metadata_hashtree, worker)
                 ]),
    RestartStrategy = {one_for_one, 10, 10},
    {ok, {RestartStrategy, Children}}.
