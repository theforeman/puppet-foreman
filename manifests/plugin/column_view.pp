# @summary Install the column view plugin and optionally manage the configuration file
#
# @param columns
#   an hash of columns to add to the configuration
#
class foreman::plugin::column_view (
  Hash[String, Hash] $columns = {},
){
  # https://projects.theforeman.org/issues/21398
  assert_type(Hash[String, Foreman::Column_view_column], $columns)

  foreman::plugin { 'column_view':
    config => template('foreman/foreman_column_view.yaml.erb'),
  }
}
