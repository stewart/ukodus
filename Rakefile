task :env do
  $LOAD_PATH.unshift 'lib'
  require 'sudoku'
  require 'reducer'
  require 'solver'
  require 'pry'
end

task :console => :env do
  Pry.start
end

task :solutions => :env do
  score = 0
  Sudoku.all.each do |sudoku|
    solution = Reducer.new(sudoku).reduce
    puts "\n\n"
    puts solution
    score += solution.score
  end
  puts "\n\nFINAL SCORE #{score}"
end

task default: :solutions
