module PuppetX
  module Foreman
    module Common

      # Parameters common to several types that use the rest_v3 api provider
      REST_API_COMMON_PARAMS = Proc.new do
        ensurable

        newparam(:base_url) do
          desc 'Foreman\'s base url.'
        end

        newparam(:effective_user) do
          desc 'Foreman\'s effective user for the registration (usually admin).'
        end

        newparam(:consumer_key) do
          desc 'Foreman oauth consumer_key'
        end

        newparam(:consumer_secret) do
          desc 'Foreman oauth consumer_secret'
        end

        newparam(:ssl_ca) do
          desc 'Foreman SSL CA (certificate authority) for verification'
        end

        newparam(:timeout) do
          desc "Timeout for HTTP(s) requests"

          munge do |value|
            value = value.shift if value.is_a?(Array)
            begin
              value = Integer(value)
            rescue ArgumentError
              raise ArgumentError, "The timeout must be a number.", $!.backtrace
            end
            [value, 0].max
          end

          defaultto 500
        end

        autorequire(:anchor) do
          ['foreman::service','foreman::providers::oauth']
        end
      end

      FOREMAN_HOST_PARAMS = Proc.new do
        newparam(:name, :namevar => true) do
          desc 'The name of the resource.'
        end

        newparam(:hostname) do
          desc 'The name of the host.'
        end
      end
    end
  end
end
