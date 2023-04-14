require_relative './book'
require_relative './student'
require_relative './teacher'
require_relative './rental'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def options
    puts 'Please choose an option by enterin a number:'
    puts '1 - List all books'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given id'
    puts '7 - Exit'
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def options_validator(answer)
    case answer
    when 1
      list_books
    when 2
      list_people
    when 3
      create_person
    when 4
      create_book
    when 5
      create_rental
    when 6
      list_rentals
    when 7
      puts 'Thank you for using this app!'
    else
      puts '⛔ Invalid option!'
      puts ''
      run
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def run
    options
    answer = gets.chomp.to_i
    options_validator(answer)
  end

  def list_books
    if @books.empty?
      puts 'No books available 😓'
      puts ''
      run
    end
    @books.each do |book|
      puts "Title: #{book.title}, Author: #{book.author}"
    end
    puts ''
    run
  end

  def create_book
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp
    book = Book.new(title, author)
    @books << book
    puts 'Book created successfully ✔️'
    puts ''
    run
  end

  def list_people
    if @people.empty?
      puts 'No people available 😓'
      puts ''
      run
    end
    @people.each do |person|
      puts "[#{person.class.name}]  Name: #{person.name}, ID: #{person.id} Age: #{person.age}"
    end
    puts ''
    run
  end

  def create_person
    print 'Do you want to create a student (1) or a teacher (2)? [Input only the number]:'
    answer = gets.chomp.to_i
    if answer != 1 && answer != 2
      puts '⛔ Invalid input!'
      run
    end
    print 'Name:'
    name = gets.chomp
    print 'Age: '
    age = gets.chomp.to_i
    if answer == 1
      create_student(name, age)
    elsif answer == 2
      create_teacher(name, age)
    end
  end

  def create_student(name, age)
    student = Student.new(nil, age, name)
    @people << student
    puts 'Student created successfully ✔️'
    run
  end

  def create_teacher(name, age)
    teacher = Teacher.new(nil, age, name)
    @people << teacher
    puts 'Teacher created successfully ✔️'
    run
  end

  def create_rental
    if @books.empty? || @people.empty?
      puts 'No books or people created yet, create one!'
      run
    end
    puts 'Select a book from the following list by number:'
    @books.each_with_index do |book, index|
      puts "#{index}) Title: #{book.title}, Author: #{book.author}"
    end
    id_book = gets.chomp.to_i

    puts 'Select a person from the following list by number (not ID)'
    @people.each_with_index do |person, index|
      puts "#{index}) [#{person.class.name}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
    end
    id_person = gets.chomp.to_i

    print 'Date: '
    date = gets.chomp
    rental = Rental.new(date, @books[id_book], @people[id_person])
    @rentals << rental
    puts 'Rental created successfully ✔️'
    run
  end

  def list_rentals
    if @rentals.empty?
      puts 'No rentals available 😓'
      run
    end
    print 'ID of person: '
    id_person = gets.chomp.to_i
    puts 'Rentals: '
    rentals = @rentals.select { |rental| rental.person.id == id_person }
    if rentals.empty?
      puts 'No rentals available for this ID😓'
      run
    end
    rentals.each do |rental|
      puts "#{rental.date}, Book: #{rental.book.title} by #{rental.book.author}"
    end
    run
  end
end
