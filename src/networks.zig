const std = @import("std");
const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This(), network_id: u64) !std.json.Parsed(types.NetworkDetails) {
            return self.client.fetchNetworkJson(types.NetworkDetails, network_id, null);
        }

        pub fn alternativeNames(self: @This(), network_id: u64) !std.json.Parsed(types.NetworkAlternativeNames) {
            return self.client.fetchNetworkJson(types.NetworkAlternativeNames, network_id, "alternative_names");
        }

        pub fn images(self: @This(), network_id: u64) !std.json.Parsed(types.NetworkImages) {
            return self.client.fetchNetworkJson(types.NetworkImages, network_id, "images");
        }
    };
}
