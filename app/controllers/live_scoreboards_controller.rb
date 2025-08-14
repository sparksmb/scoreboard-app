class LiveScoreboardsController < ApplicationController
  skip_before_action :authenticate_user!
  
  def show
    @organization = Organization.find(params[:organization_id])
    
    # Find the game for today or the next upcoming game
    today = Date.current
    @game = @organization.games
                         .joins(:home_team, :visitor_team)
                         .where('game_date >= ?', today)
                         .order(:game_date)
                         .first
    
    if @game&.scoreboard
      @scoreboard = @game.scoreboard
    else
      # If no game found or no scoreboard, render empty state
      @game = nil
      @scoreboard = nil
    end
    
    render layout: 'live_scoreboard'
  end
end
