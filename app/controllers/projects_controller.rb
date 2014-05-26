class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    1.times do
      @question = @project.questions.build
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        kit = IMGKit.new(render_to_string(:partial => 'form', :layout => false,:locals => {:project => @project}))#it takes html and any options for wkhtmltoimage
        kit.stylesheets << "#{Rails.root.to_s}/app/assets/stylesheets/ImgKit.css" #its apply the give css to the converted image 
        t = kit.to_img(:png) # convert image to specific format
        file = kit.to_file(Rails.root + "public/assets/" + "screenshot.png")#storing path of converted file
        format.html { redirect_to root_url, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        kit = IMGKit.new(render_to_string(:partial => 'form', :layout => false,:locals => {:project => @project})) #it takes html and any options for wkhtmltoimage
        kit.stylesheets << "#{Rails.root.to_s}/app/assets/stylesheets/ImgKit.css" #its apply the give css to the converted image 
        t = kit.to_img(:png) # convert image to specific format
        file = kit.to_file(Rails.root + "public/assets/" + "screenshot.png")#storing path of converted file
        #render :text =>kit and return false
        format.html { redirect_to root_url, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
