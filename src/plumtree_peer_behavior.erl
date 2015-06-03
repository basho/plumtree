-module(plumtree_peer_behavior).


-type peer_state() :: any().
-type members() :: ordsets:ordset(node()).
-type update_callback() :: fun((peer_state()) -> ok).

-callback get_peer_state() -> peer_state().
-callback register_changes(update_callback())-> ok.
-callback get_members(peer_state()) -> members().
