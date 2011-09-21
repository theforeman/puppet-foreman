class foreman {
  include foreman::params
  include foreman::install
  include foreman::config
  include foreman::service
}
