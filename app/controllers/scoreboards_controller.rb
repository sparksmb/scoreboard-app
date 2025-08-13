class ScoreboardsController < ApplicationController
  before_action :set_game_and_scoreboard
  before_action :ensure_access_to_organization
  
  # GET /games/:game_id/scoreboards/:id
  def show
  end
  
  # GET /games/:game_id/scoreboards/:id/edit
  def edit
  end
  
  # PATCH/PUT /games/:game_id/scoreboards/:id
  def update
    if @scoreboard.update(scoreboard_params)
      redirect_to game_scoreboard_path(@game, @scoreboard), notice: 'Scoreboard was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_game_and_scoreboard
    @game = Game.find(params[:game_id])
    @scoreboard = @game.scoreboard
    @organization = @game.organization
    
    # Create scoreboard if it doesn't exist (default to Football)
    unless @scoreboard
      @scoreboard = @game.create_scoreboard(type: 'FootballScoreboard')
    end
  end
  
  def scoreboard_params
    case @scoreboard.type
    when 'FootballScoreboard'
      params.require(:scoreboard).permit(:home_score, :visitor_score, :quarter, :time_remaining)
    else
      params.require(:scoreboard).permit(:home_score, :visitor_score)
    end
  end
  
  def ensure_access_to_organization
    return if current_user.admin?
    
    unless @organization && current_user.organization == @organization
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
