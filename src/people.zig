const std = @import("std");

const types = @import("types.zig");

pub fn Api(comptime ClientType: type) type {
    return struct {
        client: *ClientType,

        pub fn latest(self: @This()) !std.json.Parsed(types.PersonDetails) {
            return self.client.fetchLatestPerson();
        }

        pub fn popular(self: @This(), options: types.SearchQuery) !std.json.Parsed(types.SearchResponse) {
            return self.client.fetchPopularPeople(options);
        }

        pub fn details(self: @This(), person_id: u64) !std.json.Parsed(types.PersonDetails) {
            return self.client.fetchPersonDetails(person_id);
        }

        pub fn detailsWithAppend(
            self: @This(),
            person_id: u64,
            append_values: []const []const u8,
        ) !std.json.Parsed(types.PersonDetails) {
            return self.client.fetchPersonDetailsWithAppend(person_id, append_values);
        }

        pub fn detailsRequest(self: @This(), person_id: u64) ClientType.PersonRequest {
            return self.client.personDetailsRequest(person_id);
        }

        pub fn changes(self: @This(), person_id: u64, query: types.ChangesQuery) !std.json.Parsed(types.PersonChanges) {
            return self.client.fetchPersonDetailsChanges(person_id, query);
        }

        pub fn combinedCredits(self: @This(), person_id: u64) !std.json.Parsed(types.PersonCombinedCredits) {
            return self.client.fetchPersonLanguageJson(types.PersonCombinedCredits, person_id, "combined_credits");
        }

        pub fn externalIds(self: @This(), person_id: u64) !std.json.Parsed(types.PersonExternalIds) {
            return self.client.fetchPersonJson(types.PersonExternalIds, person_id, "external_ids");
        }

        pub fn images(self: @This(), person_id: u64) !std.json.Parsed(types.PersonImages) {
            return self.client.fetchPersonJson(types.PersonImages, person_id, "images");
        }

        pub fn movieCredits(self: @This(), person_id: u64) !std.json.Parsed(types.PersonMovieCredits) {
            return self.client.fetchPersonLanguageJson(types.PersonMovieCredits, person_id, "movie_credits");
        }

        pub fn taggedImages(self: @This(), person_id: u64, page: ?u32) !std.json.Parsed(types.PersonTaggedImages) {
            return self.client.fetchPersonPageJson(types.PersonTaggedImages, person_id, "tagged_images", page);
        }

        pub fn translations(self: @This(), person_id: u64) !std.json.Parsed(types.PersonTranslations) {
            return self.client.fetchPersonJson(types.PersonTranslations, person_id, "translations");
        }

        pub fn tvCredits(self: @This(), person_id: u64) !std.json.Parsed(types.PersonTvCredits) {
            return self.client.fetchPersonLanguageJson(types.PersonTvCredits, person_id, "tv_credits");
        }
    };
}
