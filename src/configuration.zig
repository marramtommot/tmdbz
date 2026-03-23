const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This()) !std.json.Parsed(types.ConfigurationDetails) {
            return self.client.fetchConfiguration();
        }

        pub fn countries(self: @This()) !std.json.Parsed(types.ConfigurationCountries) {
            return self.client.fetchConfigurationCountries();
        }

        pub fn jobs(self: @This()) !std.json.Parsed(types.ConfigurationJobs) {
            return self.client.fetchConfigurationJobs();
        }

        pub fn languages(self: @This()) !std.json.Parsed(types.ConfigurationLanguages) {
            return self.client.fetchConfigurationLanguages();
        }

        pub fn primaryTranslations(self: @This()) !std.json.Parsed(types.ConfigurationPrimaryTranslations) {
            return self.client.fetchConfigurationPrimaryTranslations();
        }

        pub fn timezones(self: @This()) !std.json.Parsed(types.ConfigurationTimezones) {
            return self.client.fetchConfigurationTimezones();
        }
    };
}
