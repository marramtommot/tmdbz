const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This(), collection_id: u64) !std.json.Parsed(types.CollectionDetails) {
            return self.client.fetchCollectionDetails(collection_id);
        }

        pub fn images(self: @This(), collection_id: u64) !std.json.Parsed(types.MediaImages) {
            return self.client.fetchCollectionImages(collection_id);
        }

        pub fn translations(self: @This(), collection_id: u64) !std.json.Parsed(types.CollectionTranslations) {
            return self.client.fetchCollectionTranslations(collection_id);
        }
    };
}
