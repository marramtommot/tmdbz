const std = @import("std");
const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn movie(self: @This(), query: types.ChangesQuery) !std.json.Parsed(types.ChangesList) {
            return self.client.fetchMovieChanges(query);
        }

        pub fn person(self: @This(), query: types.ChangesQuery) !std.json.Parsed(types.ChangesList) {
            return self.client.fetchPersonChanges(query);
        }

        pub fn tv(self: @This(), query: types.ChangesQuery) !std.json.Parsed(types.ChangesList) {
            return self.client.fetchTvChanges(query);
        }
    };
}
