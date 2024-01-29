# # # run local sql files
# sql_files = Dir.glob('db/sql_files/*.sql')

# sql_files.each do |file|
#   queries = File.read(file).split(';')
#   queries.each do |query|
#     query.strip!
#     ActiveRecord::Base.connection.execute(query) unless query.empty?
#   end

#   puts "Executed #{file}"
# end
