fx_version('cerulean')
games({ 'gta5' })

shared_script('config.lua');

server_scripts({
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
});

client_scripts({
    'client.lua',
});