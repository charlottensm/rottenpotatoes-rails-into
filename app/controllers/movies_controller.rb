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
    #calls on the Movie model to get the keys of the hash

    #if both don't exist ==> not from where we were before
    if !params.has_key?(:sort) && !params.has_key?(:ratings)
      #if session has either saved ==> load that page
      if session.has_key?(:sort) || session.has_key?(:ratings)
        redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
      end
    end
   
    @all_ratings = Movie.all_ratings.keys


    #setting up ratings
    #if rating exists, ratings = params[:ratings]
    # else if sort does not exist, and rating does not exist, take all
    #if sort exist, but rating doesn't ==> take the session rating
    if !params[:ratings].nil?
      ratings = params[:ratings]
    else 
      if !params.has_key?(:sort)
        ratings = Movie.all_ratings
      else 
        #u only want to save this, if sort exists, but rating doesn't
        ratings = session[:ratings]
      end 
    end

    session[:ratings] = ratings

    #this method causes it to check all the boxes lmaoooo... 
    #hm so the ratings are being recorded in the session, but its not getting displayed 
    #TODO : solve both bugs lmao ....

    @ratings_to_show_hash = ratings
    
    #update sessions

    session[:sort] = if params.has_key?(:sort) then params[:sort] else {} end

    #showing sorting should also be done here, via the movie_path
    #how to pass parameters into movie_path
    #also... where is movie_path lmao
    #You may find it helpful to know that if you pass this helper method a hash of additional parameters, 
    #those parameters will be parsed by Rails and available in the params[] hash.
    if !params[:sort].nil?
      @movies = Movie.order(params[:sort]).with_ratings(ratings)
    else
      #this shows all the movies available
      @movies = Movie.with_ratings(ratings)
    end

    #ok time to redo this, and pick out the parameters
    

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
