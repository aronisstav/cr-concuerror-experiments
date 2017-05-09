
-module(layout_server).

%% API
-export([start_link/3, read/1, write/3, stop/1]).

start_link(Name, InitialEpoch, InitialLayout) when InitialEpoch >= 0 ->
  Name = ets:new(Name, [named_table, public]),
  true = ets:insert(Name, [{epoch,InitialEpoch}, {layout,InitialLayout}]),
  {ok, self()}.

read(Name) ->
  [{epoch, Epoch}] = ets:lookup(Name, epoch),
  [{layout, Layout}] = ets:lookup(Name, layout),
  {ok, Epoch, Layout}.

write(Name, NewEpoch, NewLayout) ->
  [{epoch, Epoch}] = ets:lookup(Name, epoch),
  if is_integer(NewEpoch), NewEpoch > Epoch ->
      ets:insert(Name, [{epoch,NewEpoch}, {layout,NewLayout}]),
      ok;
     true ->
      bad_epoch
  end.

stop(Name) ->
  ets:delete(Name).
