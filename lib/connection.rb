require 'mongo'

class Connection
  
  def initialize

    # set logger level to FATAL (only show serious errors)
    Mongo::Logger.logger.level = ::Logger::FATAL

    # set up a connection to the mongod instance which is running locally,
    # on the default port 27017
    @client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')

  end

  def client
    @client
  end

  # get connections to our two collections
  def restaurants
    @client[:restaurants]
  end
  
  def neighborhoods
    @client[:neighborhoods]
  end
  
end