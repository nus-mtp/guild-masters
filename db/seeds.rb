# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

adminAcc = Account.create(email: "admin@example.com",
                          password: "admin",
                          email_confirmed: true,
                          is_admin: true)

acc = Account.create(email: "test@example.com",
                     password: "123456",
                     email_confirmed: true)

acc.initialize_guildmaster

gm = acc.guildmaster
gm.gold = 1000000
gm.save

g = gm.guilds[0]
g.popularity = 1000
g.save



AdventurerTemplate.create(max_hp: 1000,
	                      max_energy: 1000,
	                      attack: 100,
	                      defense: 100,
	                      vision: 100)

5.times do |i|
  MonsterTemplate.create(name: "monster#{i}",
                         max_hp: 1000,
                         max_energy: 100,
                         attack: 100,
                         defense: 100,
                         invisibility: 100)
end

# Insert a list of possible adventurer names
AdventurerName.create([
  {name: "Abel Tasman"},
  {name: "Adolf Erik Nordenskiöld"},
  {name: "Afonso de Albuquerque"},
  {name: "Alan Shepard"},
  {name: "ShepardAleksey Leonov"},
  {name: "Alexander von Humboldt"},
  {name: "Alexander MacKenzie"},
  {name: "Alexandra David-Néel"},
  {name: "Amelia Earhart"},
  {name: "Amerigo Vespucci"},
  {name: "Andrés de Urdaneta"},
  {name: "Antonio Pigafetta"},
  {name: "Aurel Stein"},
  {name: "Bartolomeu Dias"},
  {name: "Bill Tilman"},
  {name: "Cândido Rondon"},
  {name: "Charles Lindbergh"},
  {name: "Charles Sturt"},
  {name: "Cornelis de Houtman"},
  {name: "Cristoforo Columbo"},
  {name: "David Livingstone"},
  {name: "Davy Crockett"},
  {name: "Diego de Almagro"},
  {name: "Douglas Mawson"},
  {name: "Edmund Hillary"},
  {name: "Edwin \"Buzz\" Aldrin"},
  {name: "Erik the Red"},
  {name: "Ernest Shackleton"},
  {name: "Evliya Çelebi"},
  {name: "Ferdinand Konščak"},
  {name: "Ferdinand Magellan"},
  {name: "Fernão Mendes Pinto"},
  {name: "Francis Drake"},
  {name: "Francis Younghusband"},
  {name: "Francisco de Almeida"},
  {name: "Francisco de Orellana"},
  {name: "Francisco Pizarro"},
  {name: "Francisco Vázquez de Coronado"},
  {name: "Frederick Cook"},
  {name: "Fridtjof Nansen"},
  {name: "George Bass"},
  {name: "George Mallory"},
  {name: "George Vancouver"},
  {name: "Giovanni da Pian del Carpine"},
  {name: "Giovanni Caboto"},
  {name: "Giovanni da Verrazzano"},
  {name: "Hamilton Hume"},
  {name: "Hanno the Navigator"},
  {name: "Zheng He"},
  {name: "Henry the Navigator"},
  {name: "Henry Hudson"},
  {name: "Henry Morton Stanley"},
  {name: "Hernán Cortés"},
  {name: "Hernando de Soto"},
  {name: "Ignacije Szentmartony"},
  {name: "Ingólfur Arnarson"},
  {name: "Jacques Cartier"},
  {name: "Jacques Cousteau"},
  {name: "James Bruce"},
  {name: "James Cook"},
  {name: "James Augustus Grant"},
  {name: "James Clark Ross"},
  {name: "Jean François de Galaup"},
  {name: "John Franklin"},
  {name: "John Glenn"},
  {name: "John Ledyard"},
  {name: "John Oxley"},
  {name: "John Wesley Powell"},
  {name: "John Hanning Speke"},
  {name: "John Lloyd Stephens"},
  {name: "John McDouall Stuart"},
  {name: "Juan Sebastián Elcano"},
  {name: "Juan Ponce de León"},
  {name: "Leif Ericson"},
  {name: "Louis Antoine de Bougainville"},
  {name: "Louis Hennepin"},
  {name: "Marco Polo"},
  {name: "Matthew Flinders"},
  {name: "Meriwether Lewis"},
  {name: "Miguel López de Legazpi"},
  {name: "Abu Abdullah Muhammad ibn Battuta"},
  {name: "Mungo Park"},
  {name: "Neil Armstrong"},
  {name: "Niccolò de' Conti"},
  {name: "Pedro Álvares Cabral"},
  {name: "Pedro Fernandes de Queirós"},
  {name: "Pedro Sarmiento de Gamboa"},
  {name: "Pêro da Covilhã"},
  {name: "Peter Skene Ogden"},
  {name: "Peter Pond"},
  {name: "Pierre Savorgnan de Brazza"},
  {name: "Pytheas"},
  {name: "Zhang Qian"},
  {name: "Reinhold Messner"},
  {name: "René-Robert Cavelier de La Salle"},
  {name: "Richard Francis Burton"},
  {name: "Richard E. Byrd"},
  {name: "Roald Amundsen"},
  {name: "Robert Bartlett"},
  {name: "Robert Peary"},
  {name: "Robert Falcon Scott"},
  {name: "Ruy López de Villalobos"},
  {name: "Samuel Baker"},
  {name: "Samuel de Champlain"},
  {name: "Semyon Dezhnyov"},
  {name: "Sven Hedin"},
  {name: "Tenzing Norgay"},
  {name: "Teoberto Maler"},
  {name: "Thomas Mitchell"},
  {name: "Thor Heyerdahl"},
  {name: "Valentina Tereshkova"},
  {name: "Vasco Núñez de Balboa"},
  {name: "Vasco da Gama"},
  {name: "Vitus Bering"},
  {name: "Walter Raleigh"},
  {name: "Willem Barentsz"},
  {name: "Willem Janszoon"},
  {name: "William Baffin"},
  {name: "William Clark"},
  {name: "William Herndon"},
  {name: "William Hovell"},
  {name: "William Edward Parry"},
  {name: "William Grant Stairs"},
  {name: "Xuanzang"},
  {name: "Yermak Timofeyevich"},
  {name: "Yuriy Gagarin"},
  {name: "Zebulon Pik"}])