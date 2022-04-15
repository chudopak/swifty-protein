require_relative 'constants'

lane :match_development do
  match(
    type: "development",
    readonly: true,
    app_identifier: APP_IDENTIFIER,
    username: APPLE_ID,
    team_id: TEAM_ID,
    shallow_clone: true,
    git_url: GIT_DEV_URL,
    force: false
  )
end

lane :match_adhoc do
  match(
    type: "adhoc",
    readonly: true,
    app_identifier: APP_IDENTIFIER,
    username: APPLE_ID,
    team_id: TEAM_ID,
    shallow_clone: true,
    git_url: GIT_DISTRIBUTION_URL,
    force: false
  )
end

lane :match_app_store do
  match(
    type: "appstore",
    readonly: true,
    app_identifier: APP_IDENTIFIER,
    username: APPLE_ID,
    team_id: TEAM_ID,
    shallow_clone: true,
    git_url: GIT_DISTRIBUTION_URL,
    force: false
  )
end
