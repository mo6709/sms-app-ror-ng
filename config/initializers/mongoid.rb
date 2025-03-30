Mongoid.load!(Rails.root.join("config/mongoid.yml"))

Rails.logger.info "=== Momgoid initializer runing ==="
STDOUT.puts "=== Momgoid initializer runing ==="

Mongoid.raise_not_found_error = false
Mongoid.logger.level = Logger::INFO
Mongoid::Tasks::Database.create_indexes