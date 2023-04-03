class GroupRemitsController < InheritedResources::Base

  private

    def group_remit_params
      params.require(:group_remit).permit(:name, :description, :agreement_id, :anniversary_id)
    end

end
