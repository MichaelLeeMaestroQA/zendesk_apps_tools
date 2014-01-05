module ZendeskAppsTools
  module Connection
    FULL_URL     = /https?:\/\//
    URL_TEMPLATE = 'https://%s.zendesk.com/'

    def prepare_api_auth
      @subdomain ||= get_cache('subdomain') || get_value_from_stdin('Enter your Zendesk subdomain or full Zendesk URL:')
      @username  ||= get_cache('username') || get_value_from_stdin('Enter your username:')

      unless @password
        print 'Enter your password: '
        @password ||= STDIN.noecho(&:gets).chomp
        puts

        set_cache 'subdomain' => @subdomain, 'username' => @username
      end
    end

    def get_full_url
      if FULL_URL =~ @subdomain
        @subdomain
      else
        URL_TEMPLATE % @subdomain
      end
    end

    def get_connection(encoding = :url_encoded)
      prepare_api_auth
      Faraday.new get_full_url do |f|
        f.request encoding
        f.adapter :net_http
        f.basic_auth @username, @password
      end
    end
  end
end
