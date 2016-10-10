defmodule Orientex.RequestTest do
  use ExUnit.Case

  alias Orientex.Request

  test "encode :request_command encodes request" do
    encoded_request = Request.encode(:request_command, 4, "foo", [], [])
    assert encoded_request == <<41, 0, 0, 0, 4, 115, 0, 0, 0, 24, 0, 0, 0, 1, 99, 0, 0, 0, 3, 102, 111, 111,
      255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0>>
  end

  # server operations
  test "get_operation_value for :request_shutdown" do
    value = Request.get_operation_value(:request_shutdown)
    assert value == 1
  end

  test "get_operation_value for :request_connect" do
    value = Request.get_operation_value(:request_connect)
    assert value == 2
  end

  test "get_operation_value for :request_db_open" do
    value = Request.get_operation_value(:request_db_open)
    assert value == 3
  end

  test "get_operation_value for :request_db_create" do
    value = Request.get_operation_value(:request_db_create)
    assert value == 4
  end

  test "get_operation_value for :request_db_exist" do
    value = Request.get_operation_value(:request_db_exist)
    assert value == 6
  end

  test "get_operation_value for :request_db_drop" do
    value = Request.get_operation_value(:request_db_drop)
    assert value == 7
  end

  test "get_operation_value for :request_config_get" do
    value = Request.get_operation_value(:request_config_get)
    assert value == 70
  end

  test "get_operation_value for :request_config_set" do
    value = Request.get_operation_value(:request_config_set)
    assert value == 71
  end

  test "get_operation_value for :request_config_list" do
    value = Request.get_operation_value(:request_config_list)
    assert value == 72
  end

  test "get_operation_value for :request_db_list" do
    value = Request.get_operation_value(:request_db_list)
    assert value == 74
  end

  # database operations
  test "get_operation_value for :request_db_close" do
    value = Request.get_operation_value(:request_db_close)
    assert value == 5
  end

  test "get_operation_value for :request_db_size" do
    value = Request.get_operation_value(:request_db_size)
    assert value == 8
  end

  test "get_operation_value for :request_db_countrecords" do
    value = Request.get_operation_value(:request_db_countrecords)
    assert value == 9
  end

  test "get_operation_value for :request_datacluster_copy" do
    value = Request.get_operation_value(:request_datacluster_copy)
    assert value == 14
  end

  test "get_operation_value for :request_datacluster_lh_cluster_is_used" do
    value = Request.get_operation_value(:request_datacluster_lh_cluster_is_used)
    assert value == 16
  end

  test "get_operation_value for :request_record_metadata" do
    value = Request.get_operation_value(:request_record_metadata)
    assert value == 29
  end

  test "get_operation_value for :request_record_load" do
    value = Request.get_operation_value(:request_record_load)
    assert value == 30
  end

  test "get_operation_value for :request_record_load_if_version_not_latest" do
    value = Request.get_operation_value(:request_record_load_if_version_not_latest)
    assert value == 44
  end

  test "get_operation_value for :request_record_create" do
    value = Request.get_operation_value(:request_record_create)
    assert value == 31
  end

  test "get_operation_value for :request_record_update" do
    value = Request.get_operation_value(:request_record_update)
    assert value == 32
  end

  test "get_operation_value for :request_record_delete" do
    value = Request.get_operation_value(:request_record_delete)
    assert value == 33
  end

  test "get_operation_value for :request_record_copy" do
    value = Request.get_operation_value(:request_record_copy)
    assert value == 34
  end

  test "get_operation_value for :request_record_clean_out" do
    value = Request.get_operation_value(:request_record_clean_out)
    assert value == 38
  end

  test "get_operation_value for :request_positions_floor" do
    value = Request.get_operation_value(:request_positions_floor)
    assert value == 39
  end

  test "get_operation_value for :request_command" do
    value = Request.get_operation_value(:request_command)
    assert value == 41
  end

  test "get_operation_value for :request_positions_ceiling" do
    value = Request.get_operation_value(:request_positions_ceiling)
    assert value == 42
  end

  test "get_operation_value for :request_tx_commit" do
    value = Request.get_operation_value(:request_tx_commit)
    assert value == 60
  end

  test "get_operation_value for :request_db_reload" do
    value = Request.get_operation_value(:request_db_reload)
    assert value == 73
  end

  test "get_operation_value for :request_push_record" do
    value = Request.get_operation_value(:request_push_record)
    assert value == 79
  end

  test "get_operation_value for :request_push_distrib_config" do
    value = Request.get_operation_value(:request_push_distrib_config)
    assert value == 80
  end

  test "get_operation_value for :request_push_live_query" do
    value = Request.get_operation_value(:request_push_live_query)
    assert value == 81
  end

  test "get_operation_value for :request_db_copy" do
    value = Request.get_operation_value(:request_db_copy)
    assert value == 90
  end

  test "get_operation_value for :request_replication" do
    value = Request.get_operation_value(:request_replication)
    assert value == 91
  end

  test "get_operation_value for :request_cluster" do
    value = Request.get_operation_value(:request_cluster)
    assert value == 92
  end

  test "get_operation_value for :request_db_transfer" do
    value = Request.get_operation_value(:request_db_transfer)
    assert value == 93
  end

  test "get_operation_value for :request_db_freeze" do
    value = Request.get_operation_value(:request_db_freeze)
    assert value == 94
  end

  test "get_operation_value for :request_db_release" do
    value = Request.get_operation_value(:request_db_release)
    assert value == 95
  end

  test "get_operation_value for :request_create_sbtree_bonsai" do
    value = Request.get_operation_value(:request_create_sbtree_bonsai)
    assert value == 110
  end

  test "get_operation_value for :request_sbtree_bonsai_get" do
    value = Request.get_operation_value(:request_sbtree_bonsai_get)
    assert value == 111
  end

  test "get_operation_value for :request_sbtree_bonsai_first_key" do
    value = Request.get_operation_value(:request_sbtree_bonsai_first_key)
    assert value == 112
  end

  test "get_operation_value for :request_sbtree_bonsai_get_entries_major" do
    value = Request.get_operation_value(:request_sbtree_bonsai_get_entries_major)
    assert value == 113
  end

  test "get_operation_value for :request_ridbag_get_size" do
    value = Request.get_operation_value(:request_ridbag_get_size)
    assert value == 114
  end

  test "get_operation_value for :request_index_get" do
    value = Request.get_operation_value(:request_index_get)
    assert value == 120
  end

  test "get_operation_value for :request_index_put" do
    value = Request.get_operation_value(:request_index_put)
    assert value == 121
  end

  test "get_operation_value for :request_index_remove" do
    value = Request.get_operation_value(:request_index_remove)
    assert value == 122
  end

#  test "get_operation_value for :request_incremental_restore" do
#    value = Request.get_operation_value(:request_incremental_restore)
#    assert value == ???
#  end
end
