class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
     @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
     if params[:ratings]
       @sel_ratings = params[:ratings].keys
       session[:ratingsKey] = params[:ratings]
     elsif session[:ratingsKey]
        @sel_ratings = session[:ratingsKey].keys
    else
      @sel_ratings = @all_ratings
    end
    
    @sel_ratings.each do |rating|
      params[rating] = true
    end
    
     if params[:filter]
       session[:filterKey] = params[:filter]
       @movies = Movie.order(params[:filter]).where(:rating => @sel_ratings)
     elsif session[:filterKey]
       @movies = Movie.order(session[:filterKey]).where(:rating => @sel_ratings)
      else
        @movies = Movie.where(:rating => @sel_ratings)
      end
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
  
  

end
