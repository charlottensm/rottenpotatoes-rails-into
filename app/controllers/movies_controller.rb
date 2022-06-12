class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #needs the checkboxes to persist across sessions
    #lol the issue w this, is that it records the previous selection????
    # ok by setting it here, the session[:ratings] gets updated
    # session[:ratings] = if params[:ratings].nil? then {} else params[:ratings] end

    #i guess it saves from the previous round???? idk tbh
    @ratings_to_show_hash = (if params.has_key?(:ratings) then params[:ratings] else {} end)
    #calls on the Movie model to get the keys of the hash
    @all_ratings = Movie.all_ratings.keys
    #this shows all the movies available
    @movies = Movie.with_ratings(if params[:ratings].nil? then Movie.all_ratings else params[:ratings] end)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
