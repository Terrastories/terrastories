namespace :db do
    desc 'Drop, create, migrate then seed the development database'
    task reset: [ 'db:drop', 'db:setup', 'db:seed' ] do
        puts 'Database has been reset'
    end
    desc "Truncate all tables"
    task empty: [ 'db:drop', 'db:setup' ] do
        puts 'Database has been reset and is completely empty'
    end
end

