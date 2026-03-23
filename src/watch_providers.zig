const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn movie(self: @This(), watch_region: ?[]const u8) !std.json.Parsed(types.WatchProviderListResponse) {
            return self.client.fetchWatchProviders("movie", watch_region);
        }

        pub fn tv(self: @This(), watch_region: ?[]const u8) !std.json.Parsed(types.WatchProviderListResponse) {
            return self.client.fetchWatchProviders("tv", watch_region);
        }

        pub fn regions(self: @This()) !std.json.Parsed(types.WatchProviderRegionsResponse) {
            return self.client.fetchWatchProviderRegions();
        }
    };
}
