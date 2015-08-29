#
#  A wrapper around redis that namespaces keys with the current site id
#
require_dependency 'cache'
class EntrainRedis

  def self.raw_connection(config = nil)
    config ||= self.config
    Redis.new(url: config['url'])
  end

  def self.config
    @config ||= YAML.load(ERB.new(File.new("#{Rails.root}/config/redis.yml").read).result)[Rails.env]
  end

  def self.url(config=nil)
    config ||= self.config
    config['url']
  end

  def initialize(config=nil)
    @config = config || EntrainRedis.config
    @redis = EntrainRedis.raw_connection(@config)
  end

  def without_namespace
    # Only use this if you want to store and fetch data that's shared between sites
    @redis
  end

  def url
    self.class.url(@config)
  end

  def self.ignore_readonly
    yield
  rescue Redis::CommandError => ex
    if ex.message =~ /READONLY/
      unless Entrain.recently_readonly?
        STDERR.puts "WARN: Redis is in a readonly state. Performed a noop"
      end
      Entrain.received_readonly!
    else
      raise ex
    end
  end

  # prefix the key with the namespace
  def method_missing(meth, *args, &block)
    if @redis.respond_to?(meth)
      EntrainRedis.ignore_readonly { @redis.send(meth, *args, &block) }
    else
      super
    end
  end

  # Proxy key methods through, but prefix the keys with the namespace
  [:append, :blpop, :brpop, :brpoplpush, :decr, :decrby, :exists, :expire, :expireat, :get, :getbit, :getrange, :getset,
   :hdel, :hexists, :hget, :hgetall, :hincrby, :hincrbyfloat, :hkeys, :hlen, :hmget, :hmset, :hset, :hsetnx, :hvals, :incr,
   :incrby, :incrbyfloat, :lindex, :linsert, :llen, :lpop, :lpush, :lpushx, :lrange, :lrem, :lset, :ltrim,
   :mapped_hmset, :mapped_hmget, :mapped_mget, :mapped_mset, :mapped_msetnx, :mget, :move, :mset,
   :msetnx, :persist, :pexpire, :pexpireat, :psetex, :pttl, :rename, :renamenx, :rpop, :rpoplpush, :rpush, :rpushx, :sadd, :scard,
   :sdiff, :set, :setbit, :setex, :setnx, :setrange, :sinter, :sismember, :smembers, :sort, :spop, :srandmember, :srem, :strlen,
   :sunion, :ttl, :type, :watch, :zadd, :zcard, :zcount, :zincrby, :zrange, :zrangebyscore, :zrank, :zrem, :zremrangebyrank,
   :zremrangebyscore, :zrevrange, :zrevrangebyscore, :zrevrank, :zrangebyscore].each do |m|
    define_method m do |*args|
      args[0] = "#{namespace}:#{args[0]}"
      EntrainRedis.ignore_readonly { @redis.send(m, *args) }
    end
  end

  def del(k)
    EntrainRedis.ignore_readonly do
      k = "#{namespace}:#{k}"
      @redis.del k
    end
  end

  def keys(pattern=nil)
    EntrainRedis.ignore_readonly do
      len = namespace.length + 1
      @redis.keys("#{namespace}:#{pattern || '*'}").map{
        |k| k[len..-1]
      }
    end
  end

  def delete_prefixed(prefix)
    EntrainRedis.ignore_readonly do
      keys("#{prefix}*").each { |k| $redis.del(k) }
    end
  end

  def flushdb
    EntrainRedis.ignore_readonly do
      keys.each{|k| del(k)}
    end
  end

  def reconnect
    @redis.client.reconnect
  end

  def namespace
    "entrain"
  end

  def self.new_redis_store
    Cache.new
  end

end
