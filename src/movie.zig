const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This(), movie_id: u64) !std.json.Parsed(types.MovieDetails) {
            return self.client.fetchMovieDetails(movie_id);
        }

        pub fn detailsWithAppend(
            self: @This(),
            movie_id: u64,
            append_values: []const []const u8,
        ) !std.json.Parsed(types.MovieDetails) {
            return self.client.fetchMovieDetailsWithAppend(movie_id, append_values);
        }

        pub fn detailsRequest(self: @This(), movie_id: u64) ClientType.MovieRequest {
            return self.client.movieDetailsRequest(movie_id);
        }

        pub fn findId(self: @This(), query: []const u8, year: ?u32) !?u64 {
            return self.client.searchId(.movie, query, year);
        }

        pub fn findDetails(
            self: @This(),
            query: []const u8,
            year: ?u32,
        ) !?std.json.Parsed(types.MovieDetails) {
            return self.client.findMovieDetails(query, year);
        }

        pub fn nowPlaying(self: @This(), query: types.MovieListQuery) !std.json.Parsed(types.MovieListResponse) {
            return self.client.fetchMovieList("now_playing", query);
        }

        pub fn popular(self: @This(), query: types.MovieListQuery) !std.json.Parsed(types.MovieListResponse) {
            return self.client.fetchMovieList("popular", query);
        }

        pub fn topRated(self: @This(), query: types.MovieListQuery) !std.json.Parsed(types.MovieListResponse) {
            return self.client.fetchMovieList("top_rated", query);
        }

        pub fn upcoming(self: @This(), query: types.MovieListQuery) !std.json.Parsed(types.MovieListResponse) {
            return self.client.fetchMovieList("upcoming", query);
        }

        pub fn credits(self: @This(), movie_id: u64) !std.json.Parsed(types.CreditsResponse) {
            return self.client.fetchMovieSubresource(types.CreditsResponse, movie_id, "credits");
        }

        pub fn externalIds(self: @This(), movie_id: u64) !std.json.Parsed(types.ExternalIds) {
            return self.client.fetchMovieSubresource(types.ExternalIds, movie_id, "external_ids");
        }

        pub fn images(self: @This(), movie_id: u64) !std.json.Parsed(types.MediaImages) {
            return self.client.fetchMovieImages(movie_id);
        }

        pub fn videos(self: @This(), movie_id: u64) !std.json.Parsed(types.VideosResponse) {
            return self.client.fetchMovieSubresource(types.VideosResponse, movie_id, "videos");
        }

        pub fn reviews(self: @This(), movie_id: u64, page: ?u32) !std.json.Parsed(types.ReviewsResponse) {
            return self.client.fetchMovieReviews(movie_id, page);
        }

        pub fn similar(self: @This(), movie_id: u64, page: ?u32) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchMovieSubresourcePaged(types.SearchResponse, movie_id, "similar", page);
        }

        pub fn recommendations(self: @This(), movie_id: u64, page: ?u32) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchMovieSubresourcePaged(types.SearchResponse, movie_id, "recommendations", page);
        }
    };
}
