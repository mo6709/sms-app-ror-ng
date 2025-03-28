Mongoid.load!(Rails.root.join("config/mongoid.yml"))

Mongoid.raise_not_found_error = false
Mongoid.logger.level = Logger::INFO
Mongoid.create_indexes