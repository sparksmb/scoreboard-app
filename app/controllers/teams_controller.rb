class TeamsController < ApplicationController
  before_action :set_organization
  before_action :ensure_access_to_organization
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  
  # GET /teams
  def index
    if current_user.admin?
      @teams = Team.includes(:organization).order(:name)
      @organizations = Organization.active.order(:name)
    else
      @teams = @organization.teams.order(:name)
    end
  end
  
  # GET /teams/1
  def show
  end
  
  # GET /teams/new
  def new
    @team = @organization.teams.build
  end
  
  # GET /teams/1/edit
  def edit
  end
  
  # POST /teams
  def create
    @team = @organization.teams.build(team_params)
    
    if @team.save
      redirect_to team_path(@team), notice: 'Team was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to team_path(@team), notice: 'Team was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /teams/1
  def destroy
    if @team.destroy
      redirect_to teams_path, notice: 'Team was successfully deleted.'
    else
      redirect_to team_path(@team), alert: 'Cannot delete team with scheduled games.'
    end
  end
  
  private
  
  def set_organization
    if params[:organization_id]
      @organization = Organization.find(params[:organization_id])
    elsif current_user.admin?
      # For admin users viewing all teams, allow selecting organization
      @organization = params[:team]&.dig(:organization_id) ? 
                     Organization.find(params[:team][:organization_id]) : 
                     current_user.organization
    else
      @organization = current_user.organization
    end
  end
  
  def set_team
    if current_user.admin?
      @team = Team.find(params[:id])
      @organization = @team.organization
    else
      @team = @organization.teams.find(params[:id])
    end
  end
  
  def team_params
    params.require(:team).permit(:name, :mascot, :primary_color, :secondary_color, :logo, :organization_id)
  end
  
  def ensure_access_to_organization
    return if current_user.admin?
    
    unless @organization && current_user.organization == @organization
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
