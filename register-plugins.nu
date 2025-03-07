# match command
def match [input, matchers: record] {
    echo $matchers | get $input | do $in
}

# register plugin
def register_plugin [encoding, plugin] {
    print $"registering ($plugin)"
    nu -c $'register -e ($encoding) ($plugin)'
}

# get list of all plugin files from their installed directory
let plugin_location = ((which nu).path.0 | path dirname)

# for each plugin file, print the name and launch another instance of nushell to register it
for plugin in (ls $"($plugin_location)/nu_plugin_*") {
    match ($plugin.name | path basename | str replace '\.exe$' '') {
        nu_plugin_custom_values: { register_plugin msgpack $plugin.name }
        nu_plugin_example: { register_plugin msgpack $plugin.name }
        nu_plugin_from_parquet: { register_plugin json $plugin.name }
        nu_plugin_gstat: { register_plugin msgpack $plugin.name }
        nu_plugin_inc: { register_plugin json $plugin.name }
        nu_plugin_query: { register_plugin json $plugin.name }
    }
}

print "\nplugins registered, please restart nushell"

# print "\nplugin commands registered"
# version | get installed_plugins | split row ', '
