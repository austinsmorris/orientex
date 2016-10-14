defmodule Orientex.Schema do
  @moduledoc false

  defstruct progress: [], result: [], schema: []

  # todo - docs, specs, tests
  # server operations
#  def get_schema_for_request(:request_shutdown), do: %__MODULE__{schema: Schema.Shutdown.get_schema}
  def get_schema_for_request(:request_connect), do: %__MODULE__{schema: __MODULE__.Connect.get_schema}
  def get_schema_for_request(:request_db_open), do: %__MODULE__{schema: __MODULE__.DbOpen.get_schema}
#  def get_schema_for_request(:request_db_create), do: %__MODULE__{schema: Schema.DbCreate.get_schema}
#  def get_schema_for_request(:request_db_exist), do: %__MODULE__{schema: Schema.DbExists.get_schema}
#  def get_schema_for_request(:request_db_drop), do: %__MODULE__{schema: Schema.DbDrop.get_schema}
#  def get_schema_for_request(:request_config_get), do: %__MODULE__{schema: Schema.ConfigGet.get_schema}
#  def get_schema_for_request(:request_config_set), do: %__MODULE__{schema: Schema.ConfigSet.get_schema}
#  def get_schema_for_request(:request_config_list), do: %__MODULE__{schema: Schema.ConfigList.get_schema}
#  def get_schema_for_request(:request_db_list), do: %__MODULE__{schema: Schema.DbList.get_schema}

  # database operations
#  def get_schema_for_request(:request_db_close), do:
#  def get_schema_for_request(:request_db_size), do:
#  def get_schema_for_request(:request_db_countrecords), do:
#  def get_schema_for_request(:request_datacluster_copy), do:
#  def get_schema_for_request(:request_datacluster_lh_cluster_is_used), do:
#  def get_schema_for_request(:request_record_metadata), do:
#  def get_schema_for_request(:request_record_load), do:
#  def get_schema_for_request(:request_record_load_if_version_not_latest), do:
#  def get_schema_for_request(:request_record_create), do:
#  def get_schema_for_request(:request_record_update), do:
#  def get_schema_for_request(:request_record_delete), do:
#  def get_schema_for_request(:request_record_copy), do:
#  def get_schema_for_request(:request_record_clean_out), do:
#  def get_schema_for_request(:request_positions_floor), do:
  def get_schema_for_request(:request_command), do: %__MODULE__{schema: __MODULE__.Command.get_schema}
#  def get_schema_for_request(:request_positions_ceiling), do:
#  def get_schema_for_request(:request_tx_commit), do:
#  def get_schema_for_request(:request_db_reload), do:
#  def get_schema_for_request(:request_push_record), do:
#  def get_schema_for_request(:request_push_distrib_config), do:
#  def get_schema_for_request(:request_push_live_query), do:
#  def get_schema_for_request(:request_db_copy), do:
#  def get_schema_for_request(:request_replication), do:
#  def get_schema_for_request(:request_cluster), do:
#  def get_schema_for_request(:request_db_transfer), do:
#  def get_schema_for_request(:request_db_freeze), do:
#  def get_schema_for_request(:request_db_release), do:
#  def get_schema_for_request(:request_create_sbtree_bonsai), do:
#  def get_schema_for_request(:request_sbtree_bonsai_get), do:
#  def get_schema_for_request(:request_sbtree_bonsai_first_key), do:
#  def get_schema_for_request(:request_sbtree_bonsai_get_entries_major), do:
#  def get_schema_for_request(:request_ridbag_get_size), do:
#  def get_schema_for_request(:request_index_get), do:
#  def get_schema_for_request(:request_index_put), do:
#  def get_schema_for_request(:request_index_remove), do:
#  def get_schema_for_request(:request_incremental_restore), do: ???
end
