module API
  module V1
    class ChildrenController < APIBaseController
      before_action :set_parent, only: %i[index create]

      def index
        render json: ChildSerializer.new(@parent.children).serializable_hash.to_json
      end

      def create
        child = Child.new(child_params.to_hash.update(parent: @parent))
        if child.save
          render json: ChildSerializer.new(child).serializable_hash.to_json
        else
          render json: { error: 'cannot save child' }
        end
      end

      private
      
      def set_parent
        @parent = Parent.find_by(id: params[:parent_id])
        raise ::API::Errors::InvalidRequest, '"parent_id" is required' if @parent.blank?
      end
      
      def child_params
        params.require(:child).permit(:name)
      end
    end
  end
end
