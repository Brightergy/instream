defmodule Instream.Connection.Config do
  @moduledoc """
  Configuration helper module.
  """

  @compile_time_keys [ :loggers ]
  @defaults [
    loggers: [{ Instream.Log.DefaultLogger, :log, [] }],
    port:    8086,
    scheme:  "http",
    writer:  Instream.Writer.Line
  ]


  @doc """
  Retrieves the compile time part of the connection configuration.
  """
  @spec compile_time(atom, module) :: Keyword.t
  def compile_time(otp_app, conn) do
    @defaults
    |> Keyword.merge(Application.get_env(otp_app, conn, []))
    |> Keyword.take(@compile_time_keys)
  end

  @doc """
  Retrieves the runtime connection configuration for `conn` in `otp_app`.
  """
  @spec runtime(atom, module) :: Keyword.t
  def runtime(otp_app, conn) do
    @defaults
    |> Keyword.put(:otp_app, otp_app)
    |> Keyword.merge(Application.get_env(otp_app, conn, []))
  end

  @doc """
  Validates a connection configuration and raises if an error exists.
  """
  @spec validate!(atom, module) :: no_return
  def validate!(otp_app, conn) do
    if :error == Application.fetch_env(otp_app, conn) do
      raise ArgumentError, "configuration for #{ inspect conn }" <>
                           " not found in #{ inspect otp_app } configuration"
    end
  end
end
