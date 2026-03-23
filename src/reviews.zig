const std = @import("std");
const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This(), review_id: []const u8) !std.json.Parsed(types.ReviewDetails) {
            return self.client.fetchReviewDetails(review_id);
        }
    };
}
