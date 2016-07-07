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
    #set the value of all_ratings. Only returns values currently in the database as filters, not all possible values. 
    @all_ratings = Movie.uniq.pluck(:rating).sort
    #instance variables controlling the ID of the title and release date headers
    @titleID = "title_headder"
    @rdID = "release_date_header"
    
    @filtered_ratings = @all_ratings
    @movies = Movie.all
    
    if params[:sort_type] != nil
      sorted
      @filtered_ratings = []
    else if params[:ratings] != nil
      @filtered_ratings = params[:ratings]
      filtered
    else
      
    end
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
    else if params[:sort_type] == "release_date"
      @RDclass = "hilite"
    end
    end
  end
  
  
  #method to filter based on selected checkbox ratings
  def filtered
    if params[:ratings] != nil
      @filter = params[:ratings].keys
      @movies = @movies.where({rating: @filter})
    end
  end
  
  def sorted
    #call highlight function
    hilite 
    #return the sorted movies list. 
    @movies = @movies.order(params[:sort_type])
  end
  
end
