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
    # Log what we received for debugging
    Rails.logger.info "=== SCOREBOARD UPDATE DEBUG ==="
    Rails.logger.info "Params received: #{params.inspect}"
    Rails.logger.info "Scoreboard type: #{@scoreboard.type}"
    Rails.logger.info "Looking for param key: #{@scoreboard.type.underscore}"
    Rails.logger.info "Scoreboard params: #{scoreboard_params.inspect}"
    Rails.logger.info "Before update - home timeouts: #{@scoreboard.home_timeouts_remaining}, visitor timeouts: #{@scoreboard.visitor_timeouts_remaining}"
    
    if @scoreboard.update(scoreboard_params)
      @scoreboard.reload
      Rails.logger.info "After update - home timeouts: #{@scoreboard.home_timeouts_remaining}, visitor timeouts: #{@scoreboard.visitor_timeouts_remaining}"
      redirect_to game_scoreboard_path(@game, @scoreboard), notice: 'Scoreboard was successfully updated.'
    else
      Rails.logger.info "Update failed: #{@scoreboard.errors.full_messages}"
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
    # Handle STI parameter names - Rails uses the specific class name
    param_key = @scoreboard.type.underscore.to_sym

    case @scoreboard.type
    when 'FootballScoreboard'
      params.require(param_key).permit(:home_score, :visitor_score, :quarter, :time_remaining, :time_remaining_visible, :home_timeouts_remaining, :visitor_timeouts_remaining)
    else
      params.require(param_key).permit(:home_score, :visitor_score, :home_timeouts_remaining, :visitor_timeouts_remaining)
    end
  end

  def ensure_access_to_organization
    return if current_user.admin?

    unless @organization && current_user.organization == @organization
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
