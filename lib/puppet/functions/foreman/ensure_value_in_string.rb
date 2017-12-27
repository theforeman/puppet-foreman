# Returns an string with appended values to the end if they were not present in original string.
#     Prototype:
#       ensure_value_in_string(string, array, separator = ',')
# Where string is the original string, array is array of additional values to append,
# separator is optional specifying delimiter and defaults to a comma.
#     For example:
# Given the following statements:
#       ensure_value_in_string('one,two', ['two', 'three'])
# The result will be as follows:
#       'one,two,three'
# You can specify you own separator as a third argument
#       ensure_value_in_string('one,two', ['two', 'three'], ', ')
# results in
#       'one,two, three'
Puppet::Functions.create_function(:'foreman::ensure_value_in_string') do
  dispatch :ensure_value_in_string do
    required_param 'String', :string
    required_param 'Array', :adding
    optional_param 'String', :separator
  end

  def ensure_value_in_string(string, adding, separator = ',')
    existing = string.split(separator.strip).map(&:strip)
    to_add = adding - existing

    ([ string.empty? ? nil : string ] + to_add).compact.join(separator)
  end
end
