class GuildmasterController < ApplicationController
  # GET /guildmaster.json
  def index
    @guildmaster = Guildmaster.get_info
    respond_to do |format|
      #format.html # index.html.erb
      format.json { render json: @guildmaster }
    end
  end
end

