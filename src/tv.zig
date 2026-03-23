const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This(), series_id: u64) !std.json.Parsed(types.TvDetails) {
            return self.client.fetchTvDetails(series_id);
        }

        pub fn detailsWithAppend(
            self: @This(),
            series_id: u64,
            append_values: []const []const u8,
        ) !std.json.Parsed(types.TvDetails) {
            return self.client.fetchTvDetailsWithAppend(series_id, append_values);
        }

        pub fn detailsRequest(self: @This(), series_id: u64) ClientType.TvRequest {
            return self.client.tvDetailsRequest(series_id);
        }

        pub fn findId(self: @This(), query: []const u8, year: ?u32) !?u64 {
            return self.client.searchId(.series, query, year);
        }

        pub fn findDetails(
            self: @This(),
            query: []const u8,
            year: ?u32,
        ) !?std.json.Parsed(types.TvDetails) {
            return self.client.findTvDetails(query, year);
        }

        pub fn airingToday(self: @This(), query: types.TvListQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTvList("airing_today", query);
        }

        pub fn onTheAir(self: @This(), query: types.TvListQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTvList("on_the_air", query);
        }

        pub fn popular(self: @This(), query: types.TvListQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTvList("popular", query);
        }

        pub fn topRated(self: @This(), query: types.TvListQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTvList("top_rated", query);
        }

        pub fn credits(self: @This(), series_id: u64) !std.json.Parsed(types.CreditsResponse) {
            return self.client.fetchTvSubresource(types.CreditsResponse, series_id, "credits");
        }

        pub fn externalIds(self: @This(), series_id: u64) !std.json.Parsed(types.ExternalIds) {
            return self.client.fetchTvSubresource(types.ExternalIds, series_id, "external_ids");
        }

        pub fn images(self: @This(), series_id: u64) !std.json.Parsed(types.MediaImages) {
            return self.client.fetchTvImages(series_id);
        }

        pub fn videos(self: @This(), series_id: u64) !std.json.Parsed(types.VideosResponse) {
            return self.client.fetchTvVideos(series_id);
        }

        pub fn similar(self: @This(), series_id: u64, page: ?u32) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTvSubresourcePaged(types.SearchResponse, series_id, "similar", page);
        }

        pub fn recommendations(self: @This(), series_id: u64, page: ?u32) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchTvSubresourcePaged(types.SearchResponse, series_id, "recommendations", page);
        }
    };
}
