# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert a data structure and output it as YAML while symbolizing keys
#
# In Foreman often YAML files have symbols as keys. Since it's hard to do that
# from Puppet, this function does it for you.
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
  # @return [String]
  dispatch :to_symbolized_yaml do
    param 'Any', :data
    optional_param 'Hash', :options
  end

  def to_symbolized_yaml(data, options = {})
    if data.is_a?(Hash)
      data = Hash[data.map { |k, v| [k.to_sym, v] }]
    end

    data.to_yaml(options)
  end
end
