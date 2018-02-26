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
  @all_ratings = Movie.ratings
   redirect = false
   @sort_by = params[:sort_by]
   if (@sort_by)
     session[:sort_by] = @sort_by
   elsif session[:sort_by]
     @sort_by = session[:sort_by]
     redirect = true
   end
   @ratings ||= []
   if params[:ratings]
     @ratings = (params[:commit] == 'Refresh') ? params[:ratings].keys : params[:ratings]
     session[:ratings] = @ratings
   elsif session[:ratings]
     @ratings = session[:ratings]
     redirect = true
   end
   if @ratings.empty?
     @movies = Movie.order(@sort_by)
   else
    @movies = Movie.where(:rating => @ratings).order(@sort_by)
   end
   if (redirect) 
     redirect_to movies_path({:sort_by => @sort_by, :ratings => @ratings}) 
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
