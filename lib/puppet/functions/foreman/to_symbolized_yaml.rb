# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert a data structure and output it as YAML while symbolizing keys
#
# In Foreman often YAML files have symbols as keys. Since it's hard to do that
# from Puppet, this function does it for you.
# If the Input contains any sensitive Data, the returned YAML-String
# will be also of Datatype Sensitive.
#
# @example How to output YAML
#   # output yaml to a file
#     file { '/tmp/my.yaml':
#       ensure  => file,
#       content => foreman::to_symbolized_yaml($myhash),
#     }
# @example Use options control the output format
#   file { '/tmp/my.yaml':
#     ensure  => file,
#     content => foreman::to_symbolized_yaml($myhash, {indentation: 4})
#   }
Puppet::Functions.create_function(:'foreman::to_symbolized_yaml') do
  # @param data
  # @param options
  #
  # @return [Variant[String, Sensitive[String]]]
  dispatch :to_symbolized_yaml do
    param 'Any', :data
    optional_param 'Hash', :options
  end

  def to_symbolized_yaml(data, options = {})
    return_sensitive = false
    if data.respond_to?(:unwrap)
      data = data.unwrap
      return_sensitive = true
    end
    if data.is_a?(Hash)
      data = data.map do |k, v|
        if v.respond_to?(:unwrap)
          v = v.unwrap
          return_sensitive = true
        end
        [k.to_sym, v]
      end.to_h
    end

    if return_sensitive
      Puppet::Pops::Types::PSensitiveType::Sensitive.new(data.to_yaml(options))
    else
      data.to_yaml(options)
    end
  end
end
