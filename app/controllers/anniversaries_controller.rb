class AnniversariesController < InheritedResources::Base

  private

    def anniversary_params
      params.require(:anniversary).permit(:name, :anniversary_date)
    end

end
