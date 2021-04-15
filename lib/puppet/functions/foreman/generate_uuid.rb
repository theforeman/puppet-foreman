Puppet::Functions.create_function(:'foreman::generate_uuid') do
  dispatch :uuid do
    return_type 'String'
  end

  def uuid
    SecureRandom.uuid
  end
end
