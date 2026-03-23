const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn movie(self: @This(), query: types.DiscoverMovieQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.discoverMovie(query);
        }

        pub fn tv(self: @This(), query: types.DiscoverTvQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.discoverTv(query);
        }
    };
}
