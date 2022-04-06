require 'credentials_manager'

APP_IDENTIFIER = "com.technokratos.agona.watch-later-ios"
TEAM_ID = CredentialsManager::AppfileConfig.try_fetch_value(:team_id)
APPLE_ID = CredentialsManager::AppfileConfig.try_fetch_value(:apple_id)
APP_NAME = "WatchLater"
SKU = "com.technokratos.agona.watch-later-ios"
COMPANY_NAME = "TEKHNOKRATIYA, OOO"
GIT_DEV_URL = "git@git.technokratos.com:ios/match-development.git"
GIT_DISTRIBUTION_URL = "git@git.technokratos.com:ios/match-distribution.git"
TEMP_BUILD_FOLDER = "#{File.dirname(Dir.pwd)}/"
COMMON_CONFIG_FILE_PATH = TEMP_BUILD_FOLDER + "Configurations/Project.xcconfig"

PROD_SCHEME = "WatchLater_Prod"
DEV_SCHEME = "WatchLater_Dev"
WORKSPACE = "WatchLater"

def app_short_version
  `awk '{if ($1 ~ /PRODUCT_VERSION/) {print $3}}' #{COMMON_CONFIG_FILE_PATH}`.strip
end
