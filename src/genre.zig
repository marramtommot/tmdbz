const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn movie(self: @This()) !std.json.Parsed(types.GenreList) {
            return self.client.fetchMovieGenres();
        }

        pub fn tv(self: @This()) !std.json.Parsed(types.GenreList) {
            return self.client.fetchTvGenres();
        }

        pub fn movies(
            self: @This(),
            genre_id: u64,
            options: types.SearchQuery,
        ) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchGenreMovies(genre_id, options);
        }
    };
}
