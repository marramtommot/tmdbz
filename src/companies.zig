const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn details(self: @This(), company_id: u64) !std.json.Parsed(types.CompanyDetails) {
            return self.client.fetchCompanyDetails(company_id);
        }

        pub fn alternativeNames(self: @This(), company_id: u64) !std.json.Parsed(types.CompanyAlternativeNames) {
            return self.client.fetchCompanyAlternativeNames(company_id);
        }

        pub fn images(self: @This(), company_id: u64) !std.json.Parsed(types.CompanyImages) {
            return self.client.fetchCompanyImages(company_id);
        }
    };
}
