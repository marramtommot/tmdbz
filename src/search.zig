const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn movie(self: @This(), query: []const u8, year: ?u32) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchResults(.movie, query, year);
        }

        pub fn movieWithOptions(
            self: @This(),
            query: []const u8,
            options: types.SearchMovieQuery,
        ) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchMovieResults(query, options);
        }

        pub fn tv(self: @This(), query: []const u8, year: ?u32) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchResults(.series, query, year);
        }

        pub fn tvWithOptions(
            self: @This(),
            query: []const u8,
            options: types.SearchTvQuery,
        ) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchTvResults(query, options);
        }

        pub fn person(self: @This(), query: []const u8, options: types.SearchQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchPersonResults(query, options);
        }

        pub fn collection(self: @This(), query: []const u8, options: types.SearchQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchCollectionResults(query, options);
        }

        pub fn company(self: @This(), query: []const u8, options: types.SearchQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchCompanyResults(query, options);
        }

        pub fn keyword(self: @This(), query: []const u8, options: types.SearchQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchKeywordResults(query, options);
        }

        pub fn multi(self: @This(), query: []const u8, options: types.SearchQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.searchMultiResults(query, options);
        }

        pub fn movieId(self: @This(), query: []const u8, year: ?u32) !?u64 {
            return self.client.searchId(.movie, query, year);
        }

        pub fn personId(self: @This(), query: []const u8, options: types.SearchQuery) !?u64 {
            return self.client.searchSimpleId("person", query, options);
        }

        pub fn collectionId(self: @This(), query: []const u8, options: types.SearchQuery) !?u64 {
            return self.client.searchSimpleId("collection", query, options);
        }

        pub fn companyId(self: @This(), query: []const u8, options: types.SearchQuery) !?u64 {
            return self.client.searchSimpleId("company", query, options);
        }

        pub fn keywordId(self: @This(), query: []const u8, options: types.SearchQuery) !?u64 {
            return self.client.searchSimpleId("keyword", query, options);
        }

        pub fn tvId(self: @This(), query: []const u8, year: ?u32) !?u64 {
            return self.client.searchId(.series, query, year);
        }
    };
}
