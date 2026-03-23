const std = @import("std");
const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(
            self: @This(),
            series_id: u64,
            season_number: u32,
        ) !std.json.Parsed(types.TvSeasonDetails) {
            return self.client.fetchTvSeasonDetails(series_id, season_number);
        }

        pub fn detailsWithAppend(
            self: @This(),
            series_id: u64,
            season_number: u32,
            append_values: []const []const u8,
        ) !std.json.Parsed(types.TvSeasonDetails) {
            return self.client.fetchTvSeasonDetailsWithAppend(series_id, season_number, append_values);
        }

        pub fn detailsRequest(
            self: @This(),
            series_id: u64,
            season_number: u32,
        ) ClientType.TvSeasonRequest {
            return self.client.tvSeasonDetailsRequest(series_id, season_number);
        }
    };
}
