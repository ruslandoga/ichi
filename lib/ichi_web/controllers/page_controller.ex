defmodule IchiWeb.PageController do
  use IchiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
