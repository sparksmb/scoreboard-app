class OrganizationsController < ApplicationController
  before_action :ensure_admin!, only: [:new, :create, :destroy]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :ensure_access_to_organization, only: [:show, :edit, :update]
  
  # GET /organizations
  def index
    if current_user.admin?
      @organizations = Organization.all.order(:name)
    else
      # Regular users get redirected to their own organization
      redirect_to organization_path(current_user.organization)
    end
  end
  
  # GET /admin/organizations/1
  def show
  end
  
  # GET /admin/organizations/new
  def new
    @organization = Organization.new
  end
  
  # GET /admin/organizations/1/edit
  def edit
  end
  
  # POST /admin/organizations
  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      redirect_to organization_path(@organization), notice: 'Organization was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /admin/organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to organization_path(@organization), notice: 'Organization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /admin/organizations/1
  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: 'Organization was successfully deleted.'
  end
  
  private
  
  def set_organization
    @organization = Organization.find(params[:id])
  end
  
  def organization_params
    params.require(:organization).permit(:name, :active)
  end

  def ensure_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end

  def ensure_access_to_organization
    unless current_user.admin? || current_user.organization == @organization
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
