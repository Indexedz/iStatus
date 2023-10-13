fx_version "cerulean"
lua54 'yes'
game "gta5"

shared_script '@Index/imports/main.lua'
shared_script 'config.lua'

server_script 'server.lua'
client_script {
  'resources/**/client.lua',
  'client.lua'
}


files {
  'modules/**/*.lua',
  'modules/**/*.json'
}
