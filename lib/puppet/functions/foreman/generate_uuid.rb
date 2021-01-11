Puppet::Functions.create_function(:'foreman::generate_uuid') do
  dispatch :uuid do
    # no arguments
  end

  def uuid
    SecureRandom.uuid
  end
end
