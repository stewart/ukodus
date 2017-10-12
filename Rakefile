task :env do
  $LOAD_PATH.unshift 'lib'
  require 'sudoku'
  require 'reducer'
  require 'pry'
end

task :console => :env do
  Pry.start
end

task :solutions => :env do
end
