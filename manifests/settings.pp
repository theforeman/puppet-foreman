# @summary Configure settings in Foreman's database
# @api private
class foreman::settings (
  Optional[Enum['sendmail', 'smtp']] $email_delivery_method = $foreman::email_delivery_method,
  Optional[Stdlib::Host] $email_smtp_address = $foreman::email_smtp_address,
  Stdlib::Port $email_smtp_port = $foreman::email_smtp_port,
  Optional[Stdlib::Fqdn] $email_smtp_domain = $foreman::email_smtp_domain,
  Enum['none', 'plain', 'login', 'cram-md5'] $email_smtp_authentication = $foreman::email_smtp_authentication,
  Optional[String] $email_smtp_user_name = $foreman::email_smtp_user_name,
  Optional[String] $email_smtp_password = $foreman::email_smtp_password,
  Optional[String] $email_reply_address = $foreman::email_reply_address,
  Optional[String] $email_subject_prefix = $foreman::email_subject_prefix,
  Optional[Integer] $outofsync_interval = $foreman::outofsync_interval,
) {
  unless empty($email_delivery_method) {
    foreman_config_entry { 'delivery_method':
      value => $email_delivery_method,
    }

    foreman_config_entry { 'smtp_address':
      value => $email_smtp_address,
    }

    foreman_config_entry { 'smtp_port':
      value => $email_smtp_port,
    }

    foreman_config_entry { 'smtp_domain':
      value => $email_smtp_domain,
    }

    $real_email_smtp_authentication = $email_smtp_authentication ? {
      'none'  => '',
      default => $email_smtp_authentication,
    }
    foreman_config_entry { 'smtp_authentication':
      value => $real_email_smtp_authentication,
    }

    foreman_config_entry { 'smtp_user_name':
      value => $email_smtp_user_name,
    }

    foreman_config_entry { 'smtp_password':
      value => $email_smtp_password,
    }

    foreman_config_entry { 'email_reply_address':
      value => $email_reply_address,
    }

    foreman_config_entry { 'email_subject_prefix':
      value => $email_subject_prefix,
    }
  }
  unless empty($outofsync_interval) {
    foreman_config_entry { 'outofsync_interval':
      value => $outofsync_interval,
    }
  }
}
