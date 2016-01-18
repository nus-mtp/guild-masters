class Guild < ActiveRecord::Base
	belongs_to :guildmaster
	has_many :quests, dependent: :destroy
	has_many :adventurers, dependent: :destroy
	
	def self.get_info
	  guild = Guild.find(1)
	  return guild
	end

end
