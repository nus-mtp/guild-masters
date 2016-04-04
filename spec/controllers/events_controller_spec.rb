require 'rails_helper'
#rspec spec/controllers/events_controller_spec.rb
#zeus test spec/controllers/events_controller_spec.rb

RSpec.describe EventsController do
  before :each do
    @activated_account = create(:account, :activated)
    @guildmaster = @activated_account.guildmaster
    @guild = Guild.find_by(guildmaster_id: @guildmaster.id)
    @new_adventurer = create(:adventurer, guild_id: @guild.id)
    @facility = Facility.find_by(guild_id: @guild.id)
    @guildmaster.current_guild_id = @guild.id
    @guildmaster.save
  end
  describe 'POST #create' do
    context "valid session" do
      context "when params[:cmd] == get" do
        it "get events" do
          request.session[:account_id] = @activated_account.id
          post :create, {cmd: "get"} , format: :json
          expect(response.status).to eq(200)
          expect(Account.count).to eq(1)
          expect(Guild.count).to eq(1)
          expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
          expect(session[:account_id]).to_not be nil
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["events"]).to_not be nil
        end
      end
      context "when params[:cmd] == complete" do
        context "valid" do
          it "complete events" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "complete", end_time: "123"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["events"]).to_not be nil
          end
        end
        context "invalid" do
          it "empty end_time" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "complete", end_time: nil} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "end_time_nil"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
        context "error" do
          it "end_time less than game_time" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "complete", end_time: "-100"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "invalid_end_time"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
      end
      context "when params[:cmd] == create_guild_upgrade_event" do
        context "valid" do
          it "create guild upgrade event" do
            @guildmaster.gold = (2000*(@guild.level+1))+10
            @guild.popularity = (100*(2**(@guild.level-1)))+10
            @guildmaster.state = "available"
            @facility.capacity = @facility.level*2
            @guildmaster.save
            @guild.save
            @facility.save
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_guild_upgrade_event"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "success"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["gold_spend"]).to_not be nil
            expect(parsed_body["time_cost"]).to_not be nil
          end
        end
        context "error" do
          it "guildmaster is busy" do
            @guildmaster.gold = (2000*(@guild.level+1))+10
            @guild.popularity = (100*(2**(@guild.level-1)))+10
            @guildmaster.state = "busy"
            @facility.capacity = @facility.level*2
            @guildmaster.save
            @guild.save
            @facility.save
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_guild_upgrade_event"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "guildmaster_busy"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "not enough gold" do
            @guildmaster.gold = (2000*(@guild.level+1))-10
            @guild.popularity = (100*(2**(@guild.level-1)))+10
            @guildmaster.state = "available"
            @facility.capacity = @facility.level*2
            @guildmaster.save
            @guild.save
            @facility.save
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_guild_upgrade_event"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "not_enough_gold"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "facility in used" do
            @guildmaster.gold = (2000*(@guild.level+1))+10
            @guild.popularity = (100*(2**(@guild.level-1)))+10
            @guildmaster.state = "available"
            @facility.capacity = @facility.level*1
            @guildmaster.save
            @guild.save
            @facility.save
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_guild_upgrade_event"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "facility_in_used"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "not enough popularity" do
            @guildmaster.gold = (2000*(@guild.level+1))+10
            @guild.popularity = (100*(2**(@guild.level-1)))-10
            @guildmaster.state = "available"
            @facility.capacity = @facility.level*2
            @guildmaster.save
            @guild.save
            @facility.save
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_guild_upgrade_event"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "not_enough_popularity"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
      end
      context "when params[:cmd] == create_quest_event" do
        context "valid" do
          it "assigns adventurers to quest" do
            @quest = Quest.find_by(guild_id: @guild.id)
            @adventurers = Adventurer.where(guild_id: @guild.id)
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_quest_event", quest_id: @quest.id, adventurers_ids: @adventurers.ids} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "success"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
          end
        end
        context "invalid" do
          it "empty adventurers id" do
            @quest = Quest.find_by(guild_id: @guild.id)
            @adventurers = Adventurer.where(guild_id: @guild.id)
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_quest_event", quest_id: @quest.id, adventurers_ids: nil} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "adventurers_id_nil"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "wrong adventurers id" do
            @quest = Quest.find_by(guild_id: @guild.id)
            @adventurers = Adventurer.where(guild_id: @guild.id)
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_quest_event", quest_id: @quest.id, adventurers_ids: 9999} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "invalid_adventurers_ids"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "wrong quest id" do
            @quest = Quest.find_by(guild_id: @guild.id)
            @adventurers = Adventurer.where(guild_id: @guild.id)
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_quest_event", quest_id: !@quest.id, adventurers_ids: @adventurers.ids} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "invalid_quest_id"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "empty quest id" do
            @quest = Quest.find_by(guild_id: @guild.id)
            @adventurers = Adventurer.where(guild_id: @guild.id)
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_quest_event", quest_id: nil, adventurers_ids: @adventurers.ids} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "quest_id_nil"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
        context "error" do
          it "quest assigned" do
            @quest = Quest.find_by(guild_id: @guild.id)
            @quest.state = "assigned"
            @quest.save
            @adventurers = Adventurer.where(guild_id: @guild.id)
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_quest_event", quest_id: @quest.id, adventurers_ids: @adventurers.ids} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "quest_not_available"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "adventurer dead" do
            @quest = Quest.find_by(guild_id: @guild.id)
            @new_adventurer.state = "dead"
            @new_adventurer.save
            @adventurers = Adventurer.where(guild_id: @guild.id)
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_quest_event", quest_id: @quest.id, adventurers_ids: @adventurers.ids} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "adventurer_not_available"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
      end
      context "when params[:cmd] == create_scout_event" do
        context "valid" do
          it "scouts" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_scout_event", time_spent: "10", gold_spent: "10"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "success"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
          end
        end
        context "invalid" do
          it "empty time" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_scout_event", time_spent: nil, gold_spent: "10"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "time_nil"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "empty gold" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_scout_event", time_spent: "10", gold_spent: nil} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "gold_nil"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
        context "error" do
          it "guildmaster is busy" do
            @guildmaster.state = "busy"
            @guildmaster.save
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_scout_event", time_spent: "10", gold_spent: "10"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "guildmaster_busy"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "not enough gold" do
            @guildmaster.gold = 0
            @guildmaster.save
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_scout_event", time_spent: "10", gold_spent: "10"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "not_enough_gold"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
          it "guild is full" do
            $i = 0
            while $i <= (@guild.level*5)+1 do
              create(:adventurer, guild_id: @guild.id)
              $i +=1
            end
            $i = 0
            while $i <= (@guild.level*10)+1 do
              create(:quest, guild_id: @guild.id)
              $i +=1
            end
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "create_scout_event", time_spent: "10", gold_spent: "10"} , format: :json
            expect(response.status).to eq(200)
            expect(Account.count).to eq(1)
            expect(Guild.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            expect(session[:account_id]).to_not be nil
            @msg_expected = "error"
            @detail_expected = "guild_full"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
      end
      context "when params[:cmd] == create_facility_event" do
        context "valid" do

        end
        context "invalid" do

        end
        context "error" do

        end
      end
      context "when params[:cmd] == nil or not valid" do
        context "invalid params" do
          it "empty cmd" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: nil} , format: :json
            expect(response.status).to eq 200
            expect(Account.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            @msg_expected = "error"
            @detail_expected = "cmd_nil"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
        context "error" do
          it "invalid cmd" do
            request.session[:account_id] = @activated_account.id
            post :create, {cmd: "not_valid_cmd"}, format: :json
            expect(response.status).to eq 200
            expect(Account.count).to eq(1)
            expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
            @msg_expected = "error"
            @detail_expected = "no_such_cmd"
            parsed_body = JSON.parse(response.body)
            expect(parsed_body["msg"]).to eq(@msg_expected)
            expect(parsed_body["detail"]).to eq(@detail_expected)
          end
        end
      end
    end
    context "invalid session" do
      it "renders 401" do
        post :create, {cmd: "create"}
        expect(response.status).to eq(401)
      end
    end
  end
end
