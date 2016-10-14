defmodule Orientex.Request do
  @moduledoc false

  alias Orientex.Types

  # todo - specs, docs
  def encode(:request_command, session_id, query, params, opts) do
    encode_request_header(:request_command, session_id) <> __MODULE__.Command.encode(query, params, opts)
  end

  # todo - specs, docs
  # server operations
  def get_operation_value(:request_shutdown), do: 1
  def get_operation_value(:request_connect), do: 2
  def get_operation_value(:request_db_open), do: 3
  def get_operation_value(:request_db_create), do: 4
  def get_operation_value(:request_db_exist), do: 6
  def get_operation_value(:request_db_drop), do: 7
  def get_operation_value(:request_config_get), do: 70
  def get_operation_value(:request_config_set), do: 71
  def get_operation_value(:request_config_list), do: 72
  def get_operation_value(:request_db_list), do: 74

  # database operations
  def get_operation_value(:request_db_close), do: 5
  def get_operation_value(:request_db_size), do: 8
  def get_operation_value(:request_db_countrecords), do: 9
  def get_operation_value(:request_datacluster_copy), do: 14
  def get_operation_value(:request_datacluster_lh_cluster_is_used), do: 16
  def get_operation_value(:request_record_metadata), do: 29
  def get_operation_value(:request_record_load), do: 30
  def get_operation_value(:request_record_load_if_version_not_latest), do: 44
  def get_operation_value(:request_record_create), do: 31
  def get_operation_value(:request_record_update), do: 32
  def get_operation_value(:request_record_delete), do: 33
  def get_operation_value(:request_record_copy), do: 34
  def get_operation_value(:request_record_clean_out), do: 38
  def get_operation_value(:request_positions_floor), do: 39
  def get_operation_value(:request_command), do: 41
  def get_operation_value(:request_positions_ceiling), do: 42
  def get_operation_value(:request_tx_commit), do: 60
  def get_operation_value(:request_db_reload), do: 73
  def get_operation_value(:request_push_record), do: 79
  def get_operation_value(:request_push_distrib_config), do: 80
  def get_operation_value(:request_push_live_query), do: 81
  def get_operation_value(:request_db_copy), do: 90
  def get_operation_value(:request_replication), do: 91
  def get_operation_value(:request_cluster), do: 92
  def get_operation_value(:request_db_transfer), do: 93
  def get_operation_value(:request_db_freeze), do: 94
  def get_operation_value(:request_db_release), do: 95
  def get_operation_value(:request_create_sbtree_bonsai), do: 110
  def get_operation_value(:request_sbtree_bonsai_get), do: 111
  def get_operation_value(:request_sbtree_bonsai_first_key), do: 112
  def get_operation_value(:request_sbtree_bonsai_get_entries_major), do: 113
  def get_operation_value(:request_ridbag_get_size), do: 114
  def get_operation_value(:request_index_get), do: 120
  def get_operation_value(:request_index_put), do: 121
  def get_operation_value(:request_index_remove), do: 122
#  def get_operation_value(:request_incremental_restore), do: ???

  defp encode_request_header(request, session_id) do
    Types.encode([{:byte, get_operation_value(request)}, {:int, session_id}])
  end
end
