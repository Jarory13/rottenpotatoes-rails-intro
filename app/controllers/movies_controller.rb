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
    #instance variables controlling the ID of the title and release date headers
    @titleID = "title_headder"
    @rdID = "release_date_header"
    
    #sort params if a sort type is provided
    if params[:sort_type] != nil
    #call hilite functino to select which column recieves the hilite variable. 
    hilite 
    #return the sorted movies list. 
    @movies = Movie.all.order(params[:sort_type])
    else
      @movies = Movie.all
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
  
  #find which symbol should be hilighted  
  def hilite
    if params[:sort_type] == "title"
      @titleclass= "hilite"
    else
      @RDclass = "hilite"
    end
  end
  
end
