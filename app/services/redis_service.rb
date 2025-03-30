# app/services/redis_service.rb
class RedisService
    class << self
      # Get Redis connection (with connection pooling)
      def redis
        @redis_pool ||= ConnectionPool.new(size: 5, timeout: 5) do
          Redis.new(url: ENV['REDIS_URL'])
        end
      end
      
      # REDIS USE CASE #1: Caching
      # Cache expensive database queries
      def cached_active_users_count(force_refresh = false)
        cache_key = "active_users_count"
        
        # Delete cached value if forcing refresh
        redis.with { |conn| conn.del(cache_key) } if force_refresh
        
        # Try to get from cache first
        redis.with do |conn|
          # Return cached value if exists
          cached = conn.get(cache_key)
          return JSON.parse(cached) if cached
          
          # Calculate value if not in cache
          count = User.where(status: 'active').count
          
          # Cache for 10 minutes (600 seconds)
          conn.setex(cache_key, 600, count.to_json)
          return count
        end
      end
      
      # REDIS USE CASE #2: Rate limiting
      def rate_limit_sms(user_id, limit = 10, period = 3600)
        key = "rate_limit:sms:#{user_id}"
        
        redis.with do |conn|
          # Get current count
          current = conn.get(key).to_i
          
          # If key doesn't exist, set it with expiration
          if current == 0
            conn.setex(key, period, 1)
            return true
          end
          
          # If under limit, increment
          if current < limit
            conn.incr(key)
            return true
          end
          
          # Rate limit exceeded
          return false
        end
      end
      
      # REDIS USE CASE #3: Pub/Sub (enhanced from your existing system)
      def publish_message(channel, payload)
        message = payload.merge(timestamp: Time.current.to_i)
        redis.with { |conn| conn.publish(channel, message.to_json) }
      end
      
      # REDIS USE CASE #4: Job queue (Sidekiq uses Redis internally)
      def enqueue_job(user_id)
        SmsDeliveryWorker.perform_async(user_id)
      end
      
      # REDIS USE CASE #5: Session store
      def store_session_data(session_id, data, expiry = 1.day)
        redis.with do |conn|
          conn.setex("session:#{session_id}", expiry.to_i, data.to_json)
        end
      end
      
      def get_session_data(session_id)
        redis.with do |conn|
          data = conn.get("session:#{session_id}")
          data ? JSON.parse(data) : nil
        end
      end
      
      # REDIS USE CASE #6: Distributed locking
      def with_lock(lock_name, timeout = 10)
        lock_key = "lock:#{lock_name}"
        # Generate a unique token for this lock
        token = SecureRandom.hex(16)
        
        redis.with do |conn|
          # Try to acquire lock
          acquired = conn.set(lock_key, token, nx: true, ex: timeout)
          
          if acquired
            begin
              # Execute the block that needs locking
              yield
            ensure
              # Release the lock if we still own it
              # Using Lua script to ensure atomicity
              conn.eval(
                "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end",
                keys: [lock_key], argv: [token]
              )
            end
          else
            raise "Could not acquire lock: #{lock_name}"
          end
        end
      end
    end
  end