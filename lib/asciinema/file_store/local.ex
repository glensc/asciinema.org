defmodule Asciinema.FileStore.Local do
  @behaviour Asciinema.FileStore
  import Plug.Conn
  alias Plug.MIME

  def put_file(dst_path, src_local_path, _content_type) do
    full_dst_path = base_path() <> dst_path
    parent_dir = Path.dirname(full_dst_path)

    with :ok <- File.mkdir_p(parent_dir),
         {:ok, _} <- File.copy(src_local_path, full_dst_path) do
      :ok
    end
  end

  def serve_file(conn, path, nil) do
    do_serve_file(conn, path)
  end
  def serve_file(conn, path, filename) do
    conn
    |> put_resp_header("content-disposition", "attachment; filename=#{filename}")
    |> do_serve_file(path)
  end

  defp do_serve_file(conn, path) do
    conn
    |> put_resp_header("content-type", MIME.path(path))
    |> send_file(200, base_path() <> path)
    |> halt
  end

  def open(path) do
    File.open(base_path() <> path, [:binary, :read])
  end
  def open(path, function) do
    File.open(base_path() <> path, [:binary, :read], function)
  end

  defp config do
    Application.get_env(:asciinema, Asciinema.FileStore.Local)
  end

  defp base_path do
    Keyword.get(config(), :path)
  end
end
