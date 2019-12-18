class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
      )
    )
  end

  def create
    @movie = Movie.new(
      title: params["title"],
      overview: params["overview"],
      release_date: params["release_date"],
      image_url: params["image_url"],
      external_id: params["external_id"],
      inventory: params["inventory"]
    )
    if @movie.save
      render json: @movie, status: :ok
      return
    else
      render json: { errors: { title: ["Failed to save to rental library"] } }, status: :bad_request
      return
    end
  end

  def update
    @movie = Movie.find_by(:titlex)
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
      )
    )
  end

  render(
    status: :ok,
    json: @movie.as_json(
      only: [:title, :overview, :release_date, :inventory],
      methods: [:available_inventory]
    )
  )
end


private

def require_movie
  @movie = Movie.find_by(title: params[:title])
  unless @movie
    render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
  end
end
