require "rails_helper"

RSpec.describe LoanInsurance::BatchRemitsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/loan_insurance/batch_remits").to route_to("loan_insurance/batch_remits#index")
    end

    it "routes to #new" do
      expect(get: "/loan_insurance/batch_remits/new").to route_to("loan_insurance/batch_remits#new")
    end

    it "routes to #show" do
      expect(get: "/loan_insurance/batch_remits/1").to route_to("loan_insurance/batch_remits#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/loan_insurance/batch_remits/1/edit").to route_to("loan_insurance/batch_remits#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/loan_insurance/batch_remits").to route_to("loan_insurance/batch_remits#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/loan_insurance/batch_remits/1").to route_to("loan_insurance/batch_remits#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/loan_insurance/batch_remits/1").to route_to("loan_insurance/batch_remits#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/loan_insurance/batch_remits/1").to route_to("loan_insurance/batch_remits#destroy", id: "1")
    end
  end
end
