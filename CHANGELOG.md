# Changelog

## [24.2.0](https://github.com/theforeman/puppet-foreman/tree/24.2.0) (2024-02-19)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/24.1.0...24.2.0)

**Implemented enhancements:**

- Mark compatible with puppet/redis 10.x [\#1153](https://github.com/theforeman/puppet-foreman/pull/1153) ([ekohl](https://github.com/ekohl))
- Support EL9 [\#1152](https://github.com/theforeman/puppet-foreman/pull/1152) ([ekohl](https://github.com/ekohl))
- Add hiera data manager \(HDM\) plugin [\#1149](https://github.com/theforeman/puppet-foreman/pull/1149) ([tuxmea](https://github.com/tuxmea))
- Only install dnf module on EL8 [\#1147](https://github.com/theforeman/puppet-foreman/pull/1147) ([ekohl](https://github.com/ekohl))

## [24.1.0](https://github.com/theforeman/puppet-foreman/tree/24.1.0) (2023-11-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/24.0.0...24.1.0)

**Implemented enhancements:**

- Add hammer-cli-foreman-rh-cloud package [\#1145](https://github.com/theforeman/puppet-foreman/pull/1145) ([ShimShtein](https://github.com/ShimShtein))

## [24.0.0](https://github.com/theforeman/puppet-foreman/tree/24.0.0) (2023-11-14)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/23.2.0...24.0.0)

**Breaking changes:**

- Drop deprecated non-namespaced functions [\#1141](https://github.com/theforeman/puppet-foreman/pull/1141) ([ekohl](https://github.com/ekohl))
- Fixes [\#36801](https://projects.theforeman.org/issues/36801): Make Redis the default cache type [\#1134](https://github.com/theforeman/puppet-foreman/pull/1134) ([ehelms](https://github.com/ehelms))
- require puppetlabs/stdlib 9.x  [\#1125](https://github.com/theforeman/puppet-foreman/pull/1125) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Mark compatible with puppetlabs/postgresql 10.x [\#1143](https://github.com/theforeman/puppet-foreman/pull/1143) ([ekohl](https://github.com/ekohl))
- Use JSON to parse Foreman API responses [\#1142](https://github.com/theforeman/puppet-foreman/pull/1142) ([ekohl](https://github.com/ekohl))
- Include settings header via concat [\#1140](https://github.com/theforeman/puppet-foreman/pull/1140) ([ekohl](https://github.com/ekohl))
- Add Puppet 8 support [\#1139](https://github.com/theforeman/puppet-foreman/pull/1139) ([ekohl](https://github.com/ekohl))
- Mark compatible with puppet-extlib 7.x [\#1138](https://github.com/theforeman/puppet-foreman/pull/1138) ([ekohl](https://github.com/ekohl))
- Fixes [\#36090](https://projects.theforeman.org/issues/36090) - Support REX cockpit removal [\#1111](https://github.com/theforeman/puppet-foreman/pull/1111) ([ekohl](https://github.com/ekohl))

## [23.2.0](https://github.com/theforeman/puppet-foreman/tree/23.2.0) (2023-10-10)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/23.1.0...23.2.0)

**Implemented enhancements:**

- Fixes [\#36812](https://projects.theforeman.org/issues/36812) - allow setting \(fc\)ct\_location [\#1135](https://github.com/theforeman/puppet-foreman/pull/1135) ([evgeni](https://github.com/evgeni))
- Mark compatible with puppetlabs/apache 11.x [\#1131](https://github.com/theforeman/puppet-foreman/pull/1131) ([ekohl](https://github.com/ekohl))
- Allow puppet/systemd 5.x and 6.x [\#1129](https://github.com/theforeman/puppet-foreman/pull/1129) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- correct sendmail configuration [\#1130](https://github.com/theforeman/puppet-foreman/pull/1130) ([evgeni](https://github.com/evgeni))

## [23.1.0](https://github.com/theforeman/puppet-foreman/tree/23.1.0) (2023-08-16)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/23.0.0...23.1.0)

**Implemented enhancements:**

- Fixes [\#36582](https://projects.theforeman.org/issues/36582) - Detect logging layout based on type [\#1124](https://github.com/theforeman/puppet-foreman/pull/1124) ([ekohl](https://github.com/ekohl))
- Fixes [\#36645](https://projects.theforeman.org/issues/36645) - Change the default Redis cache DB to 4 [\#1122](https://github.com/theforeman/puppet-foreman/pull/1122) ([ekohl](https://github.com/ekohl))
- allow puppet/redis 9.x [\#1121](https://github.com/theforeman/puppet-foreman/pull/1121) ([evgeni](https://github.com/evgeni))

## [23.0.0](https://github.com/theforeman/puppet-foreman/tree/23.0.0) (2023-05-16)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/22.2.0...23.0.0)

**Breaking changes:**

- Sunsetting foreman\_column\_view because functionality being integrated in Foreman itself [\#1119](https://github.com/theforeman/puppet-foreman/pull/1119) ([dgoetz](https://github.com/dgoetz))
- Refs [\#36345](https://projects.theforeman.org/issues/36345) - Raise minimum Puppet version to 7.0.0 [\#1118](https://github.com/theforeman/puppet-foreman/pull/1118) ([ekohl](https://github.com/ekohl))
- drop memcache plugin support [\#1114](https://github.com/theforeman/puppet-foreman/pull/1114) ([evgeni](https://github.com/evgeni))
- Remove Docker, Spacewalk & DigitalOcean plugins [\#1097](https://github.com/theforeman/puppet-foreman/pull/1097) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Mark compatible with puppetlabs/concat 8.x & puppetlabs/apache 10.x & puppetlabs/postgresql 9.x [\#1117](https://github.com/theforeman/puppet-foreman/pull/1117) ([ekohl](https://github.com/ekohl))
- Refs [\#36319](https://projects.theforeman.org/issues/36319) - Add fog\_proxmox plugin support [\#1115](https://github.com/theforeman/puppet-foreman/pull/1115) ([maximiliankolb](https://github.com/maximiliankolb))
- Bump puppetlabs/apache to \< 10.0.0 [\#1110](https://github.com/theforeman/puppet-foreman/pull/1110) ([gcoxmoz](https://github.com/gcoxmoz))

## [22.2.0](https://github.com/theforeman/puppet-foreman/tree/22.2.0) (2023-02-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/22.1.2...22.2.0)

**Implemented enhancements:**

- Fixes [\#36037](https://projects.theforeman.org/issues/36037) - Manage Redis service for Redis cache [\#1109](https://github.com/theforeman/puppet-foreman/pull/1109) ([ekohl](https://github.com/ekohl))
- Add basic external auth for API [\#1108](https://github.com/theforeman/puppet-foreman/pull/1108) ([ofedoren](https://github.com/ofedoren))
- bump puppet/systemd to \< 5.0.0 [\#1104](https://github.com/theforeman/puppet-foreman/pull/1104) ([jhoblitt](https://github.com/jhoblitt))

## [22.1.2](https://github.com/theforeman/puppet-foreman/tree/22.1.2) (2023-02-01)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/22.1.1...22.1.2)

**Fixed bugs:**

- Fixes [\#36028](https://projects.theforeman.org/issues/36028) - ensure compressed assets are returned if available [\#1106](https://github.com/theforeman/puppet-foreman/pull/1106) ([evgeni](https://github.com/evgeni))

## [22.1.1](https://github.com/theforeman/puppet-foreman/tree/22.1.1) (2023-01-26)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/22.1.0...22.1.1)

**Fixed bugs:**

- Fixes [\#35870](https://projects.theforeman.org/issues/35870) - Ensure mod\_expires is loaded [\#1101](https://github.com/theforeman/puppet-foreman/pull/1101) ([ekohl](https://github.com/ekohl))

## [22.1.0](https://github.com/theforeman/puppet-foreman/tree/22.1.0) (2022-12-14)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/22.0.0...22.1.0)

**Implemented enhancements:**

- Refs [\#35800](https://projects.theforeman.org/issues/35800) - Add foreman\_kernel\_care plugin support [\#1099](https://github.com/theforeman/puppet-foreman/pull/1099) ([ekohl](https://github.com/ekohl))

## [22.0.0](https://github.com/theforeman/puppet-foreman/tree/22.0.0) (2022-11-03)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/21.2.0...22.0.0)

**Breaking changes:**

- drop abrt and chef plugins [\#1094](https://github.com/theforeman/puppet-foreman/pull/1094) ([evgeni](https://github.com/evgeni))
- drop support for host\_reports, the plugin was dropped [\#1081](https://github.com/theforeman/puppet-foreman/pull/1081) ([evgeni](https://github.com/evgeni))
- Drop /pulp2 and /streamer from no\_proxy\_uris [\#1080](https://github.com/theforeman/puppet-foreman/pull/1080) ([evgeni](https://github.com/evgeni))
- Fixes [\#33956](https://projects.theforeman.org/issues/33956) - serve static assets directly via Apache [\#1078](https://github.com/theforeman/puppet-foreman/pull/1078) ([evgeni](https://github.com/evgeni))

**Implemented enhancements:**

- Refs [\#35414](https://projects.theforeman.org/issues/35414) - Expect a different message in journal [\#1096](https://github.com/theforeman/puppet-foreman/pull/1096) ([ekohl](https://github.com/ekohl))
- Fixes [\#35685](https://projects.theforeman.org/issues/35685) - allow setting GssapiLocalName to Off [\#1093](https://github.com/theforeman/puppet-foreman/pull/1093) ([evgeni](https://github.com/evgeni))
- Refs [\#35675](https://projects.theforeman.org/issues/35675) - Add hammer-cli-foreman-google plugin [\#1090](https://github.com/theforeman/puppet-foreman/pull/1090) ([ofedoren](https://github.com/ofedoren))
- Allow sensitive type for plugin configuration [\#1088](https://github.com/theforeman/puppet-foreman/pull/1088) ([kobybr](https://github.com/kobybr))
- Fixes [\#35524](https://projects.theforeman.org/issues/35524) - Require puppetlabs-apache 8.x [\#1086](https://github.com/theforeman/puppet-foreman/pull/1086) ([ekohl](https://github.com/ekohl))
- Refs [\#33956](https://projects.theforeman.org/issues/33956) - make it easier to toggle asset proxying [\#1085](https://github.com/theforeman/puppet-foreman/pull/1085) ([evgeni](https://github.com/evgeni))
- Refs [\#35473](https://projects.theforeman.org/issues/35473) - Configure Apache for API extlogin [\#1083](https://github.com/theforeman/puppet-foreman/pull/1083) ([ofedoren](https://github.com/ofedoren))

**Fixed bugs:**

- Convert per\_page in foreman::foreman to string [\#1089](https://github.com/theforeman/puppet-foreman/pull/1089) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Puppet-lint fixes [\#1092](https://github.com/theforeman/puppet-foreman/pull/1092) ([ekohl](https://github.com/ekohl))

## [21.2.0](https://github.com/theforeman/puppet-foreman/tree/21.2.0) (2022-09-20)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/21.1.0...21.2.0)

**Implemented enhancements:**

- puppetlabs/apt: Allow 9.x [\#1082](https://github.com/theforeman/puppet-foreman/pull/1082) ([bastelfreak](https://github.com/bastelfreak))

## [21.1.0](https://github.com/theforeman/puppet-foreman/tree/21.1.0) (2022-08-26)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/21.0.0...21.1.0)

**Implemented enhancements:**

- Add hammer plugin for ssh [\#1076](https://github.com/theforeman/puppet-foreman/pull/1076) ([dgoetz](https://github.com/dgoetz))
- Allow puppetlabs/apache 8.x [\#1075](https://github.com/theforeman/puppet-foreman/pull/1075) ([ekohl](https://github.com/ekohl))
- Fixes [\#35356](https://projects.theforeman.org/issues/35356) - Don't proxy /server-status [\#1074](https://github.com/theforeman/puppet-foreman/pull/1074) ([ekohl](https://github.com/ekohl))

## [21.0.0](https://github.com/theforeman/puppet-foreman/tree/21.0.0) (2022-08-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/20.2.0...21.0.0)

**Breaking changes:**

- remove support for Debian 10 buster [\#1068](https://github.com/theforeman/puppet-foreman/pull/1068) ([evgeni](https://github.com/evgeni))
- Stop accepting UNSET as a value and rewrite db.yml to EPP [\#1066](https://github.com/theforeman/puppet-foreman/pull/1066) ([ekohl](https://github.com/ekohl))
- Drop EL7 support [\#1061](https://github.com/theforeman/puppet-foreman/pull/1061) ([ehelms](https://github.com/ehelms))
- Fixes [\#34977](https://projects.theforeman.org/issues/34977): Drop apipie\_dsl:cache generation [\#1056](https://github.com/theforeman/puppet-foreman/pull/1056) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Use Integer type for vhost ssl\_verify\_depth [\#1071](https://github.com/theforeman/puppet-foreman/pull/1071) ([wbclark](https://github.com/wbclark))
- Update to voxpupuli-test 5 [\#1063](https://github.com/theforeman/puppet-foreman/pull/1063) ([ekohl](https://github.com/ekohl))
- Add foreman plugin for netbox [\#1060](https://github.com/theforeman/puppet-foreman/pull/1060) ([dgoetz](https://github.com/dgoetz))
- Add foreman plugin for git\_templates [\#1059](https://github.com/theforeman/puppet-foreman/pull/1059) ([dgoetz](https://github.com/dgoetz))
- Add foreman plugin for vault [\#1058](https://github.com/theforeman/puppet-foreman/pull/1058) ([dgoetz](https://github.com/dgoetz))
- Add foreman plugin for scc\_manager [\#1057](https://github.com/theforeman/puppet-foreman/pull/1057) ([dgoetz](https://github.com/dgoetz))
- Replace template with to\_symbolized\_yaml function [\#1017](https://github.com/theforeman/puppet-foreman/pull/1017) ([ekohl](https://github.com/ekohl))
- Move static parameters to init.pp [\#978](https://github.com/theforeman/puppet-foreman/pull/978) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Fixes [\#35089](https://projects.theforeman.org/issues/35089) - set NoDelay=false when deploying a UNIX socket [\#1062](https://github.com/theforeman/puppet-foreman/pull/1062) ([evgeni](https://github.com/evgeni))

## [20.2.0](https://github.com/theforeman/puppet-foreman/tree/20.2.0) (2022-06-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/20.1.0...20.2.0)

**Implemented enhancements:**

- add foreman\_global\_parameter type [\#1054](https://github.com/theforeman/puppet-foreman/pull/1054) ([jhoblitt](https://github.com/jhoblitt))
- derive base\_url from foreman-proxy/settings.yml by default [\#1053](https://github.com/theforeman/puppet-foreman/pull/1053) ([jhoblitt](https://github.com/jhoblitt))

## [20.1.0](https://github.com/theforeman/puppet-foreman/tree/20.1.0) (2022-05-24)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/20.0.0...20.1.0)

**Implemented enhancements:**

- use instance debug instead of Puppet.debug [\#1052](https://github.com/theforeman/puppet-foreman/pull/1052) ([jhoblitt](https://github.com/jhoblitt))
- Fixes [\#34943](https://projects.theforeman.org/issues/34943): Allow configuration of additional cockpit origins [\#1051](https://github.com/theforeman/puppet-foreman/pull/1051) ([ehelms](https://github.com/ehelms))
- Fixes [\#34602](https://projects.theforeman.org/issues/34602) - restart services after plugin installation [\#1046](https://github.com/theforeman/puppet-foreman/pull/1046) ([evgeni](https://github.com/evgeni))

## [20.0.0](https://github.com/theforeman/puppet-foreman/tree/20.0.0) (2022-04-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/19.3.0...20.0.0)

**Breaking changes:**

- Fixes [\#34640](https://projects.theforeman.org/issues/34640) - Drop apipie:cache:index [\#1042](https://github.com/theforeman/puppet-foreman/pull/1042) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Add Foreman Google plugin [\#1040](https://github.com/theforeman/puppet-foreman/pull/1040) ([stejskalleos](https://github.com/stejskalleos))

**Fixed bugs:**

- Fixes [\#34824](https://projects.theforeman.org/issues/34824) - properly restart foreman when puma config changed [\#1045](https://github.com/theforeman/puppet-foreman/pull/1045) ([evgeni](https://github.com/evgeni))

## [19.3.0](https://github.com/theforeman/puppet-foreman/tree/19.3.0) (2022-04-08)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/19.2.1...19.3.0)

**Implemented enhancements:**

- Include apache::mod::env [\#1038](https://github.com/theforeman/puppet-foreman/pull/1038) ([wbclark](https://github.com/wbclark))
- Allow puppetlabs/postgresql 8.x [\#1031](https://github.com/theforeman/puppet-foreman/pull/1031) ([ekohl](https://github.com/ekohl))
- Refs [\#34505](https://projects.theforeman.org/issues/34505) - Add hammer plugin for foreman\_host\_reports [\#1030](https://github.com/theforeman/puppet-foreman/pull/1030) ([ofedoren](https://github.com/ofedoren))

**Fixed bugs:**

- metadata.json: Use https URL to git repo [\#1036](https://github.com/theforeman/puppet-foreman/pull/1036) ([bastelfreak](https://github.com/bastelfreak))
- Use the new GPG key for Debian packages [\#1034](https://github.com/theforeman/puppet-foreman/pull/1034) ([ekohl](https://github.com/ekohl))

## [19.2.1](https://github.com/theforeman/puppet-foreman/tree/19.2.1) (2022-02-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/19.2.0...19.2.1)

**Fixed bugs:**

- Refs [\#34394](https://projects.theforeman.org/issues/34394) - trigger dynflow restart when DB restarts [\#1028](https://github.com/theforeman/puppet-foreman/pull/1028) ([evgeni](https://github.com/evgeni))

## [19.2.0](https://github.com/theforeman/puppet-foreman/tree/19.2.0) (2022-02-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/19.1.1...19.2.0)

**Implemented enhancements:**

- puppet/extlib: Allow 6.x [\#1027](https://github.com/theforeman/puppet-foreman/pull/1027) ([bastelfreak](https://github.com/bastelfreak))
- Reflect Foreman 3.2+ support for Debian 11 [\#1025](https://github.com/theforeman/puppet-foreman/pull/1025) ([ekohl](https://github.com/ekohl))
- Explicitly enable the foreman dnf module on Foreman 3.2+ [\#1023](https://github.com/theforeman/puppet-foreman/pull/1023) ([evgeni](https://github.com/evgeni))
- Introduce foreman::settings\_fragment [\#1016](https://github.com/theforeman/puppet-foreman/pull/1016) ([ekohl](https://github.com/ekohl))

## [19.1.1](https://github.com/theforeman/puppet-foreman/tree/19.1.1) (2022-01-26)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/19.1.0...19.1.1)

**Fixed bugs:**

- Fixes [\#34317](https://projects.theforeman.org/issues/34317) - Use the correct certificate to register [\#1022](https://github.com/theforeman/puppet-foreman/pull/1022) ([ekohl](https://github.com/ekohl))

## [19.1.0](https://github.com/theforeman/puppet-foreman/tree/19.1.0) (2022-01-25)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/19.0.0...19.1.0)

**Implemented enhancements:**

- Fixes [\#34089](https://projects.theforeman.org/issues/34089) - Add trusted proxies setting [\#1011](https://github.com/theforeman/puppet-foreman/pull/1011) ([sbernhard](https://github.com/sbernhard))
- puppetlabs/apache: Allow 7.x [\#1006](https://github.com/theforeman/puppet-foreman/pull/1006) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 8.x [\#1004](https://github.com/theforeman/puppet-foreman/pull/1004) ([bastelfreak](https://github.com/bastelfreak))
- Add basic `foreman_hostgroup` type [\#1002](https://github.com/theforeman/puppet-foreman/pull/1002) ([alexjfisher](https://github.com/alexjfisher))

**Fixed bugs:**

- Fixes [\#34308](https://projects.theforeman.org/issues/34308) - Explicitly notify db:seed from db:migrate [\#1020](https://github.com/theforeman/puppet-foreman/pull/1020) ([ekohl](https://github.com/ekohl))
- foreman::repo: use the package resource 'ensure' parameter to specify the desired ruby stream [\#1015](https://github.com/theforeman/puppet-foreman/pull/1015) ([bastelfreak](https://github.com/bastelfreak))
- Fixes [\#34161](https://projects.theforeman.org/issues/34161) - Run apipie:cache:index after db:migrate [\#1010](https://github.com/theforeman/puppet-foreman/pull/1010) ([ekohl](https://github.com/ekohl))
- Fix lack of idempotency in foreman\_smartproxy\_host provider [\#1009](https://github.com/theforeman/puppet-foreman/pull/1009) ([ehelms](https://github.com/ehelms))
- Fixes [\#33973](https://projects.theforeman.org/issues/33973) - Restart foreman.service when configuration changes [\#1008](https://github.com/theforeman/puppet-foreman/pull/1008) ([wbclark](https://github.com/wbclark))

**Merged pull requests:**

- Refs [\#34089](https://projects.theforeman.org/issues/34089) - Work around Kafo type parsing bug [\#1013](https://github.com/theforeman/puppet-foreman/pull/1013) ([ekohl](https://github.com/ekohl))

## [19.0.0](https://github.com/theforeman/puppet-foreman/tree/19.0.0) (2021-11-09)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/18.2.0...19.0.0)

**Breaking changes:**

- Drop server\_ssl\_certs\_dir parameter [\#1003](https://github.com/theforeman/puppet-foreman/pull/1003) ([ekohl](https://github.com/ekohl))
- Add Ubuntu 20.04 support & drop Ubuntu 18.04 [\#981](https://github.com/theforeman/puppet-foreman/pull/981) ([ekohl](https://github.com/ekohl))
- Fixes [\#33789](https://projects.theforeman.org/issues/33789) - Mark host where the installer is running as foreman [\#965](https://github.com/theforeman/puppet-foreman/pull/965) ([adamruzicka](https://github.com/adamruzicka))

**Implemented enhancements:**

- Refs [\#33760](https://projects.theforeman.org/issues/33760) - Add host\_reports plugin [\#1000](https://github.com/theforeman/puppet-foreman/pull/1000) ([ofedoren](https://github.com/ofedoren))
- Switch to puppet/systemd [\#997](https://github.com/theforeman/puppet-foreman/pull/997) ([jovandeginste](https://github.com/jovandeginste))
- Apply version restrictions to all packages [\#996](https://github.com/theforeman/puppet-foreman/pull/996) ([nbarrientos](https://github.com/nbarrientos))

**Fixed bugs:**

- Remove outdated providers docs [\#999](https://github.com/theforeman/puppet-foreman/pull/999) ([alexjfisher](https://github.com/alexjfisher))
- Fixes [\#33511](https://projects.theforeman.org/issues/33511) - configure redis before dynflow workers [\#995](https://github.com/theforeman/puppet-foreman/pull/995) ([evgeni](https://github.com/evgeni))

**Closed issues:**

- foreman\_config\_entry consuming polluted value [\#989](https://github.com/theforeman/puppet-foreman/issues/989)

## [18.2.0](https://github.com/theforeman/puppet-foreman/tree/18.2.0) (2021-08-24)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/18.1.0...18.2.0)

**Implemented enhancements:**

- Fixes [\#33320](https://projects.theforeman.org/issues/33320) - Refer to FQDN instead of "Foreman server" in SmartProx… [\#988](https://github.com/theforeman/puppet-foreman/pull/988) ([wbclark](https://github.com/wbclark))
- Fixes [\#33277](https://projects.theforeman.org/issues/33277): Change Puma default workers to 1.5 \* CPU, max threads to 5 [\#986](https://github.com/theforeman/puppet-foreman/pull/986) ([ehelms](https://github.com/ehelms))

**Fixed bugs:**

- Fixes [\#33214](https://projects.theforeman.org/issues/33214): Set minimum Puma threads equal to maximum puma threads … [\#984](https://github.com/theforeman/puppet-foreman/pull/984) ([ehelms](https://github.com/ehelms))

## [18.1.0](https://github.com/theforeman/puppet-foreman/tree/18.1.0) (2021-08-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/18.0.0...18.1.0)

**Implemented enhancements:**

- Add hammer plugin for foreman\_puppet [\#979](https://github.com/theforeman/puppet-foreman/pull/979) ([amirfefer](https://github.com/amirfefer))
- Add hammer plugin for foreman\_webhooks [\#977](https://github.com/theforeman/puppet-foreman/pull/977) ([ofedoren](https://github.com/ofedoren))

## [18.0.0](https://github.com/theforeman/puppet-foreman/tree/18.0.0) (2021-07-26)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/17.0.0...18.0.0)

**Breaking changes:**

- Fixes [\#33106](https://projects.theforeman.org/issues/33106) - Move user, app\_root, rails\_env & vhost\_prio to globals [\#975](https://github.com/theforeman/puppet-foreman/pull/975) ([ekohl](https://github.com/ekohl))
- Fixes [\#33089](https://projects.theforeman.org/issues/33089) - move \(hammer\_\)plugin\_prefix to globals [\#974](https://github.com/theforeman/puppet-foreman/pull/974) ([evgeni](https://github.com/evgeni))
- Drop Puppet 5 support [\#958](https://github.com/theforeman/puppet-foreman/pull/958) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Let Function to\_symbolized\_yaml handle Datatype Sensitive [\#972](https://github.com/theforeman/puppet-foreman/pull/972) ([cocker-cc](https://github.com/cocker-cc))
- Match Foreman user to what packaging creates [\#971](https://github.com/theforeman/puppet-foreman/pull/971) ([ekohl](https://github.com/ekohl))
- Handle duplicate file declaration for foreman::app\_root [\#969](https://github.com/theforeman/puppet-foreman/pull/969) ([chr1s692](https://github.com/chr1s692))
- Fixes [\#32947](https://projects.theforeman.org/issues/32947) - Use Apache module variables [\#968](https://github.com/theforeman/puppet-foreman/pull/968) ([ekohl](https://github.com/ekohl))
- Fixes [\#32352](https://projects.theforeman.org/issues/32352) - use mod\_auth\_gssapi instead of mod\_auth\_kerb [\#967](https://github.com/theforeman/puppet-foreman/pull/967) ([evgeni](https://github.com/evgeni))
- Autorequire provider in smartproxy type [\#966](https://github.com/theforeman/puppet-foreman/pull/966) ([ekohl](https://github.com/ekohl))
- Use to\_symbolized\_yaml instead of a template for supervisory [\#964](https://github.com/theforeman/puppet-foreman/pull/964) ([ekohl](https://github.com/ekohl))
- Use EPP instead of ERB for some templates [\#962](https://github.com/theforeman/puppet-foreman/pull/962) ([cocker-cc](https://github.com/cocker-cc))
- Fixes [\#32827](https://projects.theforeman.org/issues/32827) - Add sendmail config options [\#961](https://github.com/theforeman/puppet-foreman/pull/961) ([ekohl](https://github.com/ekohl))
- Add ACD plugin [\#957](https://github.com/theforeman/puppet-foreman/pull/957) ([sbernhard](https://github.com/sbernhard))
- Mark compatible with camptocamp/systemd 3.x [\#956](https://github.com/theforeman/puppet-foreman/pull/956) ([ekohl](https://github.com/ekohl))
- Allow puppet/redis 7.x [\#955](https://github.com/theforeman/puppet-foreman/pull/955) ([ekohl](https://github.com/ekohl))
- Allow customising ProxyAddHeaders [\#953](https://github.com/theforeman/puppet-foreman/pull/953) ([nbarrientos](https://github.com/nbarrientos))
- Support setting the priority of the Yum repositories [\#950](https://github.com/theforeman/puppet-foreman/pull/950) ([nbarrientos](https://github.com/nbarrientos))
- Allow Puppet 7 compatible versions of mods [\#947](https://github.com/theforeman/puppet-foreman/pull/947) ([ekohl](https://github.com/ekohl))
- Allow customising the list of HTTP headers to unset [\#944](https://github.com/theforeman/puppet-foreman/pull/944) ([nbarrientos](https://github.com/nbarrientos))
- Customisable Yum repository base URL and GPG key path [\#943](https://github.com/theforeman/puppet-foreman/pull/943) ([nbarrientos](https://github.com/nbarrientos))
- Refs [\#32885](https://projects.theforeman.org/issues/32885): Add puppet user to user\_groups only if server or client certificate contains puppet path [\#938](https://github.com/theforeman/puppet-foreman/pull/938) ([ehelms](https://github.com/ehelms))
- Fixes [\#29649](https://projects.theforeman.org/issues/29649) - Drop default\_server argument in IPA [\#935](https://github.com/theforeman/puppet-foreman/pull/935) ([ekohl](https://github.com/ekohl))
- Support Puppet 7 [\#921](https://github.com/theforeman/puppet-foreman/pull/921) ([ekohl](https://github.com/ekohl))
- Configurable: email\_reply\_address, email\_subject\_prefix [\#913](https://github.com/theforeman/puppet-foreman/pull/913) ([knorx](https://github.com/knorx))
- added foreman\_datacenter [\#868](https://github.com/theforeman/puppet-foreman/pull/868) ([Zenya](https://github.com/Zenya))

**Fixed bugs:**

- Remove unused suburi template [\#970](https://github.com/theforeman/puppet-foreman/pull/970) ([ekohl](https://github.com/ekohl))
- Make database.yml and settings.yaml have consistent headers [\#945](https://github.com/theforeman/puppet-foreman/pull/945) ([gcoxmoz](https://github.com/gcoxmoz))

**Closed issues:**

- Allow customising ProxyAddHeaders [\#952](https://github.com/theforeman/puppet-foreman/issues/952)
- Allow configuring the priority of the Yum repositories [\#949](https://github.com/theforeman/puppet-foreman/issues/949)
- foreman-report\_v2 disappeared from master branch ? [\#939](https://github.com/theforeman/puppet-foreman/issues/939)

## [17.0.0](https://github.com/theforeman/puppet-foreman/tree/17.0.0) (2021-04-26)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/16.1.0...17.0.0)

**Breaking changes:**

- Drop Puppetserver integration [\#933](https://github.com/theforeman/puppet-foreman/pull/933) ([ekohl](https://github.com/ekohl))
- Remove old email.yaml and cronjob cleanups [\#931](https://github.com/theforeman/puppet-foreman/pull/931) ([ekohl](https://github.com/ekohl))
- Fixes [\#29780](https://projects.theforeman.org/issues/29780) - Drop Passenger support and target Foreman 2.4+ [\#928](https://github.com/theforeman/puppet-foreman/pull/928) ([ekohl](https://github.com/ekohl))
- Fixes [\#31964](https://projects.theforeman.org/issues/31964) - Assign equal weight to sidekiq queues [\#927](https://github.com/theforeman/puppet-foreman/pull/927) ([ekohl](https://github.com/ekohl))
- Fixes [\#29817](https://projects.theforeman.org/issues/29817) - Implement a dynflow worker pool [\#843](https://github.com/theforeman/puppet-foreman/pull/843) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Enable Ruby 2.7 module for EL8 on Foreman 2.5+ [\#937](https://github.com/theforeman/puppet-foreman/pull/937) ([ehelms](https://github.com/ehelms))
- Refs [\#32276](https://projects.theforeman.org/issues/32276): Add Katello hammer plugin [\#936](https://github.com/theforeman/puppet-foreman/pull/936) ([ehelms](https://github.com/ehelms))
- Mark compatible with puppetlabs/postgresql 7.x [\#930](https://github.com/theforeman/puppet-foreman/pull/930) ([ekohl](https://github.com/ekohl))
- use deb gpg key from our server, not the gpg network [\#924](https://github.com/theforeman/puppet-foreman/pull/924) ([evgeni](https://github.com/evgeni))
- Fixes [\#32175](https://projects.theforeman.org/issues/32175): Allow toggling task backup when cleaning them up [\#922](https://github.com/theforeman/puppet-foreman/pull/922) ([ehelms](https://github.com/ehelms))
- Add foreman\_webhooks plugin [\#920](https://github.com/theforeman/puppet-foreman/pull/920) ([adamruzicka](https://github.com/adamruzicka))
- Add foreman\_puppet plugin [\#917](https://github.com/theforeman/puppet-foreman/pull/917) ([ezr-ondrej](https://github.com/ezr-ondrej))

**Fixed bugs:**

- Fixes [\#32208](https://projects.theforeman.org/issues/32208) - accept trailing slash in Krb auth url [\#926](https://github.com/theforeman/puppet-foreman/pull/926) ([ezr-ondrej](https://github.com/ezr-ondrej))

## [16.1.0](https://github.com/theforeman/puppet-foreman/tree/16.1.0) (2021-01-28)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/16.0.0...16.1.0)

**Implemented enhancements:**

- Fixes [\#31670](https://projects.theforeman.org/issues/31670) - don't timeout when running db:migrate [\#915](https://github.com/theforeman/puppet-foreman/pull/915) ([evgeni](https://github.com/evgeni))
- Fixes [\#30284](https://projects.theforeman.org/issues/30284) - Improve smartproxy registration failure error messages [\#912](https://github.com/theforeman/puppet-foreman/pull/912) ([wbclark](https://github.com/wbclark))
- Set the reverse proxy host to the name of the service [\#909](https://github.com/theforeman/puppet-foreman/pull/909) ([ehelms](https://github.com/ehelms))
- Use apache::mod::auth\_openidc [\#906](https://github.com/theforeman/puppet-foreman/pull/906) ([ekohl](https://github.com/ekohl))
- CLI: Allow to configure use\_sessions setting [\#905](https://github.com/theforeman/puppet-foreman/pull/905) ([neomilium](https://github.com/neomilium))
- CLI: make refresh\_cache and request\_timeout params global [\#884](https://github.com/theforeman/puppet-foreman/pull/884) ([neomilium](https://github.com/neomilium))
- Fixes [\#30803](https://projects.theforeman.org/issues/30803): Bind to socket for Puma and Apache [\#883](https://github.com/theforeman/puppet-foreman/pull/883) ([ehelms](https://github.com/ehelms))

**Fixed bugs:**

- Fix URI.escape deprecation warning [\#911](https://github.com/theforeman/puppet-foreman/pull/911) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Drop Puppet \< 3.7.5 version check [\#907](https://github.com/theforeman/puppet-foreman/pull/907) ([ekohl](https://github.com/ekohl))

## [16.0.0](https://github.com/theforeman/puppet-foreman/tree/16.0.0) (2020-10-30)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/15.1.1...16.0.0)

**Breaking changes:**

- Drop Rackspace compute resource that was dropped in Foreman 2.1 [\#894](https://github.com/theforeman/puppet-foreman/pull/894) ([ehelms](https://github.com/ehelms))
- fixes [\#29938](https://projects.theforeman.org/issues/29938) - change default logging layout [\#847](https://github.com/theforeman/puppet-foreman/pull/847) ([domitea](https://github.com/domitea))

**Implemented enhancements:**

- Set compute resource version parameter to advanced [\#886](https://github.com/theforeman/puppet-foreman/pull/886) ([ehelms](https://github.com/ehelms))
- Fixes [\#31215](https://projects.theforeman/org/issues/31215) - Generate DSL docs [\#892](https://github.com/theforeman/puppet-foreman/pull/892) ([ofedoren](https://github.com/ofedoren))

**Fixed bugs:**

- Refs [\#30535](https://projects.theforeman.org/issues/30535) - Correctly unset remote user groups [\#896](https://github.com/theforeman/puppet-foreman/pull/896) ([tbrisker](https://github.com/tbrisker))
- Drop foreman\_compute that was removed in 1.22 [\#895](https://github.com/theforeman/puppet-foreman/pull/895) ([ehelms](https://github.com/ehelms))

## [15.1.1](https://github.com/theforeman/puppet-foreman/tree/15.1.1) (2020-10-14)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/15.1.0...15.1.1)

**Fixed bugs:**

- Fixes [\#30535](https://projects.theforeman.org/issues/30535) - Set HTTP headers proxy requests [\#872](https://github.com/theforeman/puppet-foreman/pull/872) ([hsahmed](https://github.com/hsahmed))
- Fixes [\#30789](https://projects.theforeman.org/issues/30789) - Set DB pool size dynamically [\#882](https://github.com/theforeman/puppet-foreman/pull/882) ([ekohl](https://github.com/ekohl))

## [15.1.0](https://github.com/theforeman/puppet-foreman/tree/15.1.0) (2020-08-07)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/15.0.2...15.1.0)

**Implemented enhancements:**

- Fixes [\#30078](https://projects.theforeman.org/issues/30078) - add parameter to accept a hostgroup config hash [\#863](https://github.com/theforeman/puppet-foreman/pull/863) ([apatelKmd](https://github.com/apatelKmd))
- Fixes [\#29892](https://projects.theforeman.org/issues/29892) - Use server certs for websockets [\#846](https://github.com/theforeman/puppet-foreman/pull/846) ([ekohl](https://github.com/ekohl))
- Switch to postgresql::postgresql\_password [\#845](https://github.com/theforeman/puppet-foreman/pull/845) ([mmoll](https://github.com/mmoll))

## [15.0.2](https://github.com/theforeman/puppet-foreman/tree/15.0.2) (2020-08-03)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/15.0.1...15.0.2)

**Implemented enhancements:**

- Add foreman\_statistics plugin [\#855](https://github.com/theforeman/puppet-foreman/pull/855) ([ezr-ondrej](https://github.com/ezr-ondrej))
- add plugin foreman\_column\_view [\#601](https://github.com/theforeman/puppet-foreman/pull/601) ([dgoetz](https://github.com/dgoetz))

**Fixed bugs:**

- Fixes [\#30456](https://projects.theforeman.org/issues/30456) - Fix missing icons on /pub page [\#867](https://github.com/theforeman/puppet-foreman/pull/867) ([adamruzicka](https://github.com/adamruzicka))
- fix: indent for rails\_cache\_store redis type [\#859](https://github.com/theforeman/puppet-foreman/pull/859) ([ministicraft](https://github.com/ministicraft))

## [15.0.1](https://github.com/theforeman/puppet-foreman/tree/15.0.1) (2020-06-15)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/15.0.0...15.0.1)

**Fixed bugs:**

- Fixes [\#30026](https://projects.theforeman.org/issues/30026) - Ensure Foreman is provisioned before puppetdb [\#852](https://github.com/theforeman/puppet-foreman/pull/852) ([ekohl](https://github.com/ekohl))

## [15.0.0](https://github.com/theforeman/puppet-foreman/tree/15.0.0) (2020-05-15)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/14.0.0...15.0.0)

**Breaking changes:**

- Use modern facts [\#841](https://github.com/theforeman/puppet-foreman/issues/841)
- Prefix ipa and sssd facts with foreman\_ [\#839](https://github.com/theforeman/puppet-foreman/pull/839) ([ekohl](https://github.com/ekohl))
- Remove unused parameters from puppetmaster [\#824](https://github.com/theforeman/puppet-foreman/pull/824) ([ekohl](https://github.com/ekohl))
- Rename inventory\_upload to rh\_cloud [\#821](https://github.com/theforeman/puppet-foreman/pull/821) ([ShimShtein](https://github.com/ShimShtein))
- Refactor repository handling [\#815](https://github.com/theforeman/puppet-foreman/pull/815) ([ekohl](https://github.com/ekohl))
- Use plugin\_prefix to determine plugin packages [\#809](https://github.com/theforeman/puppet-foreman/pull/809) ([ekohl](https://github.com/ekohl))
- Fixes [\#29148](https://projects.theforeman.org/issues/29148) - Use Puma instead of Passenger by default [\#802](https://github.com/theforeman/puppet-foreman/pull/802) ([sthirugn](https://github.com/sthirugn))

**Implemented enhancements:**

- Allow puppet/redis 6.x [\#840](https://github.com/theforeman/puppet-foreman/pull/840) ([ekohl](https://github.com/ekohl))
- Refs [\#29601](https://projects.theforeman.org/issues/29601): Drop foreman-release-scl in favor of centos-release-scl-rh [\#838](https://github.com/theforeman/puppet-foreman/pull/838) ([ehelms](https://github.com/ehelms))
- Switch AIO detection to use aio\_agent\_version fact [\#834](https://github.com/theforeman/puppet-foreman/pull/834) ([ekohl](https://github.com/ekohl))
- Add Leapp plugin [\#833](https://github.com/theforeman/puppet-foreman/pull/833) ([stejskalleos](https://github.com/stejskalleos))
- Fixes [\#29212](https://projects.theforeman.org/issues/29212) - support el8 [\#828](https://github.com/theforeman/puppet-foreman/pull/828) ([wbclark](https://github.com/wbclark))
- Only install foreman-release-scl on CentOS EL 7 [\#822](https://github.com/theforeman/puppet-foreman/pull/822) ([ehelms](https://github.com/ehelms))
- Allow extlib 5.x [\#820](https://github.com/theforeman/puppet-foreman/pull/820) ([mmoll](https://github.com/mmoll))
- Refs [\#29144](https://projects.theforeman.org/issues/29144) - Use systemd socket activation [\#814](https://github.com/theforeman/puppet-foreman/pull/814) ([ekohl](https://github.com/ekohl))
- Fixes [\#29255](https://projects.theforeman.org/issues/29255) - Set plugin config file mode to 0640 [\#807](https://github.com/theforeman/puppet-foreman/pull/807) ([ekohl](https://github.com/ekohl))
- Fixes [\#28955](https://projects.theforeman.org/issues/28955) - Add puma configuration tuning options [\#790](https://github.com/theforeman/puppet-foreman/pull/790) ([sthirugn](https://github.com/sthirugn))
- Fixes [\#28436](https://projects.theforeman.org/issues/28436) - Add keycloak support [\#779](https://github.com/theforeman/puppet-foreman/pull/779) ([ekohl](https://github.com/ekohl))
- Add options for rails\_cache\_store [\#762](https://github.com/theforeman/puppet-foreman/pull/762) ([dgoetz](https://github.com/dgoetz))

**Fixed bugs:**

- Ensure Foreman is provisioned before configuring cockpit [\#835](https://github.com/theforeman/puppet-foreman/pull/835) ([ekohl](https://github.com/ekohl))
- Drop the separate rails repository [\#826](https://github.com/theforeman/puppet-foreman/pull/826) ([ekohl](https://github.com/ekohl))
- Refs [\#29148](https://projects.theforeman.org/issues/29148): Do not proxy /pulp2 to Puma [\#811](https://github.com/theforeman/puppet-foreman/pull/811) ([ehelms](https://github.com/ehelms))
- Correct casing on Stdlib::HTTPUrl [\#806](https://github.com/theforeman/puppet-foreman/pull/806) ([ekohl](https://github.com/ekohl))
- Fixes [\#28739](https://projects.theforeman.org/issues/28739): Fix static asset caching when using Puma [\#788](https://github.com/theforeman/puppet-foreman/pull/788) ([ehelms](https://github.com/ehelms))

**Closed issues:**

- db\_username changes do not work [\#750](https://github.com/theforeman/puppet-foreman/issues/750)

**Merged pull requests:**

- Make camptocamp/systemd a hard dependency [\#825](https://github.com/theforeman/puppet-foreman/pull/825) ([ekohl](https://github.com/ekohl))
- Make foreman::config::apache standalone [\#800](https://github.com/theforeman/puppet-foreman/pull/800) ([ekohl](https://github.com/ekohl))

## [14.0.0](https://github.com/theforeman/puppet-foreman/tree/14.0.0) (2020-02-12)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/13.1.0...14.0.0)

**Breaking changes:**

- Drop foreman::config::passenger::fragment [\#799](https://github.com/theforeman/puppet-foreman/pull/799) ([ekohl](https://github.com/ekohl))
- Ensure plugins are installed before the database [\#792](https://github.com/theforeman/puppet-foreman/pull/792) ([ekohl](https://github.com/ekohl))
- Drop keepalive parameters [\#785](https://github.com/theforeman/puppet-foreman/pull/785) ([ekohl](https://github.com/ekohl))
- Drop listen\_on\_interface [\#784](https://github.com/theforeman/puppet-foreman/pull/784) ([ekohl](https://github.com/ekohl))
- Drop the selinux parameter [\#783](https://github.com/theforeman/puppet-foreman/pull/783) ([ekohl](https://github.com/ekohl))
- Drop multiple database support [\#781](https://github.com/theforeman/puppet-foreman/pull/781) ([ekohl](https://github.com/ekohl))
- Drop Debian 9 and Ubuntu 16.04, add Debian 10 [\#777](https://github.com/theforeman/puppet-foreman/pull/777) ([mmoll](https://github.com/mmoll))
- Fixes [\#28067](https://projects.theforeman.org/issues/28067) - dynflow sidekiq services config [\#761](https://github.com/theforeman/puppet-foreman/pull/761) ([ezr-ondrej](https://github.com/ezr-ondrej))

**Implemented enhancements:**

- Run migrations if there are pending migrations [\#778](https://github.com/theforeman/puppet-foreman/pull/778) ([ehelms](https://github.com/ehelms))
- Fixes [\#26739](https://projects.theforeman.org/issues/26739) - Add admin users locale and timezone setting [\#731](https://github.com/theforeman/puppet-foreman/pull/731) ([sbernhard](https://github.com/sbernhard))

**Fixed bugs:**

- Refs [\#28067](https://projects.theforeman.org/issues/28067): Ensure dynflow worker config exists before service [\#791](https://github.com/theforeman/puppet-foreman/pull/791) ([ehelms](https://github.com/ehelms))

## [13.1.0](https://github.com/theforeman/puppet-foreman/tree/13.1.0) (2019-11-25)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/13.0.1...13.1.0)

**Implemented enhancements:**

- Add Foreman AzureRM cli option [\#772](https://github.com/theforeman/puppet-foreman/pull/772) ([apuntamb](https://github.com/apuntamb))
- Initial AzureRM support [\#767](https://github.com/theforeman/puppet-foreman/pull/767) ([apuntamb](https://github.com/apuntamb))

**Fixed bugs:**

- Fixes [\#28200](https://projects.theforeman.org/issues/28200) - Change cockpit port from 9999 to 19090 [\#768](https://github.com/theforeman/puppet-foreman/pull/768) ([adamruzicka](https://github.com/adamruzicka))

## [13.0.1](https://github.com/theforeman/puppet-foreman/tree/13.0.1) (2019-10-31)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/13.0.0...13.0.1)

**Fixed bugs:**

- Fixes [\#28146](https://projects.theforeman.org/issues/28146) - Drop double leading slash from cockpit url [\#764](https://github.com/theforeman/puppet-foreman/pull/764) ([adamruzicka](https://github.com/adamruzicka))

## [13.0.0](https://github.com/theforeman/puppet-foreman/tree/13.0.0) (2019-10-24)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/12.2.0...13.0.0)

**Breaking changes:**

- Sunsetting foreman\_cockpit because functionality being integrated in remote execution [\#756](https://github.com/theforeman/puppet-foreman/pull/756) ([dgoetz](https://github.com/dgoetz))
- Drop compatibility with Foreman 1.20 and older + puppetrun parameter [\#745](https://github.com/theforeman/puppet-foreman/pull/745) ([ekohl](https://github.com/ekohl))
- Rewrite to support reverse proxy [\#677](https://github.com/theforeman/puppet-foreman/pull/677) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Fixes [\#27932](https://projects.theforeman.org/issues/27932) - Add REX Cockpit support [\#760](https://github.com/theforeman/puppet-foreman/pull/760) ([ekohl](https://github.com/ekohl))
- Drop Puppet \< 3.4 compatibility code [\#755](https://github.com/theforeman/puppet-foreman/pull/755) ([ekohl](https://github.com/ekohl))
- Add supervisory\_authority plugin [\#754](https://github.com/theforeman/puppet-foreman/pull/754) ([laugmanuel](https://github.com/laugmanuel))
- Rely on Puppet data types to ensure variables content is valid in apache::fragment [\#753](https://github.com/theforeman/puppet-foreman/pull/753) ([neomilium](https://github.com/neomilium))
- Add support for foreman\_inventory\_upload plugin [\#749](https://github.com/theforeman/puppet-foreman/pull/749) ([ShimShtein](https://github.com/ShimShtein))
- Implement a foreman::enc function [\#742](https://github.com/theforeman/puppet-foreman/pull/742) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Make SSL parameters optional within foreman::puppetmaster [\#752](https://github.com/theforeman/puppet-foreman/pull/752) ([gcoxmoz](https://github.com/gcoxmoz))

**Merged pull requests:**

- remove references to ruby193-\* packages [\#741](https://github.com/theforeman/puppet-foreman/pull/741) ([evgeni](https://github.com/evgeni))

## [12.2.0](https://github.com/theforeman/puppet-foreman/tree/12.2.0) (2019-06-12)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/12.1.0...12.2.0)

**Implemented enhancements:**

- Use system packages on EL8 [\#734](https://github.com/theforeman/puppet-foreman/pull/734) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- allow newer versions of dependencies [\#737](https://github.com/theforeman/puppet-foreman/pull/737) ([mmoll](https://github.com/mmoll))
- Allow `puppetlabs/stdlib` 6.x [\#732](https://github.com/theforeman/puppet-foreman/pull/732) ([alexjfisher](https://github.com/alexjfisher))

## [12.1.0](https://github.com/theforeman/puppet-foreman/tree/12.1.0) (2019-05-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/12.0.0...12.1.0)

**Implemented enhancements:**

- Add hammer plugin for foreman\_kubevirt [\#733](https://github.com/theforeman/puppet-foreman/pull/733) ([shiramax](https://github.com/shiramax))
- Adding foreman\_kubevirt Plugin [\#730](https://github.com/theforeman/puppet-foreman/pull/730) ([masayag](https://github.com/masayag))
- allow puppetlabs-apt 7.x and puppetlabs-postgresql 7.x [\#728](https://github.com/theforeman/puppet-foreman/pull/728) ([mmoll](https://github.com/mmoll))

**Fixed bugs:**

- Fixes [\#26695](https://projects.theforeman.org/issues/26695) - remove puppetdb\_dashboard\_address [\#729](https://github.com/theforeman/puppet-foreman/pull/729) ([mmoll](https://github.com/mmoll))

## [12.0.0](https://github.com/theforeman/puppet-foreman/tree/12.0.0) (2019-04-18)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/11.0.1...12.0.0)

**Breaking changes:**

- Drop support for $use\_vhost [\#726](https://github.com/theforeman/puppet-foreman/pull/726) ([ekohl](https://github.com/ekohl))
- Refactor running with a service to Foreman 1.22 [\#723](https://github.com/theforeman/puppet-foreman/pull/723) ([ekohl](https://github.com/ekohl))
- drop Puppet 4 [\#719](https://github.com/theforeman/puppet-foreman/pull/719) ([mmoll](https://github.com/mmoll))

**Implemented enhancements:**

- Add Parameters for jobs\_service [\#725](https://github.com/theforeman/puppet-foreman/pull/725) ([cocker-cc](https://github.com/cocker-cc))
- Refactor f::config::passenger to f::config::apache [\#722](https://github.com/theforeman/puppet-foreman/pull/722) ([ekohl](https://github.com/ekohl))
- Add certname to error output in external\_node\_v2.rb [\#718](https://github.com/theforeman/puppet-foreman/pull/718) ([antaflos](https://github.com/antaflos))
- Avoid processing fact yaml files with empty 'values' hash [\#717](https://github.com/theforeman/puppet-foreman/pull/717) ([antaflos](https://github.com/antaflos))
- Expose options to the http and https vhosts [\#716](https://github.com/theforeman/puppet-foreman/pull/716) ([ekohl](https://github.com/ekohl))
- add cors domains parameter [\#715](https://github.com/theforeman/puppet-foreman/pull/715) ([timogoebel](https://github.com/timogoebel))

## [11.0.1](https://github.com/theforeman/puppet-foreman/tree/11.0.1) (2019-04-02)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/11.0.0...11.0.1)

**Fixed bugs:**

- Fixup yaml facts prior to parsing in node.rb [\#714](https://github.com/theforeman/puppet-foreman/pull/714) ([alexjfisher](https://github.com/alexjfisher))

**Closed issues:**

- Locations and Organizations get turned on by default in 11.0.0 and authentication off [\#711](https://github.com/theforeman/puppet-foreman/issues/711)

**Merged pull requests:**

- Clarify the defaults switched [\#712](https://github.com/theforeman/puppet-foreman/pull/712) ([ekohl](https://github.com/ekohl))

## [11.0.0](https://github.com/theforeman/puppet-foreman/tree/11.0.0) (2019-01-14)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/10.0.0...11.0.0)

**Breaking changes:**

- Remove default repo management [\#708](https://github.com/theforeman/puppet-foreman/pull/708) ([ekohl](https://github.com/ekohl))
- Fixes [\#25787](https://projects.theforeman.org/issues/25787) - Make login and taxonomy settings optional [\#707](https://github.com/theforeman/puppet-foreman/pull/707) ([tbrisker](https://github.com/tbrisker))
- Fixes [\#25170](https://projects.theforeman.org/issues/25170) - Prefix user params with initial\_ [\#701](https://github.com/theforeman/puppet-foreman/pull/701) ([chris1984](https://github.com/chris1984))

**Implemented enhancements:**

- allow puppetlabs-apache 4.x [\#709](https://github.com/theforeman/puppet-foreman/pull/709) ([mmoll](https://github.com/mmoll))
- Fixes [\#23054](https://projects.theforeman.org/issues/23054) - Refactor class inclusion [\#700](https://github.com/theforeman/puppet-foreman/pull/700) ([ekohl](https://github.com/ekohl))
- Declare Foreman group explicitly [\#697](https://github.com/theforeman/puppet-foreman/pull/697) ([ehelms](https://github.com/ehelms))
- Allow single node fact upload [\#692](https://github.com/theforeman/puppet-foreman/pull/692) ([ahmet2mir](https://github.com/ahmet2mir))
- Clean up acceptance tests + make the apt repo parameters [\#687](https://github.com/theforeman/puppet-foreman/pull/687) ([ekohl](https://github.com/ekohl))
- Add hammer plugin for foreman\_ansible [\#686](https://github.com/theforeman/puppet-foreman/pull/686) ([xprazak2](https://github.com/xprazak2))
- Reuse initialize\_http in external\_node\_v2 [\#683](https://github.com/theforeman/puppet-foreman/pull/683) ([ekohl](https://github.com/ekohl))
- Add Puppet 6 support [\#678](https://github.com/theforeman/puppet-foreman/pull/678) ([ekohl](https://github.com/ekohl))
- namespace extlib functions [\#675](https://github.com/theforeman/puppet-foreman/pull/675) ([mmoll](https://github.com/mmoll))

**Fixed bugs:**

- fix foreman config location for ssl = false and use\_vhost = false [\#705](https://github.com/theforeman/puppet-foreman/pull/705) ([Dimonyga](https://github.com/Dimonyga))
- Handle websockets\_encrypt as a boolean [\#702](https://github.com/theforeman/puppet-foreman/pull/702) ([ekohl](https://github.com/ekohl))
- Fix wrong variable name in enc function [\#694](https://github.com/theforeman/puppet-foreman/pull/694) ([ahmet2mir](https://github.com/ahmet2mir))
- Trying to fix rescue syntax in ENC script [\#685](https://github.com/theforeman/puppet-foreman/pull/685) ([qingbo](https://github.com/qingbo))

## [10.0.0](https://github.com/theforeman/puppet-foreman/tree/10.0.0) (2018-10-18)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/9.2.0...10.0.0)

**Breaking changes:**

- Remove remote\_file [\#664](https://github.com/theforeman/puppet-foreman/pull/664) ([ekohl](https://github.com/ekohl))
- Clean up providers [\#663](https://github.com/theforeman/puppet-foreman/pull/663) ([ekohl](https://github.com/ekohl))
- Refactor Puppet handling [\#662](https://github.com/theforeman/puppet-foreman/pull/662) ([ekohl](https://github.com/ekohl))
- Set release compatibility to 1.17+ [\#661](https://github.com/theforeman/puppet-foreman/pull/661) ([ekohl](https://github.com/ekohl))
- Refactor repo handling [\#660](https://github.com/theforeman/puppet-foreman/pull/660) ([ekohl](https://github.com/ekohl))
- Fixes [\#24399](https://projects.theforeman.org/issues/24399) - Drop email configuration via files [\#656](https://github.com/theforeman/puppet-foreman/pull/656) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Notify when the ENC cache is used [\#673](https://github.com/theforeman/puppet-foreman/pull/673) ([ekohl](https://github.com/ekohl))
- allow puppetlabs-stdlib 5.x [\#667](https://github.com/theforeman/puppet-foreman/pull/667) ([mmoll](https://github.com/mmoll))
- allow puppetlabs-concat 5.x [\#666](https://github.com/theforeman/puppet-foreman/pull/666) ([mmoll](https://github.com/mmoll))
- allow puppetlabs-apt 6.x [\#665](https://github.com/theforeman/puppet-foreman/pull/665) ([mmoll](https://github.com/mmoll))

**Closed issues:**

- Use of HTTP without TLS  [\#655](https://github.com/theforeman/puppet-foreman/issues/655)

**Merged pull requests:**

- Use contain over anchor [\#676](https://github.com/theforeman/puppet-foreman/pull/676) ([ekohl](https://github.com/ekohl))
- Refactor extras repo handling [\#672](https://github.com/theforeman/puppet-foreman/pull/672) ([ekohl](https://github.com/ekohl))
- Allow puppet/extlib 3 [\#671](https://github.com/theforeman/puppet-foreman/pull/671) ([alexjfisher](https://github.com/alexjfisher))
- Use stricter datatypes [\#669](https://github.com/theforeman/puppet-foreman/pull/669) ([ekohl](https://github.com/ekohl))
- metadata.json: bump allowed version of puppetlabs-apt to 6.0.0 [\#657](https://github.com/theforeman/puppet-foreman/pull/657) ([mateusz-gozdek-sociomantic](https://github.com/mateusz-gozdek-sociomantic))

## [9.2.0](https://github.com/theforeman/puppet-foreman/tree/9.2.0) (2018-07-11)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/9.1.0...9.2.0)

**Implemented enhancements:**

- Adding rescue plugin [\#648](https://github.com/theforeman/puppet-foreman/pull/648) ([cocker-cc](https://github.com/cocker-cc))
- Adding wreckingball Plugin [\#647](https://github.com/theforeman/puppet-foreman/pull/647) ([cocker-cc](https://github.com/cocker-cc))
- Adding dlm plugin [\#646](https://github.com/theforeman/puppet-foreman/pull/646) ([cocker-cc](https://github.com/cocker-cc))
- Adding spacewalk plugin [\#645](https://github.com/theforeman/puppet-foreman/pull/645) ([cocker-cc](https://github.com/cocker-cc))
- Add support for foreman\_virt\_who\_configure [\#642](https://github.com/theforeman/puppet-foreman/pull/642) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Fixes [\#22940](https://projects.theforeman.org/issues/22940) - Ensure the PG root cert is installed [\#650](https://github.com/theforeman/puppet-foreman/pull/650) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- support Ubuntu/bionic [\#651](https://github.com/theforeman/puppet-foreman/pull/651) ([mmoll](https://github.com/mmoll))

## [9.1.0](https://github.com/theforeman/puppet-foreman/tree/9.1.0) (2018-05-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/9.0.1...9.1.0)

**Implemented enhancements:**

- Ensure foreman-telemetry is installed if needed [\#638](https://github.com/theforeman/puppet-foreman/pull/638) ([ekohl](https://github.com/ekohl))
- Fixes [\#23101](https://projects.theforeman.org/issues/23101) - add telemetry options [\#637](https://github.com/theforeman/puppet-foreman/pull/637) ([ares](https://github.com/ares))
- Add classes for hammer cli commands [\#636](https://github.com/theforeman/puppet-foreman/pull/636) ([ekohl](https://github.com/ekohl))
- Refs [\#22559](https://projects.theforeman.org/issues/22559) - Add parameters for structured logging [\#631](https://github.com/theforeman/puppet-foreman/pull/631) ([ekohl](https://github.com/ekohl))
- permit puppetlabs-apache 3.x [\#628](https://github.com/theforeman/puppet-foreman/pull/628) ([mmoll](https://github.com/mmoll))

**Fixed bugs:**

- Refs [\#15963](https://projects.theforeman.org/issues/15963) - Correct documentation typos [\#641](https://github.com/theforeman/puppet-foreman/pull/641) ([itsbill](https://github.com/itsbill))
- Handle releases/ properly for yum plugins repo [\#634](https://github.com/theforeman/puppet-foreman/pull/634) ([ekohl](https://github.com/ekohl))

**Closed issues:**

- This puppet module breaks foreman installation [\#640](https://github.com/theforeman/puppet-foreman/issues/640)

**Merged pull requests:**

- Add a basic acceptance test [\#635](https://github.com/theforeman/puppet-foreman/pull/635) ([ekohl](https://github.com/ekohl))
- Run acceptance tests on Debian 9 instead of Debian 8 [\#632](https://github.com/theforeman/puppet-foreman/pull/632) ([ekohl](https://github.com/ekohl))
- Reduce PARALLEL\_TEST\_PROCESSORS to 8 [\#630](https://github.com/theforeman/puppet-foreman/pull/630) ([ekohl](https://github.com/ekohl))
- Add remote\_file acceptance test [\#627](https://github.com/theforeman/puppet-foreman/pull/627) ([sean797](https://github.com/sean797))
- Use selboolean for httpd\_dbus\_sssd [\#622](https://github.com/theforeman/puppet-foreman/pull/622) ([ekohl](https://github.com/ekohl))

## [9.0.1](https://github.com/theforeman/puppet-foreman/tree/9.0.1) (2018-02-28)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/9.0.0...9.0.1)

**Fixed bugs:**

- Remove test and development database declarations [\#624](https://github.com/theforeman/puppet-foreman/pull/624) ([ehelms](https://github.com/ehelms))

## [9.0.0](https://github.com/theforeman/puppet-foreman/tree/9.0.0) (2018-01-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman/compare/8.1.1...9.0.0)

**Breaking changes:**

- Convert ipa and sssd facts to structured facts [\#618](https://github.com/theforeman/puppet-foreman/pull/618) ([ekohl](https://github.com/ekohl))
- Fixes [\#18757](https://projects.theforeman.org/issues/18757) - Handle dynflow service in foreman core [\#602](https://github.com/theforeman/puppet-foreman/pull/602) ([ekohl](https://github.com/ekohl))
- Remove discovery image downloading [\#583](https://github.com/theforeman/puppet-foreman/pull/583) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Use puppet4 functions-api [\#623](https://github.com/theforeman/puppet-foreman/pull/623) ([juliantodt](https://github.com/juliantodt))
- Refs [\#22165](https://projects.theforeman.org/issues/22165) - Add installer support for disabling hsts [\#614](https://github.com/theforeman/puppet-foreman/pull/614) ([tbrisker](https://github.com/tbrisker))
- remove EOL OSes, add new ones [\#607](https://github.com/theforeman/puppet-foreman/pull/607) ([mmoll](https://github.com/mmoll))
- Add unattended\_url parameter [\#606](https://github.com/theforeman/puppet-foreman/pull/606) ([matonb](https://github.com/matonb))
- Manage puppetdb\_api\_version config entry [\#604](https://github.com/theforeman/puppet-foreman/pull/604) ([treydock](https://github.com/treydock))
- Fixes [\#21023](https://projects.theforeman.org/issues/21023) - Update start-timeout to 90 [\#603](https://github.com/theforeman/puppet-foreman/pull/603) ([chris1984](https://github.com/chris1984))
- Fixes [\#20819](https://projects.theforeman.org/issues/20819) - Allow turning task cleanup cron on and off [\#582](https://github.com/theforeman/puppet-foreman/pull/582) ([adamruzicka](https://github.com/adamruzicka))
- Add ability to set SSLProtocol for Apache vhost [\#600](https://github.com/theforeman/puppet-foreman/pull/600) ([ehelms](https://github.com/ehelms))

**Fixed bugs:**

- fixes [\#22196](https://projects.theforeman.org/issues/22196) - use ssl chain for hammer if available [\#615](https://github.com/theforeman/puppet-foreman/pull/615) ([stbenjam](https://github.com/stbenjam))
- Change to safe working directory in external\_node\_v2.rb [\#612](https://github.com/theforeman/puppet-foreman/pull/612) ([antaflos](https://github.com/antaflos))
- Fixes [\#21072](https://projects.theforeman.org/issues/21072) - build apipie cache after plugins [\#592](https://github.com/theforeman/puppet-foreman/pull/592) ([mbacovsky](https://github.com/mbacovsky))

## 8.1.1
* New classes to install Foreman plugins:
    * Add foreman::plugin::foreman_userdata
    * Add foreman::plugin::foreman_snapshot_management
* Other changes and fixes:
    * Add retry to foreman reporting script
    * Add the ability to get data by using the proxy SSL authentication configuration
    * Allow configuring Dynflow pool size
    * Bump allowed version of puppet-extlib to 2.0.0

## 8.1.0
* Other changes and fixes:
    * update node.rb for Puppet5 env fact
    * use apache module classes for mod_{authnz_pam,intercept_form_submit,lookup_identity}

## 8.0.0
* Drop Puppet 3 support
* New or changed parameters:
    * Add `$db_root_cert` to set the root SSL certificate used to verify SSL connections to PostgreSQL
    * Add `features` property to `foreman_smartproxy` provider to check enabled features
* Other changes and fixes:
    * Support login via smart card certificates

## 7.2.0
* New or changed parameters:
    * Add `$ssl_ca_file` to foreman::cli to specify the path to the SSL CA
      file for hammer_cli
    * Add `$access_log_format` to foreman::config:passenger. This is passed to
      apache::vhost to allow overriding the apache log format.
* Other changes and fixes:
    * Extend gzip file serving to /public/webpack
    * Restrict gzip asset serving to known extensions
    * Remove a possibly undefined requirement in foreman::plugin::discovery
    * Add open_timeout to the report and external node script
    * Add param for timeout to foreman() parser function
    * Allow including foreman::repo standalone

## 7.1.0
* New or changed parameters:
    * Add SSL certificate/key parameters to foreman::plugin::puppetdb
* Other changes and fixes:
    * Disable docroot management in apache::vhost, remove workaround
    * Remove default values from parameter documentation
    * Extended tests for plugin classes

## 7.0.0
* New classes to install Foreman plugins:
    * foreman::plugin::monitoring to install monitoring plugin
    * foreman::plugin::omaha to install Omaha plugin
    * foreman::cli::openscap to install Hammer CLI OpenSCAP plugin
* New or changed parameters:
    * Add db_managed_rake parameter to allow db_manage to be false while still
      managing DB migration/setup by default
    * Add email_config_method parameter to support database configuration of
      email settings with Foreman 1.14+
    * Add version parameter to foreman::cli class to enable updates
* Other changes and fixes:
    * Add environment from agent node YAML to ENC fact upload
    * Use ENC node cache when fact upload fails (GH-492)
    * Configure foreman-tasks plugin from Azure plugin class (GH-480)
    * Fix ordering of Apache service to happen inside foreman::service
    * Fix ordering of Puppet CA generation to Foreman startup (#17133)
    * Fix restarting service on config changes with db_manage disabled (GH-502)
    * Fix incorrect FreeIPA enrollment error on enrolled host
    * Permit extlib 1.x, tftp 2.x
    * Move advanced parameters into new documentation section (#16250)
    * Change parameter documentation to use Puppet 4 style typing
    * Add default parameters for Arch Linux, for ENC support
* Compatibility warnings:
    * Drop support for Ruby 1.8.7
    * If using `db_manage => false`, also set `db_managed_rake` to false if
      managing DB migrations/seed externally

## 6.0.0
* New classes to install Foreman plugins:
    * foreman::plugin::azure to install Azure compute resource plugin
    * foreman::plugin::expire_hosts to install expire hosts plugin
    * foreman::plugin::host_extra_validator to install hostname validator plugin
* New or changed parameters:
    * Add server_port, server_ssl_port parameters to change Apache vhost ports
    * Rename environment parameter to rails_env to fix compatibility with data
      bindings
* Other changes and fixes:
    * node.rb: skip facts upload when facts file is missing, retrieves ENC
      output anyway
    * node.rb: improve logging for empty facts and failed fact uploads
    * Change reports upload to use new config_reports API
    * Change Yum GPG key URLs to HTTPS
    * Fix missing default parameters for strict variables compatibility,
      requiring Puppet 3.7.5 or higher
    * Add SVG images to automatic gzip serving list
    * Move keepalive settings from a template to apache::vhost parameters
    * List Fedora 24 compatibility
* Compatibility warnings:
    * Requires Puppet 3.6 or higher to use the module
    * environment parameter renamed to rails_env
    * Remove Debian 7 (Wheezy) and Ubuntu 12.04 (Precise) support
    * Remove configure_openscap_repo parameter from `foreman::plugin::openscap`
    * Remove rest (v1) smart proxy provider and foreman_api installation
    * Remove `foreman::install::repos` define, use `foreman::repos`
    * Remove `apipie_task` parameter

## 5.2.2
* Fix interpolation of IPA variables in Apache configs (#15642)
* Fix inotify detection of new facts in node.rb watch facts

## 5.2.1
* Fix Apache config includes when VirtualHost priority is changed

## 5.2.0
* New or changed parameters:
    * Add client_ssl_* parameters to control SSL cert used by Foreman to
      communicate with its smart proxies (GH-441)
    * Add puppet_ssldir parameter, supporting new AIO paths and setting the
      `puppetssldir` value in settings.yaml
    * Add keepalive, max_keepalive_requests and keepalive_timeout parameters,
      defaulting to enabled for performance (#8489)
    * Add vhost_priority parameter to control Apache vhost priority (GH-418)
    * Add plugin_version parameter to change ensure property of plugin packages
* Other features:
    * Search for ENC/report configuration in Puppet AIO paths (GH-413)
    * Support report_timeout configuration in report processor
    * Add 'puppetmaster_fqdn' value to ENC facts upload
    * Add foreman::providers class to install type/provider dependencies
    * Document types/providers available in this module
    * Add rest_v3 provider for foreman_smartproxy with minimal dependencies,
      also supplied for AIO (#14455)
* Other changes and fixes:
    * Change apt repository configuration to use puppetlabs-apt 2.x (GH-428)
    * Change configure_scl_repo to true on RHEL for 1.12 compatibility
    * Manage ENC YAML directories, modes and ownership (GH-242)
    * Fix inconsistencies in Yum repos versus foreman-release (GH-388)
    * Fix nil provider error in foreman_config_entry prefetching (GH-420)
    * Fix foreman_smartproxy idempotency for proxy names with spaces (GH-421)
    * Fix foreman_smartproxy to only refresh when currently registered (GH-431)
    * Fix timeout usage warning in ENC under Ruby 2.3 (GH-438)
    * Fix ordering of Puppet server installation before Foreman user (#14942)
    * Fix ordering of foreman::cli after repo setup
    * Change Red Hat name in parameter docs (#14197)
    * Note requirement for en_US.utf8 locale (GH-417)
* Compatibility warnings:
    * `foreman::install::repos` has been moved to `foreman::repos`.
      The old define has been deprecated and will issue a warning.
    * `foreman::compute::openstack` and `foreman::compute::rackspace` default
      to Foreman 1.12 package names, pass `package => 'foreman-compute'` for
      pre-1.12 compatibility.
    * `rest` provider for foreman_smartproxy is deprecated, use rest_v3 or v2
    * `foreman::plugin::openscap` has configure_openscap_repo disabled by
      default, OS repos should now supply dependencies (#14520)

## 5.1.0
* New classes to install Foreman plugins:
    * foreman::plugin::ansible to install Ansible support
    * foreman::plugin::cockpit to install Cockpit support
    * foreman::plugin::memcache to install memcache support
* New or changed parameters:
    * Add puppetrun parameter, allowing you to enable the
      "Run puppet" button (and functionality) on individual host pages
    * Add address and dashboard_address parameters to foreman::plugin::puppetdb
    * Add ssl_certs_dir parameter to control SSLCACertificatePath, disabled by
      default
    * Add serveraliases parameter to manage virtual host aliases
* Other features:
    * Support and test with Puppet 4
    * Add hostgroup provider and type
    * Add filter_result parameter to foreman() search function, to filter out a
      single or set of fields from the results
    * Load OAuth keys in providers from /etc/foreman/settings.yaml if possible
* Other changes and fixes:
    * Support Puppet 3.0 minimum
    * Support Fedora 21, add Ubuntu 16.04
    * Use lower case FQDN to access Foreman smart proxy registration (#8389)
    * Configure PassengerRuby to use foreman-ruby symlink on Debian/Ubuntu
    * Fix key/value splitting in foreman_config_entry resource
    * Fix qualified call to postgresql defined type (GH-386)
    * Fix installation of the JSON package to use ensure_packages
    * Fix installation of remote execution plugin to restart foreman-tasks
* Compatibility warnings:
    * The puppetrun setting is now managed, ensure the parameter is set to true
      if you have already set it to true in the UI.  The default value in the
      params class is "false", and it will override your manual setting in the
      database.
    * Users of the puppetdb class may need to set address/dashboard_address
      parameters, which are now managed and default to "localhost".

## 5.0.2
* Install tasks plugin with remote_execution, chef and salt

## 5.0.1
* Remove fail() from plugin params classes when running on FreeBSD
* Test speed improvements

## 5.0.0
* New or changed parameters:
    * Add package parameter to foreman::plugin::ovirt_provision, puppetdb and
      tasks classes
    * Add plugin_prefix parameter to main class to override package prefixes
    * Removed the configure_ipa_repo parameter
* Other features:
    * Support Puppet master (ENC etc.) setup on FreeBSD
    * Add foreman::plugin::remote_execution class for remote execution plugin
    * Add foreman::plugin::dhcp_browser class for DHCP browser plugin
* Other changes and fixes:
    * Explicitly set permissions on yaml directory
    * Use absolute variables throughout manifests
    * Do not install Passenger packages when passenger parameter is false
    * Change case statement for service management to an if statement
    * Change EL RPM package prefix to 'tfm' for Foreman 1.10
    * Allow newer puppetlabs/apt 2.x module
    * Set PostgreSQL database encoding to UTF-8 (#11681)
    * Move Discovery plugin paramater validation into conditional
    * Set HTTP timeout in ENC script according to timeout setting
    * Prefer Puppet agent SSL CRL for Apache virtualhost configuration
    * Remove cache_data/random_password in favor of puppet/extlib module
    * Add ExportCertData option to Apache SSL virtualhost
    * Fix README typos
* Compatibility warnings:
    * Foreman 1.9 or older users on EL must set additional parameters to
      change package prefixes, see the README.md for details
    * The configure_ipa_repo parameter was removed
    * The cache_data/random_password parser functions were removed

## 4.0.1
* Fix missing brightbox/passenger-legacy PPA on Ubuntu 12.04 (#11069)

## 4.0.0
* New or changed parameters:
    * Add logging_level and loggers parameters to control log config on
      Foreman 1.9+ (#5838)
    * Add email_* parameters to set up email.yml configuration
* Other features:
    * Replace theforeman/concat_native with puppetlabs/concat
    * Add version parameter to foreman::compute::* classes
    * Support foreman::plugin::tasks on Debian
    * Improve smart proxy registration error message (#10466)
* Other changes and fixes:
    * Replace virtual resources in foreman::compute with classes
    * Use foreman-rake console instead of foreman-config, requires 1.7+
    * Fix support for puppetlabs/mysql 3.0
    * Fix websockets_encrypt entry in config file as on/off
    * Remove obsolete entries from settings.yaml
    * Test under future parser

## 3.0.2
* Fix default foreman::plugin::openscap parameter values
* foreman_config_entry: ensure HOME is set on all Puppet versions
* foreman_config_entry: change foreman-config to foreman-rake
* spec fixes for concat_native changes

## 3.0.1
* Fix support for mysql by removing inclusion of mysql class which was removed
  by puppetlabs/mysql in version 3.0.0
* Fix foreman_config_entry checking of dry parameter

## 3.0.0
* New classes to install Foreman plugins:
    * foreman::plugin::abrt to install ABRT support
    * foreman::plugin::digitalocean for DigitalOcean compute resources
    * foreman::plugin::docker for Docker container management
    * foreman::plugin::openscap to install OpenSCAP support
    * foreman::plugin::salt for Salt management support
* New or changed parameters:
    * Add db_pool parameter to control database connection pool size
    * Add manage_user parameter to disable 'foreman' user resource
    * Add server_ssl_crl parameter to change SSL CRL used
    * Add apipie_task parameter for Foreman 1.7 compatibility
    * Add puppet_user/group parameters to foreman::puppetmaster
    * Add timeout parameter to foreman::puppetmaster, increase timeout from
      10 to 60 seconds
    * Add config/config_file parameters to foreman::plugin
    * Add package parameter to foreman::compute::ec2 for Foreman 1.7
      compatibility
    * Rename facts parameter to receive_facts, due to trusted variables
      conflict, an incompatible change (#8944)
    * Changes to foreman::plugin::discovery parameters
    * Remove deprecated passenger_scl parameter, use passenger_ruby and
      passenger_ruby_package instead
* Other features:
    * Add support for Discovery Image 2.0 deployment
    * Add support to deploy Foreman on sub-URI with Passenger by changing
      the foreman_url parameter
    * Configure foreman-plugins repo, remove unused 'rc' repo support (#8880)
    * Enable SSL CRL checking to Foreman virtual host
    * Add additional resource types to foreman() search function (#9155)
* Other changes and fixes:
    * Use pending DB migration/seed flags in Foreman to re-run DB tasks when
      they fail on subsequent runs, requiring Foreman 1.7+ (#4611, #7353)
    * Use puppetlabs/apache 1.2.0 features
    * Improve ENC encoding handling to fix facts uploads from Windows
    * Improve tests with rspec-puppet-facts
    * Improvements for Puppet 4 and future parser support
    * Refreshed README
    * Fix apt-key installation from refreshonly to unless clause
    * Fix dependency on LSB facts (#9449)
    * Fix custom facts error when trying to load ruby-augeas
    * Fix class parameters documentation display in foreman-installer (#6904)
    * Fix mod_lookup_identity concatentation of multiple email addresses
    * Fix hard references to theforeman/puppet in foreman::puppetmaster
    * Fix foreman.yaml path in report processor comment
    * Fix minimum adrien/alternatives version to released 0.3.0
    * Fix spelling error in configure_scl_repo description
    * Fix metadata.json quality issues, pinning dependencies

## 2.3.2
* Refresh db:migrate if DB class changes (#9101)

## 2.3.1
* Ensure Foreman DB settings are initialised before Apache starts to prevent
  race condition (#4611, #7353)
* Remove timeout on apipie:cache rake task (#8381)
* Fix puppetdb_foreman Debian package name

## 2.3.0
* Add foreman_config_entry resource type and provider
* Configure Brightbox Ruby NG PPA on Ubuntu 12.04 (#7227)
    * Set PassengerRuby to ruby1.9.1 and install appropriate Passenger package
    * Keep Ruby alternative on 1.8 via alternatives module dependency (#7970)
* Add foreman::plugin::ovirt_provision class for ovirt_provision_plugin
* Install foreman-release-scl on EL clones (#7234)
* Refacter SSSD facts for faster runs
* Add docs to all classes/defines
* Remove expensive directory recursion on $vardir/yaml
* Deprecated: passenger_scl parameter has been replaced by passenger_ruby and
  passenger_ruby_package

## 2.2.4
* Set GPG keys for each Foreman repo
* Enable EPEL7 GPG checking (#6015)
* Wrap API parameters for new apipie-bindings
* Fix errors with strict variables
* Fix failed status calculation when log processor enabled

## 2.2.3
* Fix apipie-bindings cache path to prevent installer/master conflict
* Sync module configs

## 2.2.2
* Expose Apache vhost ServerName via servername parameter
* Fix dependency on TFTP directory in discovery image download
* Fix apipie-bindings cache directory when HOME is unset in daemon (#7063)
* Unit test and lint fixes

## 2.2.1
* Move ENC and report processor configuration to /etc/puppet/foreman.yaml

## 2.2.0
* Add ipa_authentication parameter to configure Foreman authentication against
  IPA using Kerberos etc (#6445)
* Add foreman::cli class to install and configure Hammer CLI
* Add admin_* parameters for initial admin username and password (Foreman 1.6)
* Add initial_* parameters to create an initial organization or location (#6802)
* Add foreman::plugin::tasks class to install foreman_tasks plugin
* install_images parameter added to foreman::plugin::discovery to download
  discovery images to TFTP root
* Change ENC and report processor configuration to /etc/foreman/puppet.yaml
  instead of embedded and templated settings
* Add foreman_smartproxy provider that uses apipie-bindings, adds a timeout
  parameter
* Configure websockets_ssl* in Foreman settings (#3601)
* Purge configuration files under Foreman httpd directories
* Extend startup timeout for Passenger, add parameters to control
* Refresh proxy features when foreman_smartproxy is notified (#3185)
* Fix future parser compatibility in random_password() and manifests
* Add Windows and SUSE to params class
* Remove v1 node and report processors
* Remove workaround for passenger.conf being replaced by pl-apache
* Refactor foreman::config::enc into foreman::puppetmaster

## 2.1.4
* Report processor: increment error counter for non-resource Puppet
  errors (#3851)

## 2.1.3
* Fix ordering of Apache and foreman_smartproxy resources
* Workaround Travis CI/REE issue

## 2.1.2
* Fix user shell path so it's valid on Debian (#5390)
* Remove obsolete test conditional for Facter 2 compat

## 2.1.1
* Fix SSL configuration with upper case hostnames (#4679)

## 2.1.0
* Add compute resource and new plugin classes (#3308)
* Add support for parallel fact pushes in node.rb
* Add event driven fact pushing (--watch-facts) in node.rb
* Add server_ssl_chain parameter to set SSLCertificateChainFile
* Add support for plugins to add virtual host entries
* Use alphanumeric ordering for vhosts (#4225)
* Use the production CentOS SCL repo, use centos-release-SCL
* Add Debian plugins repo
* Update to puppetlabs-apache 1.0
* Trigger db:seed too when DB changes
* Run foreman-rake apipie:cache after installation
* Ensure plugins are installed after core
* Improve node.rb response when server-side error occurs
* Remove template source from header for Puppet 3.5 compatibility
* Add basic Archlinux support for agent classes
* Fix Modulefile specification for Forge compatibility
* Cleanup of foreman::config

## 2.0.1
* Bump stdlib dependency to fix Forge upload error

## 2.0.0
* Add Foreman 1.4 support (default)
* Switch to puppetlabs-apache from theforeman-apache
* Switch to puppetlabs-postgresql version 3+
* Add foreman::plugin define and classes
* Set far-future expires headers for web UI assets
* Add db:seed support after db:migrate
* Add EPEL and SCL yum repository configuration
* Add $server_ssl_* parameters to configure vhost SSL certs
* Set PostgreSQL DB owner to foreman for db:drop support
* Create cache file properly to prevent re-sending of fact files (node.rb)
* Add support for running node.rb as a different user
* Skip empty host fact files (node.rb)
* Fix running DB migrations for SQLite
* Fix JSON package name on Debian 6 (Squeeze)
* Fix proxy registration under foreman_api 0.1.18+
* Only chown files in cache_data if puppet user exists
* Quote database passwords in database.yml
* Updated foreman() parser function instructions
* Move passenger restart to foreman::service class
* Drop Puppet 3.0 and 3.1 tests
* Update tests for rspec-puppet 1.0.0


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
