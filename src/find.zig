const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn byExternalId(
            self: @This(),
            external_id: []const u8,
            external_source: types.FindExternalSource,
        ) !std.json.Parsed(types.FindResponse) {
            return self.client.findByExternalId(external_id, external_source);
        }

        pub fn movieId(
            self: @This(),
            external_id: []const u8,
            external_source: types.FindExternalSource,
        ) !?u64 {
            return self.client.findFirstIdByExternalId(external_id, external_source, .movie);
        }

        pub fn personId(
            self: @This(),
            external_id: []const u8,
            external_source: types.FindExternalSource,
        ) !?u64 {
            return self.client.findFirstIdByExternalId(external_id, external_source, .person);
        }

        pub fn tvId(
            self: @This(),
            external_id: []const u8,
            external_source: types.FindExternalSource,
        ) !?u64 {
            return self.client.findFirstIdByExternalId(external_id, external_source, .tv);
        }

        pub fn tvSeasonId(
            self: @This(),
            external_id: []const u8,
            external_source: types.FindExternalSource,
        ) !?u64 {
            return self.client.findFirstIdByExternalId(external_id, external_source, .tv_season);
        }

        pub fn tvEpisodeId(
            self: @This(),
            external_id: []const u8,
            external_source: types.FindExternalSource,
        ) !?u64 {
            return self.client.findFirstIdByExternalId(external_id, external_source, .tv_episode);
        }
    };
}
