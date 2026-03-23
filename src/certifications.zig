const std = @import("std");
const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn movie(self: @This()) !std.json.Parsed(types.CertificationList) {
            return self.client.fetchMovieCertifications();
        }

        pub fn tv(self: @This()) !std.json.Parsed(types.CertificationList) {
            return self.client.fetchTvCertifications();
        }
    };
}
