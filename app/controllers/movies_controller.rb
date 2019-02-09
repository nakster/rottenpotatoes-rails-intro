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
    # @all_ratings = Movie.ratings
    # @sort = params[:sort] || session[:sort] 
    # session[:ratings] = session[:ratings] || {'G'=>'','PG'=>'','PG-13'=>'','R'=>''}
    # @t_param = params[:ratings] || session[:ratings]
    # session[:sort] = @sort
    # session[:ratings] = @t_param 
   
    # @selected_ratings = params[:ratings] || session[:ratings] || {}
    # sort = params[:sort] || session[:sort]
    
    # if(params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:rating].nil?))
    # flash.keep
    # #redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    # redirect_to :sort => sort, :ratings => @selected_ratings and return
    # end
    
    # @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    
    if(!params.has_key?(:sort) && !params.has_key?(:ratings))
      if(session.has_key?(:sort) || session.has_key?(:ratings))
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      end
    end
    @sort = params.has_key?(:sort) ? (session[:sort] = params[:sort]) : session[:sort]
    @all_ratings = Movie.all_ratings.keys
    @ratings = params[:ratings]
    if(@ratings != nil)
      ratings = @ratings.keys
      session[:ratings] = @ratings
    else
      if(!params.has_key?(:commit) && !params.has_key?(:sort))
        ratings = Movie.all_ratings.keys
        session[:ratings] = Movie.all_ratings
      else
        ratings = session[:ratings].keys
      end
    end
    # @movies = Movie.order(@sort).find_or_create_by(ratings)
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    @mark  = ratings
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
