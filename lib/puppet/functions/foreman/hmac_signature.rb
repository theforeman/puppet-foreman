Puppet::Functions.create_function(:'foreman::hmac_signature') do
  dispatch :sign do
    required_param 'String', :key
    required_param 'String', :value
    return_type 'String'
  end

  def sign(key, value)
    OpenSSL::HMAC.hexdigest('SHA512', key, value)
  end
end
