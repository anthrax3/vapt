class NessusReportsController < ApplicationController
  # GET /engagements/:engagement_id/nessus/:nessu_id/nessus_reports(.:format)
  def index
    @engagement = Engagement.find(params[:engagement_id])
    @nessus_policy = @engagement.nessus_policies.find(params[:nessus_id])

  end
end
