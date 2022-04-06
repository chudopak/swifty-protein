require_relative 'constants'
require 'match'

lane :setup do
  produce(
    username: APPLE_ID,
    app_identifier: APP_IDENTIFIER,
    app_name: APP_NAME,
    language: 'Russian',
    app_version: app_short_version,
    sku: SKU,
    company_name: COMPANY_NAME,
    # App services can be enabled during app creation
    enable_services: {
      access_wifi: "off",             # Valid values: "on", "off"
      app_group: "off",               # Valid values: "on", "off"
      apple_pay: "off",               # Valid values: "on", "off"
      associated_domains: "off",      # Valid values: "on", "off"
      auto_fill_credential: "off",    # Valid values: "on", "off"
      #data_protection: "complete",   # Valid values: "complete", "unlessopen", "untilfirstauth",
      game_center: "on",             # Valid values: "on", "off"
      health_kit: "off",              # Valid values: "on", "off"
      home_kit: "off",                # Valid values: "on", "off"
      hotspot: "off",                 # Valid values: "on", "off"
      # icloud: "cloudkit",            # Valid values: "legacy", "cloudkit"
      in_app_purchase: "on",         # Valid values: "on", "off"
      inter_app_audio: "off",         # Valid values: "on", "off"
      multipath: "off",               # Valid values: "on", "off"
      network_extension: "off",       # Valid values: "on", "off"
      nfc_tag_reading: "off",         # Valid values: "on", "off"
      personal_vpn: "off",            # Valid values: "on", "off"
      passbook: "off",                # Valid values: "on", "off" (deprecated)
      push_notification: "on",       # Valid values: "on", "off"
      siri_kit: "off",                # Valid values: "on", "off"
      vpn_configuration: "off",       # Valid values: "on", "off" (deprecated)
      wallet: "off",                  # Valid values: "on", "off"
      wireless_accessory: "off",      # Valid values: "on", "off"
    }
  )
  match_development
  match_adhoc
  match_appstore
end
