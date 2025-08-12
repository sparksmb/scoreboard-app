class Admin::OrganizationsController < WebApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  
  # GET /admin/organizations
  def index
    @organizations = Organization.all.order(:name)
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
      redirect_to admin_organization_path(@organization), notice: 'Organization was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /admin/organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to admin_organization_path(@organization), notice: 'Organization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /admin/organizations/1
  def destroy
    @organization.destroy
    redirect_to admin_organizations_path, notice: 'Organization was successfully deleted.'
  end
  
  private
  
  def set_organization
    @organization = Organization.find(params[:id])
  end
  
  def organization_params
    params.require(:organization).permit(:name, :active)
  end
end
