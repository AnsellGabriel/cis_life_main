require "rails_helper"

RSpec.describe LoanInsurance::BatchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/loan_insurance/batches").to route_to("loan_insurance/batches#index")
    end

    it "routes to #new" do
      expect(get: "/loan_insurance/batches/new").to route_to("loan_insurance/batches#new")
    end

    it "routes to #show" do
      expect(get: "/loan_insurance/batches/1").to route_to("loan_insurance/batches#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/loan_insurance/batches/1/edit").to route_to("loan_insurance/batches#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/loan_insurance/batches").to route_to("loan_insurance/batches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/loan_insurance/batches/1").to route_to("loan_insurance/batches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/loan_insurance/batches/1").to route_to("loan_insurance/batches#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/loan_insurance/batches/1").to route_to("loan_insurance/batches#destroy", id: "1")
    end
  end
end
