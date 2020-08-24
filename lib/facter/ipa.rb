require_relative 'util/ipa'
if defined? Facter::Util::Ipa
  # == Fact: foreman_ipa
  Facter.add(:foreman_ipa, :type => :aggregate) do
    {
      :default_realm => 'global/realm',
      :default_server => 'global/server',
    }.each do |key, path|
      chunk(key) do
        val = Facter::Util::Ipa.ipa_value(path)
        {key => val} if val
      end
    end
  end
end
