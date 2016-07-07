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
    
    @movies = Movie.all

    
    if params[:sort_type] != nil
      session[:sort_type] = params[:sort_type]
      filtered
    else if params[:ratings] != nil
      session[:ratings] = params[:ratings]
      filtered
    end
    end
      @filtered_ratings = session[:ratings] || @all_ratings
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
    if session[:sort_type] == "title"
      @titleclass= "hilite"
    else if session[:sort_type] == "release_date"
      @RDclass = "hilite"
    end
    end
  end
  
  
  #method to filter based on selected checkbox ratings
  def filtered
    if session[:ratings] != nil
      @filter = session[:ratings].keys
      @movies = @movies.where({rating: @filter}).order(session[:sort_type])
      if session[:sort_type] !=nil
        hilite
      end
    end
  end
  
  # def sorted
  #   #call highlight function
  #   hilite 
  #   filtered
  #   #return the sorted movies list. 
  #   @movies = @movies.order(session[:sort_type])
  # end
  
end
