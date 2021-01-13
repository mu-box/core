defmodule Core.Tracking do
  @moduledoc """
  The Tracking context.
  """

  import Ecto.Query, warn: false
  alias Core.Repo

  alias Core.Tracking.JobLog

  @doc """
  Returns the list of job_logs.

  ## Examples

      iex> list_job_logs()
      [%JobLog{}, ...]

  """
  def list_job_logs do
    Repo.all(JobLog)
  end

  @doc """
  Gets a single job_log.

  Raises `Ecto.NoResultsError` if the Job log does not exist.

  ## Examples

      iex> get_job_log!(123)
      %JobLog{}

      iex> get_job_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job_log!(id), do: Repo.get!(JobLog, id)

  @doc """
  Creates a job_log.

  ## Examples

      iex> create_job_log(%{field: value})
      {:ok, %JobLog{}}

      iex> create_job_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job_log(attrs \\ %{}) do
    # TODO: Pass message to the UI
    %JobLog{}
    |> JobLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job_log.

  ## Examples

      iex> update_job_log(job_log, %{field: new_value})
      {:ok, %JobLog{}}

      iex> update_job_log(job_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job_log(%JobLog{} = job_log, attrs) do
    job_log
    |> JobLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job_log.

  ## Examples

      iex> delete_job_log(job_log)
      {:ok, %JobLog{}}

      iex> delete_job_log(job_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job_log(%JobLog{} = job_log) do
    Repo.delete(job_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job_log changes.

  ## Examples

      iex> change_job_log(job_log)
      %Ecto.Changeset{source: %JobLog{}}

  """
  def change_job_log(%JobLog{} = job_log) do
    JobLog.changeset(job_log, %{})
  end
end
