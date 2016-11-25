defmodule Tudu.Router do
  use Tudu.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Tudu.Session, repo: Tudu.Repo
  end

  scope "/", Tudu do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", Tudu do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/todos", TodoController, except: [:new, :edit] do
      post "/complete", TodoController, :complete, as: :complete
    end
    post "/auth/login", SessionController, :login
    get "/auth/validate", SessionController, :validate
  end
end
