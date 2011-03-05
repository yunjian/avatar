require 'avatar/object_support'
require 'avatar/source/abstract_source'
require 'twitter'

module Avatar # :nodoc:
  module Source # :nodoc:
    # Source for a user's Twitter profile image
    # See http://rdoc.info/gems/twitter/1.1.2/Twitter/Client/User#profile_image-instance_method
    class TwitterSource
      include AbstractSource
    
      attr_accessor :default_field
      
      # Create a new TwitterSource with a +default_field+ (by default, :twitter_name),
      def initialize(default_field = :twitter_name)
        @default_field = default_field
      end
    
      # Returns a URL for a twitter user
      # <code>person.<twitter_field>.url</code>
      # Returns nil under any of the following circumstances:
      # * person is nil
      # * person.<twitter_field> is nil
      # * person.<twitter_field> is not a valid twitter screen name
      # Options:
      # * <code>:twitter_field</code> - the twitter_name column within +person+; by default, self.default_field
      def avatar_url_for(person, options = {})
        return nil if person.nil?
        options = parse_options(person, options)
        field = options[:twitter_field]
        return nil if field.nil?
        twitter_name = person.send(field)
        return nil if twitter_name.nil?
        Twitter.profile_image(twitter_name, :size => options[:size])
      end
    
      # Copies :twitter_field from +options+, adding defaults if necessary.
      def parse_options(person, options)
        returning({}) do |result|
          result[:twitter_field] = options[:twitter_field] || default_field
          result[:size] = 'normal'
          result[:size] = 'bigger' if options[:size] == :big || options[:size] == :medium
        end
      end
      
    end
  end
end