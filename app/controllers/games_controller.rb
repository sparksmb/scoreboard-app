class GamesController < ApplicationController
  before_action :set_organization
  before_action :ensure_access_to_organization
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  
  # GET /games
  def index
    if current_user.admin?
      @games = Game.includes(:organization, :home_team, :visitor_team).order(:game_date)
      @organizations = Organization.active.order(:name)
    else
      @games = @organization.games.includes(:home_team, :visitor_team).order(:game_date)
    end
  end
  
  # GET /games/1
  def show
  end
  
  # GET /games/new
  def new
    @game = @organization.games.build
    @teams = @organization.teams.order(:name)
  end
  
  # GET /games/1/edit
  def edit
    @teams = @organization.teams.order(:name)
  end
  
  # POST /games
  def create
    @game = @organization.games.build(game_params)
    
    if @game.save
      # Create default scoreboard based on sport type (defaulting to Football for now)
      @game.create_scoreboard(type: 'FootballScoreboard')
      redirect_to game_path(@game), notice: 'Game was successfully created.'
    else
      @teams = @organization.teams.order(:name)
      render :new, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /games/1
  def update
    if @game.update(game_params)
      redirect_to game_path(@game), notice: 'Game was successfully updated.'
    else
      @teams = @organization.teams.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /games/1
  def destroy
    @game.destroy
    redirect_to games_path, notice: 'Game was successfully deleted.'
  end
  
  private
  
  def set_organization
    if params[:organization_id]
      @organization = Organization.find(params[:organization_id])
    elsif current_user.admin?
      # For admin users viewing all games, allow selecting organization
      @organization = params[:game]&.dig(:organization_id) ? 
                     Organization.find(params[:game][:organization_id]) : 
                     current_user.organization
    else
      @organization = current_user.organization
    end
  end
  
  def set_game
    if current_user.admin?
      @game = Game.find(params[:id])
      @organization = @game.organization
    else
      @game = @organization.games.find(params[:id])
    end
  end
  
  def game_params
    params.require(:game).permit(:home_team_id, :visitor_team_id, :game_date, :location, :description, :organization_id)
  end
  
  def ensure_access_to_organization
    return if current_user.admin?
    
    unless @organization && current_user.organization == @organization
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
