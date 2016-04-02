require 'faker'

FactoryGirl.define do
  factory :account do
    id { Faker::Number.number(3) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirm_token { Faker::Number.number(4) }
    email_confirmed { false }
    trait :activated do
      email_confirmed true
    end
    after(:create) do |account|
      FactoryGirl.create(:guildmaster, account_id: account.id)
    end
  end

  factory :guildmaster do
    id { Faker::Number.number(3) }
    gold 1000
    game_time 0
    state "available"
    current_guild_id 0
    account_id 0
    after(:create) do |guildmaster|
      FactoryGirl.create(:guild, guildmaster_id: guildmaster.id)
    end
    # association :account, factory: :account, email_confirmed: true
  end

  factory :guild do |g|
    id { Faker::Number.number(3) }
    level { Faker::Number.between(1, 3) }
    popularity { Faker::Number.number(2) }
    guildmaster_id 0
    after(:create) do |guild|
      FactoryGirl.create(:adventurer, guild_id: guild.id)
      FactoryGirl.create(:quest, guild_id: guild.id)
    end
    # association :guildmaster, factory: :guildmaster
  end

  factory :adventurer do
    hp { Faker::Number.number(4) }
    max_hp 9999
    energy { Faker::Number.number(3) }
    max_energy 999
    attack { Faker::Number.number(3) }
    defense { Faker::Number.number(3) }
    vision { Faker::Number.number(3) }
    state "available"
    guild_id 0
    name {Faker::Name.name}
  end

  factory :quest do
    difficulty { Faker::Number.between(1, 3) }
    state "available"
    reward { Faker::Number.number(3) }
    guild_id 0
    description {Faker::Name.name}
  end
end
