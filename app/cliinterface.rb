require "pry"

class CommandLineInterface

  def valid_account
    puts "Please enter your name:".colorize(:color => :white, :background => :blue)
    name = gets.chomp.capitalize
  end

  def welcome(name)
    puts "Welcome to PeTinder, #{name}! Lets find your perfect partner! \nPlease enter your zipcode and we'll get started.".colorize(:color => :white, :background => :blue)
    zipcode = gets.chomp
  end

  def create_user(name, zipcode)
      current_user = User.find_or_create_by(userName: name, userZipCode: zipcode)
  end

  def get_animal_type(zipcode)
    puts "Thank you for input! Please enter the animal type you're interested in. \n(cat, dog, horse, reptile, rabbit, pig, or barnyard)".colorize(:color => :white, :background => :blue)
    animal_type = gets.chomp.downcase
    # if animalType != "cat" || "dog" || "horse" || "reptile" || "rabbit" || "pig" || "barnyard"
    #   puts "please enter a valid animal type"
    #   retry
    # end
  end

  def get_sex
    puts "What gender of animal would you prefer? Write 'M' for male or 'F' for female.".colorize(:color => :white, :background => :blue)
    animal_gender = gets.chomp.upcase
  end

  def get_size
    puts "What size animal are you interested in? Options are: 'S', 'M', 'L', or 'XL'.".colorize(:color => :white, :background => :blue)
    animal_size = gets.chomp.upcase
  end

  def availability_message_holder
    availability_messages = ["Waiting for you...", "All yours, baby.", "Will dance for food!", "Take me home!!!!", "Will not show up drunk to your house at 3AM crying, asking for you to let me in. Will probably show up crying asking for you to let me in.", "I'm a fun-loving animal with absolutely no interest in murder.", "If you can't offer me something, GTFO.", "This is snek.", "Free the nipple."]
    pet_availability = availability_messages.sample
  end

  def find_random_pet(animal_type, zipcode, animal_gender, animal_size)
    petfinder = Petfinder::Client.new('acc62e2c10e9df251207a7e3a13cd91f', '693cc2fba0334d6949234494055b09f1')
    options = {animal: animal_type, location: zipcode, sex: animal_gender, size: animal_size}
    new_pet = petfinder.random_pet(options)
  end

  def find_shelter_for_pet(new_pet)
    petfinder = Petfinder::Client.new('acc62e2c10e9df251207a7e3a13cd91f', '693cc2fba0334d6949234494055b09f1')
    searched_shelter = petfinder.shelter(new_pet.shelter_id)
  end

  def print_animal_info(new_pet, searched_shelter, pet_availability)
    puts "Our experts have found the perfect pet for you! Its information is below!".colorize(:color => :white, :background => :blue)
    puts "Name: #{new_pet.name}".colorize(:green)
    puts "Breed: #{new_pet.breeds.first}".colorize(:green)
    puts "Size: #{new_pet.size}".colorize(:green)
    puts "Sex: #{new_pet.sex}".colorize(:green)
    puts "Shelter: #{searched_shelter.name}".colorize(:green)
    puts "Availability: #{pet_availability}".colorize(:green)
    puts "Would you like to add this pet to your matches? 'Y' or 'N'".colorize(:color => :white, :background => :blue)
  end

  def create_pet(new_pet, animal_type, animal_gender, searched_shelter)
    puts "Added to your matches!".colorize(:color => :white, :background => :blue)
    animal = Pet.find_or_create_by(animalName: new_pet.name, animalType: animal_type, animalBreed: new_pet.breeds.first, animalGender: animal_gender, shelterName: searched_shelter.name)
  end

  def get_selections_from_user(animal, current_user)
    Selection.find_or_create_by(petId: animal.id, userId: current_user.id)
  end

  def get_match_response
    puts "Congratulations on matching with this animal! Type 'more' to see more animals or type 'matches' to see your matches!".colorize(:color => :white, :background => :blue)
  end

  def view_matches(current_user)
    all_matches = Selection.find_by_userId(current_user.id)
    petInfo = all_matches.collect do |matches|
      Pet.find_by_id(matches.petID)
    end
  end



end
