require "rails_helper"

RSpec.describe LoanInsurance::DetailsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/loan_insurance/details").to route_to("loan_insurance/details#index")
    end

    it "routes to #new" do
      expect(get: "/loan_insurance/details/new").to route_to("loan_insurance/details#new")
    end

    it "routes to #show" do
      expect(get: "/loan_insurance/details/1").to route_to("loan_insurance/details#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/loan_insurance/details/1/edit").to route_to("loan_insurance/details#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/loan_insurance/details").to route_to("loan_insurance/details#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/loan_insurance/details/1").to route_to("loan_insurance/details#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/loan_insurance/details/1").to route_to("loan_insurance/details#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/loan_insurance/details/1").to route_to("loan_insurance/details#destroy", id: "1")
    end
  end
end
