const std = @import("std");
const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(
            self: @This(),
            series_id: u64,
            season_number: u32,
            episode_number: u32,
        ) !std.json.Parsed(types.TvEpisodeDetails) {
            return self.client.fetchTvEpisodeDetails(series_id, season_number, episode_number);
        }

        pub fn detailsWithAppend(
            self: @This(),
            series_id: u64,
            season_number: u32,
            episode_number: u32,
            append_values: []const []const u8,
        ) !std.json.Parsed(types.TvEpisodeDetails) {
            return self.client.fetchTvEpisodeDetailsWithAppend(
                series_id,
                season_number,
                episode_number,
                append_values,
            );
        }

        pub fn detailsRequest(
            self: @This(),
            series_id: u64,
            season_number: u32,
            episode_number: u32,
        ) ClientType.TvEpisodeRequest {
            return self.client.tvEpisodeDetailsRequest(series_id, season_number, episode_number);
        }
    };
}
