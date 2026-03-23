const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn all(self: @This(), time_window: types.TrendingTimeWindow) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTrending("all", time_window);
        }

        pub fn movie(self: @This(), time_window: types.TrendingTimeWindow) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTrending("movie", time_window);
        }

        pub fn person(self: @This(), time_window: types.TrendingTimeWindow) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTrending("person", time_window);
        }

        pub fn tv(self: @This(), time_window: types.TrendingTimeWindow) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTrending("tv", time_window);
        }
    };
}
