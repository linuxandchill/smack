defmodule Smack.UserController do
  use Smack.Web, :controller

  alias Smack.User

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt = Guardian.Plug.current_token(new_conn)

        new_conn
        |> put_status(:created)
        |> render(Smack.SessionView, "show.json", user: user, jwt: jwt)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Smack.ChangesetView, "error.json", changeset: changeset)
    end
  end
end

##defmodule Smack.UserController do
##  use Smack.Web, :controller
##
##  alias Smack.User
##
##  def index(conn, _params) do
##    users = Repo.all(User)
##    render(conn, "index.json", users: users)
##  end
##
##  def create(conn, %{"user" => user_params}) do
##    changeset = User.changeset(%User{}, user_params)
##
##    case Repo.insert(changeset) do
##      {:ok, user} ->
##        conn
##        |> put_status(:created)
##        |> put_resp_header("location", user_path(conn, :show, user))
##        |> render("show.json", user: user)
##      {:error, changeset} ->
##        conn
##        |> put_status(:unprocessable_entity)
##        |> render(Smack.ChangesetView, "error.json", changeset: changeset)
##    end
##  end
##
##  def show(conn, %{"id" => id}) do
##    user = Repo.get!(User, id)
##    render(conn, "show.json", user: user)
##  end
##
##  def update(conn, %{"id" => id, "user" => user_params}) do
##    user = Repo.get!(User, id)
##    changeset = User.changeset(user, user_params)
##
##    case Repo.update(changeset) do
##      {:ok, user} ->
##        render(conn, "show.json", user: user)
##      {:error, changeset} ->
##        conn
##        |> put_status(:unprocessable_entity)
##        |> render(Smack.ChangesetView, "error.json", changeset: changeset)
##    end
##  end
##
##  def delete(conn, %{"id" => id}) do
##    user = Repo.get!(User, id)
##
##    # Here we use delete! (with a bang) because we expect
##    # it to always work (and if it does not, it will raise).
##    Repo.delete!(user)
##
##    send_resp(conn, :no_content, "")
##  end
##end