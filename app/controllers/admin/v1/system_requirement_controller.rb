module Admin::V1
  class SystemRequirementController < ApiController

    before_action :load_category, only: [:update, :destroy]

    def index
      @system_requirements = SystemRequirement.all
    end

    def create
      @system_requirement = SystemRequirement.new
      @system_requirement.attributes = system_requirements_params
      save_system_requeriment!
    end

    def update
      @system_requirement.attributes = system_requirements_params
      save_system_requeriment!
    end

    def destroy
      @system_requirement.destroy!
    rescue
      render_error(fields: @system_requirement.errors.messages)
    end
  
  private

    def load_system_requirements
      @system_requirement = SystemRequirement.find(params[:id])
    end

    def system_requirements_params
      return {} unless params.has.has_key?(:system_requirement)
      params.require(:system_requirement).permit(:name, :operational_system, :storage, :processor, :memory, :video_board)
    end

    def save_system_requeriment!
      @system_requirement.save!
      render :show
    rescue
      render_error(fields: @system_requirement.errors.message)
  end
end