defmodule AppWeb.Pow.RedisCacheTest do
  use ExUnit.Case
  doctest AppWeb.PowRedisCache

  alias ExUnit.CaptureLog
  alias AppWeb.PowRedisCache

  @default_config [namespace: "test", ttl: :timer.hours(1)]

  setup do
    Redix.command!(:redix, ["FLUSHALL"])

    :ok
  end

  test "can put, get and delete records" do
    assert PowRedisCache.get(@default_config, "key") == :not_found

    PowRedisCache.put(@default_config, {"key", "value"})
    :timer.sleep(100)
    assert PowRedisCache.get(@default_config, "key") == "value"

    PowRedisCache.delete(@default_config, "key")
    :timer.sleep(100)
    assert PowRedisCache.get(@default_config, "key") == :not_found
  end

  describe "with redis errors" do
    setup do
      ["maxmemory", value] = Redix.command!(:redix, ["CONFIG", "GET", "maxmemory"])

      Redix.command!(:redix, ["CONFIG", "SET", "maxmemory", "10"])

      on_exit(fn ->
        Redix.command!(:redix, ["CONFIG", "SET", "maxmemory", value])
      end)
    end

    test "logs error" do
      assert CaptureLog.capture_log(fn ->
        PowRedisCache.put(@default_config, {"key", "value"})
        :timer.sleep(100)
      end) =~ "(RuntimeError) Redix failed SET because of [%Redix.Error{message: \"OOM command not allowed when used memory > 'maxmemory'.\"}]"
    end
  end

  test "can put multiple records at once" do
    PowRedisCache.put(@default_config, [{"key1", "1"}, {"key2", "2"}])
    :timer.sleep(100)
    assert PowRedisCache.get(@default_config, "key1") == "1"
    assert PowRedisCache.get(@default_config, "key2") == "2"
  end

  test "can match fetch all" do
    assert PowRedisCache.all(@default_config, :_) == []

    for number <- 1..11, do: PowRedisCache.put(@default_config, {"key#{number}", "value"})
    :timer.sleep(100)
    items = PowRedisCache.all(@default_config, :_)

    assert Enum.find(items, fn {key, "value"} -> key == "key1" end)
    assert Enum.find(items, fn {key, "value"} -> key == "key2" end)
    assert length(items) == 11

    PowRedisCache.put(@default_config, {["namespace", "key"], "value"})
    :timer.sleep(100)

    assert PowRedisCache.all(@default_config, ["namespace", :_]) ==  [{["namespace", "key"], "value"}]
  end

  test "records auto purge" do
    config = Keyword.put(@default_config, :ttl, 100)

    PowRedisCache.put(config, {"key", "value"})
    PowRedisCache.put(config, [{"key1", "1"}, {"key2", "2"}])
    :timer.sleep(50)
    assert PowRedisCache.get(config, "key") == "value"
    assert PowRedisCache.get(config, "key1") == "1"
    assert PowRedisCache.get(config, "key2") == "2"
    :timer.sleep(100)
    assert PowRedisCache.get(config, "key") == :not_found
    assert PowRedisCache.get(config, "key1") == :not_found
    assert PowRedisCache.get(config, "key2") == :not_found
  end
end
