Facter.add(:foreman_dynflow) do
  setcode do
    directory = '/etc/foreman/dynflow'
    extension = '.yml'

    if File.exist?(directory)
      Dir[File.join(directory, "*#{extension}")].map do |config|
        File.basename(config, extension)
      end
    else
      nil
    end
  end
end
