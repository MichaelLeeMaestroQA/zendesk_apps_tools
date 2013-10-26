require 'faraday'

module ZendeskAppsTools
  module Common
    def api_request(url, request = Faraday.new)
      request.get(url)
    end

    def get_value_from_stdin(prompt, opts = {})
      options = {
        :valid_regex => opts[:allow_empty] ? /^.*$/ : /\S+/,
        :error_msg => 'Invalid, try again:',
        :allow_empty => false
      }.merge(opts)

      while input = ask(prompt)
        return "" if input.empty? && options[:allow_empty]
        unless input =~ options[:valid_regex]
          say(options[:error_msg], :red)
        else
          break
        end
      end

      return input
    end
  end
end
