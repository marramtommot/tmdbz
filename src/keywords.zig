const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This(), keyword_id: u64) !std.json.Parsed(types.KeywordDetails) {
            return self.client.fetchKeywordDetails(keyword_id);
        }

        pub fn movies(
            self: @This(),
            keyword_id: u64,
            options: types.SearchQuery,
        ) !std.json.Parsed(types.KeywordMoviesResponse) {
            return self.client.fetchKeywordMovies(keyword_id, options);
        }
    };
}
