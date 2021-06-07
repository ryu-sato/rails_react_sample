module API
  module V1
    class ChildrenController < APIBaseController
      def index
        parent = Parent.find_by(id: params[:parent_id])
        raise ::API::Errors::InvalidRequest, '"parent_id" is required' if parent.blank?

        render json: ChildSerializer.new(parent.children).serializable_hash.to_json
      end
    end
  end
end
