require 'cgi'
require 'httparty'

module KatSearch
  ##
  # Object that contains the info for a torrent file
  class Link
    @@max_length_name ||= 0

    attr_reader :seeders, :leechers, :download_url

    def initialize(params)
      @params = params
      @seeders = params['seeders']
      @leechers = params['leechers']
      @download_url = params['download_url']

      # Get the longest filename for pretty print
      set_max_length_name(filename.length)
    end

    def to_s
      "#{filename.ljust(@@max_length_name + 2)} (#{@seeders.green}/#{@leechers.red})"
    end

    def filename
      @filename ||= "#{CGI.unescape(@params['name'])}.#{@params['extension']}"
    end

    def magnet
      @magnet ||= @params['magnet']
    end

    def info_hash
      @info_hash ||= extract_hash
    end

    def download(path = './')
      response = HTTParty.get(@download_url)

      raise 'Wrong content-type. Aborting.' unless response.headers['content-type'].include? 'application/x-bittorrent'

      # Get file name from the url
      filename = @download_url[/\?title=(.+)/, 1] + '.torrent'
      open(File.join(path, filename), 'w') { |f| f << response }

      # return filename
      filename
    end

    private

    def extract_hash
      # Extract magnet properties to a Hash and then parse the sha1 info hash
      raw_hash = magnet[/(xt.*?)&/, 1]  # extract the xt property
      raw_hash.split(':').last.downcase
    end

    def set_max_length_name(length)
      @@max_length_name = length if @@max_length_name < length
    end
  end
end
