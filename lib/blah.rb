require 'rubygems'
    require 'nokogiri'
    require 'open-uri'

    user_agent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"

    url = "http://www.somedomain.com/somepage/"

    @doc = Nokogiri::HTML(open(url, 'proxy' => 'http://(ip_address):(port)', 'User-Agent' => user_agent, 'read_timeout' => 10 ), nil, "UTF-8")
