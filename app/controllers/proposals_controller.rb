class ProposalsController < InheritedResources::Base

  private

    def proposal_params
      params.require(:proposal).permit(:cooperative_id, :ave_age, :total_premium, :coop_sf, :agent_sf)
    end

end
