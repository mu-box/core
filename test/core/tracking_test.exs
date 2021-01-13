defmodule Core.TrackingTest do
  use Core.DataCase

  alias Core.Tracking

  describe "job_logs" do
    alias Core.Tracking.JobLog

    @valid_attrs %{args: %{}, attempt: 42, level: "some level", line: "some line", worker: "some worker"}
    @update_attrs %{args: %{}, attempt: 43, level: "some updated level", line: "some updated line", worker: "some updated worker"}
    @invalid_attrs %{args: nil, attempt: nil, level: nil, line: nil, worker: nil}

    def job_log_fixture(attrs \\ %{}) do
      {:ok, job_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracking.create_job_log()

      job_log
    end

    test "list_job_logs/0 returns all job_logs" do
      job_log = job_log_fixture()
      assert Tracking.list_job_logs() == [job_log]
    end

    test "get_job_log!/1 returns the job_log with given id" do
      job_log = job_log_fixture()
      assert Tracking.get_job_log!(job_log.id) == job_log
    end

    test "create_job_log/1 with valid data creates a job_log" do
      assert {:ok, %JobLog{} = job_log} = Tracking.create_job_log(@valid_attrs)
      assert job_log.args == %{}
      assert job_log.attempt == 42
      assert job_log.level == "some level"
      assert job_log.line == "some line"
      assert job_log.worker == "some worker"
    end

    test "create_job_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_job_log(@invalid_attrs)
    end

    test "update_job_log/2 with valid data updates the job_log" do
      job_log = job_log_fixture()
      assert {:ok, %JobLog{} = job_log} = Tracking.update_job_log(job_log, @update_attrs)
      assert job_log.args == %{}
      assert job_log.attempt == 43
      assert job_log.level == "some updated level"
      assert job_log.line == "some updated line"
      assert job_log.worker == "some updated worker"
    end

    test "update_job_log/2 with invalid data returns error changeset" do
      job_log = job_log_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_job_log(job_log, @invalid_attrs)
      assert job_log == Tracking.get_job_log!(job_log.id)
    end

    test "delete_job_log/1 deletes the job_log" do
      job_log = job_log_fixture()
      assert {:ok, %JobLog{}} = Tracking.delete_job_log(job_log)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_job_log!(job_log.id) end
    end

    test "change_job_log/1 returns a job_log changeset" do
      job_log = job_log_fixture()
      assert %Ecto.Changeset{} = Tracking.change_job_log(job_log)
    end
  end
end
