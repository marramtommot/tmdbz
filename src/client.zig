const std = @import("std");

const dotenv = @import("dotenv.zig");
const groups = @import("groups.zig");
const types = @import("types.zig");

const api_base_url = "https://api.themoviedb.org/3";
const auth_bearer_prefix = "Bearer ";
const accept_header_name = "accept";
const accept_header_value = "application/json";
const authorization_header_name = "Authorization";

const path_configuration = api_base_url ++ "/configuration";
const path_configuration_countries = path_configuration ++ "/countries";
const path_genre_movie_list = api_base_url ++ "/genre/movie/list";
const path_genre_tv_list = api_base_url ++ "/genre/tv/list";
const path_person_latest = api_base_url ++ "/person/latest";
const path_watch_provider_regions = api_base_url ++ "/watch/providers/regions";

const resource_collection = "collection";
const resource_company = "company";
const resource_keyword = "keyword";
const resource_network = "network";
const resource_person = "person";
const resource_review = "review";

pub const Config = struct {
    token: []const u8,
    movie_search_base_url: []const u8 = "https://api.themoviedb.org/3/search/movie?",
    series_search_base_url: []const u8 = "https://api.themoviedb.org/3/search/tv?",
    language: ?[]const u8 = null,
    include_image_language: ?[]const u8 = "en-US,null",
};

pub const Testing = struct {
    client: *Client,

    pub fn buildSearchUrl(self: @This(), media_type: types.MediaType, query: []const u8, year: ?u32) ![]u8 {
        return self.client.buildSearchUrl(media_type, query, year);
    }

    pub fn buildSearchMovieUrl(self: @This(), query: []const u8, options: types.SearchMovieQuery) ![]u8 {
        return self.client.buildSearchMovieUrl(query, options);
    }

    pub fn buildSearchTvUrl(self: @This(), query: []const u8, options: types.SearchTvQuery) ![]u8 {
        return self.client.buildSearchTvUrl(query, options);
    }

    pub fn buildSimpleSearchUrl(self: @This(), kind: []const u8, query: []const u8, options: types.SearchQuery) ![]u8 {
        return self.client.buildSimpleSearchUrl(kind, query, options);
    }

    pub fn buildLanguageAwareUrl(self: @This(), base_url: []const u8) ![]u8 {
        return self.client.buildLanguageAwareUrl(base_url);
    }

    pub fn buildGenreMoviesUrl(self: @This(), genre_id: u64, options: types.SearchQuery) ![]u8 {
        return self.client.buildGenreMoviesUrl(genre_id, options);
    }

    pub fn buildDiscoverMovieUrl(self: @This(), query: types.DiscoverMovieQuery) ![]u8 {
        return self.client.buildDiscoverMovieUrl(query);
    }

    pub fn buildDiscoverTvUrl(self: @This(), query: types.DiscoverTvQuery) ![]u8 {
        return self.client.buildDiscoverTvUrl(query);
    }

    pub fn buildFindUrl(self: @This(), external_id: []const u8, external_source: types.FindExternalSource) ![]u8 {
        return self.client.buildFindUrl(external_id, external_source);
    }

    pub fn buildTrendingUrl(self: @This(), media_kind: []const u8, time_window: types.TrendingTimeWindow) ![]u8 {
        return self.client.buildTrendingUrl(media_kind, time_window);
    }

    pub fn buildMovieListUrl(self: @This(), list_kind: []const u8, query: types.MovieListQuery) ![]u8 {
        return self.client.buildMovieListUrl(list_kind, query);
    }

    pub fn buildTvListUrl(self: @This(), list_kind: []const u8, query: types.TvListQuery) ![]u8 {
        return self.client.buildTvListUrl(list_kind, query);
    }

    pub fn buildMovieSubresourceUrl(self: @This(), movie_id: u64, suffix: []const u8, page: ?u32, include_image_language: ?[]const u8) ![]u8 {
        return self.client.buildMovieSubresourceUrl(movie_id, suffix, page, include_image_language);
    }

    pub fn buildTvSubresourceUrl(self: @This(), series_id: u64, suffix: []const u8, page: ?u32, include_image_language: ?[]const u8, include_video_language: ?[]const u8) ![]u8 {
        return self.client.buildTvSubresourceUrl(series_id, suffix, page, include_image_language, include_video_language);
    }

    pub fn buildWatchProvidersUrl(self: @This(), media_kind: []const u8, watch_region: ?[]const u8) ![]u8 {
        return self.client.buildWatchProvidersUrl(media_kind, watch_region);
    }

    pub fn buildWatchProviderRegionsUrl(self: @This()) ![]u8 {
        return self.client.buildWatchProviderRegionsUrl();
    }

    pub fn buildPeoplePopularUrl(self: @This(), options: types.SearchQuery) ![]u8 {
        return self.client.buildPeoplePopularUrl(options);
    }

    pub fn buildCollectionUrl(self: @This(), collection_id: u64, suffix: ?[]const u8, include_image_language: ?[]const u8) ![]u8 {
        return self.client.buildCollectionUrl(collection_id, suffix, include_image_language);
    }

    pub fn buildKeywordUrl(self: @This(), keyword_id: u64, suffix: ?[]const u8, options: types.SearchQuery) ![]u8 {
        return self.client.buildKeywordUrl(keyword_id, suffix, options);
    }

    pub fn buildChangesUrl(self: @This(), scope: []const u8, query: types.ChangesQuery) ![]u8 {
        return self.client.buildChangesUrl(scope, query);
    }

    pub fn buildPersonDetailsUrl(self: @This(), person_id: u64, append_values: []const []const u8) ![]u8 {
        return self.client.buildPersonDetailsUrl(person_id, append_values);
    }

    pub fn buildDetailsUrl(self: @This(), media_type: types.MediaType, id: u64, append_values: []const []const u8, include_image_language: ?[]const u8) ![]u8 {
        return self.client.buildDetailsUrl(media_type, id, append_values, include_image_language);
    }

    pub fn buildTvSeasonDetailsUrl(self: @This(), series_id: u64, season_number: u32, append_values: []const []const u8, include_image_language: ?[]const u8) ![]u8 {
        return self.client.buildTvSeasonDetailsUrl(series_id, season_number, append_values, include_image_language);
    }

    pub fn buildTvEpisodeDetailsUrl(self: @This(), series_id: u64, season_number: u32, episode_number: u32, append_values: []const []const u8, include_image_language: ?[]const u8) ![]u8 {
        return self.client.buildTvEpisodeDetailsUrl(series_id, season_number, episode_number, append_values, include_image_language);
    }

    pub fn request(self: @This(), url: []const u8) ![]u8 {
        return self.client.request(url);
    }

    pub fn parseJson(self: @This(), comptime T: type, body: []const u8) !std.json.Parsed(T) {
        return self.client.parseJson(T, body);
    }

    pub fn applyGenreNames(target: []types.Genre, canonical: []const types.Genre) void {
        Client.applyGenreNames(target, canonical);
    }

    pub fn firstFindResultId(response: types.FindResponse, kind: types.FindResultKind) ?u64 {
        return Client.firstFindResultId(response, kind);
    }
};

const StaticBodyCache = struct {
    configuration: ?[]u8 = null,
    movie_certifications: ?[]u8 = null,
    tv_certifications: ?[]u8 = null,
    movie_genres: ?[]u8 = null,
    tv_genres: ?[]u8 = null,

    fn deinit(self: *StaticBodyCache, allocator: std.mem.Allocator) void {
        if (self.configuration) |body| allocator.free(body);
        if (self.movie_certifications) |body| allocator.free(body);
        if (self.tv_certifications) |body| allocator.free(body);
        if (self.movie_genres) |body| allocator.free(body);
        if (self.tv_genres) |body| allocator.free(body);
        self.* = .{};
    }
};

fn DetailRequestImpl(comptime T: type, comptime AppendEnum: type) type {
    return struct {
        allocator: std.mem.Allocator,
        client: *Client,
        media_type: types.MediaType,
        id: u64,
        append_values: std.ArrayListUnmanaged([]const u8) = .empty,
        include_image_language: ?[]const u8,

        pub fn deinit(self: *@This()) void {
            self.append_values.deinit(self.allocator);
        }

        pub fn appendRaw(self: *@This(), value: []const u8) !*@This() {
            try self.append_values.append(self.allocator, value);
            return self;
        }

        pub fn append(self: *@This(), value: AppendEnum) !*@This() {
            try self.append_values.append(self.allocator, @tagName(value));
            return self;
        }

        pub fn appendManyRaw(self: *@This(), values: []const []const u8) !*@This() {
            try self.append_values.appendSlice(self.allocator, values);
            return self;
        }

        pub fn appendMany(self: *@This(), values: []const AppendEnum) !*@This() {
            for (values) |value| {
                try self.append_values.append(self.allocator, @tagName(value));
            }
            return self;
        }

        pub fn setIncludeImageLanguage(self: *@This(), value: ?[]const u8) *@This() {
            self.include_image_language = value;
            return self;
        }

        pub fn build(self: *@This()) ![]u8 {
            return self.client.buildDetailsUrl(
                self.media_type,
                self.id,
                self.append_values.items,
                self.include_image_language,
            );
        }

        pub fn sendRaw(self: *@This()) ![]u8 {
            const url = try self.build();
            defer self.allocator.free(url);

            return try self.client.request(url);
        }

        pub fn sendAs(self: *@This(), comptime U: type) !std.json.Parsed(U) {
            const body = try self.sendRaw();
            defer self.allocator.free(body);

            return try self.client.parseJson(U, body);
        }

        pub fn sendValue(self: *@This()) !std.json.Parsed(std.json.Value) {
            return self.sendAs(std.json.Value);
        }

        pub fn send(self: *@This()) !std.json.Parsed(T) {
            var parsed = try self.sendAs(T);
            errdefer parsed.deinit();

            if (@hasField(T, "genres")) {
                try self.client.enrichDetailsGenres(self.media_type, parsed.value.genres);
            }

            return parsed;
        }
    };
}

pub const MovieDetailsRequest = DetailRequestImpl(types.MovieDetails, types.MovieAppend);
pub const TvDetailsRequest = DetailRequestImpl(types.TvDetails, types.TvAppend);
pub const DetailsRequest = MovieDetailsRequest;

const PersonRequestImpl = struct {
    allocator: std.mem.Allocator,
    client: *Client,
    person_id: u64,
    append_values: std.ArrayListUnmanaged([]const u8) = .empty,

    pub fn deinit(self: *PersonRequestImpl) void {
        self.append_values.deinit(self.allocator);
    }

    pub fn appendRaw(self: *PersonRequestImpl, value: []const u8) !*PersonRequestImpl {
        try self.append_values.append(self.allocator, value);
        return self;
    }

    pub fn append(self: *PersonRequestImpl, value: types.PersonAppend) !*PersonRequestImpl {
        try self.append_values.append(self.allocator, @tagName(value));
        return self;
    }

    pub fn appendManyRaw(self: *PersonRequestImpl, values: []const []const u8) !*PersonRequestImpl {
        try self.append_values.appendSlice(self.allocator, values);
        return self;
    }

    pub fn appendMany(self: *PersonRequestImpl, values: []const types.PersonAppend) !*PersonRequestImpl {
        for (values) |value| {
            try self.append_values.append(self.allocator, @tagName(value));
        }
        return self;
    }

    pub fn build(self: *PersonRequestImpl) ![]u8 {
        return self.client.buildPersonDetailsUrl(self.person_id, self.append_values.items);
    }

    pub fn sendRaw(self: *PersonRequestImpl) ![]u8 {
        const url = try self.build();
        defer self.allocator.free(url);

        return try self.client.request(url);
    }

    pub fn sendAs(self: *PersonRequestImpl, comptime T: type) !std.json.Parsed(T) {
        const body = try self.sendRaw();
        defer self.allocator.free(body);

        return try self.client.parseJson(T, body);
    }

    pub fn sendValue(self: *PersonRequestImpl) !std.json.Parsed(std.json.Value) {
        return self.sendAs(std.json.Value);
    }

    pub fn send(self: *PersonRequestImpl) !std.json.Parsed(types.PersonDetails) {
        return self.sendAs(types.PersonDetails);
    }
};

pub const PersonDetailsRequest = PersonRequestImpl;

const TvSeasonRequestImpl = struct {
    allocator: std.mem.Allocator,
    client: *Client,
    series_id: u64,
    season_number: u32,
    append_values: std.ArrayListUnmanaged([]const u8) = .empty,
    include_image_language: ?[]const u8,

    pub fn deinit(self: *TvSeasonRequestImpl) void {
        self.append_values.deinit(self.allocator);
    }

    pub fn appendRaw(self: *TvSeasonRequestImpl, value: []const u8) !*TvSeasonRequestImpl {
        try self.append_values.append(self.allocator, value);
        return self;
    }

    pub fn append(self: *TvSeasonRequestImpl, value: types.TvSeasonAppend) !*TvSeasonRequestImpl {
        try self.append_values.append(self.allocator, @tagName(value));
        return self;
    }

    pub fn appendManyRaw(self: *TvSeasonRequestImpl, values: []const []const u8) !*TvSeasonRequestImpl {
        try self.append_values.appendSlice(self.allocator, values);
        return self;
    }

    pub fn appendMany(self: *TvSeasonRequestImpl, values: []const types.TvSeasonAppend) !*TvSeasonRequestImpl {
        for (values) |value| {
            try self.append_values.append(self.allocator, @tagName(value));
        }
        return self;
    }

    pub fn setIncludeImageLanguage(self: *TvSeasonRequestImpl, value: ?[]const u8) *TvSeasonRequestImpl {
        self.include_image_language = value;
        return self;
    }

    pub fn build(self: *TvSeasonRequestImpl) ![]u8 {
        return self.client.buildTvSeasonDetailsUrl(
            self.series_id,
            self.season_number,
            self.append_values.items,
            self.include_image_language,
        );
    }

    pub fn sendRaw(self: *TvSeasonRequestImpl) ![]u8 {
        const url = try self.build();
        defer self.allocator.free(url);

        return try self.client.request(url);
    }

    pub fn sendAs(self: *TvSeasonRequestImpl, comptime T: type) !std.json.Parsed(T) {
        const body = try self.sendRaw();
        defer self.allocator.free(body);

        return try self.client.parseJson(T, body);
    }

    pub fn sendValue(self: *TvSeasonRequestImpl) !std.json.Parsed(std.json.Value) {
        return self.sendAs(std.json.Value);
    }

    pub fn send(self: *TvSeasonRequestImpl) !std.json.Parsed(types.TvSeasonDetails) {
        return self.sendAs(types.TvSeasonDetails);
    }
};

const TvEpisodeRequestImpl = struct {
    allocator: std.mem.Allocator,
    client: *Client,
    series_id: u64,
    season_number: u32,
    episode_number: u32,
    append_values: std.ArrayListUnmanaged([]const u8) = .empty,
    include_image_language: ?[]const u8,

    pub fn deinit(self: *TvEpisodeRequestImpl) void {
        self.append_values.deinit(self.allocator);
    }

    pub fn appendRaw(self: *TvEpisodeRequestImpl, value: []const u8) !*TvEpisodeRequestImpl {
        try self.append_values.append(self.allocator, value);
        return self;
    }

    pub fn append(self: *TvEpisodeRequestImpl, value: types.TvEpisodeAppend) !*TvEpisodeRequestImpl {
        try self.append_values.append(self.allocator, @tagName(value));
        return self;
    }

    pub fn appendManyRaw(self: *TvEpisodeRequestImpl, values: []const []const u8) !*TvEpisodeRequestImpl {
        try self.append_values.appendSlice(self.allocator, values);
        return self;
    }

    pub fn appendMany(self: *TvEpisodeRequestImpl, values: []const types.TvEpisodeAppend) !*TvEpisodeRequestImpl {
        for (values) |value| {
            try self.append_values.append(self.allocator, @tagName(value));
        }
        return self;
    }

    pub fn setIncludeImageLanguage(self: *TvEpisodeRequestImpl, value: ?[]const u8) *TvEpisodeRequestImpl {
        self.include_image_language = value;
        return self;
    }

    pub fn build(self: *TvEpisodeRequestImpl) ![]u8 {
        return self.client.buildTvEpisodeDetailsUrl(
            self.series_id,
            self.season_number,
            self.episode_number,
            self.append_values.items,
            self.include_image_language,
        );
    }

    pub fn sendRaw(self: *TvEpisodeRequestImpl) ![]u8 {
        const url = try self.build();
        defer self.allocator.free(url);

        return try self.client.request(url);
    }

    pub fn sendAs(self: *TvEpisodeRequestImpl, comptime T: type) !std.json.Parsed(T) {
        const body = try self.sendRaw();
        defer self.allocator.free(body);

        return try self.client.parseJson(T, body);
    }

    pub fn sendValue(self: *TvEpisodeRequestImpl) !std.json.Parsed(std.json.Value) {
        return self.sendAs(std.json.Value);
    }

    pub fn send(self: *TvEpisodeRequestImpl) !std.json.Parsed(types.TvEpisodeDetails) {
        return self.sendAs(types.TvEpisodeDetails);
    }
};

pub const TvSeasonDetailsRequest = TvSeasonRequestImpl;
pub const TvEpisodeDetailsRequest = TvEpisodeRequestImpl;

pub const Client = struct {
    pub const Request = MovieDetailsRequest;
    pub const MovieRequest = MovieDetailsRequest;
    pub const TvRequest = TvDetailsRequest;
    pub const PersonRequest = PersonRequestImpl;
    pub const TvSeasonRequest = TvSeasonRequestImpl;
    pub const TvEpisodeRequest = TvEpisodeRequestImpl;

    allocator: std.mem.Allocator,
    http_client: std.http.Client,
    config: Config,
    static_cache: StaticBodyCache = .{},

    pub fn init(allocator: std.mem.Allocator, config: Config) Client {
        return .{
            .allocator = allocator,
            .http_client = .{ .allocator = allocator },
            .config = config,
        };
    }

    pub fn deinit(self: *Client) void {
        self.static_cache.deinit(self.allocator);
        self.http_client.deinit();
    }

    pub fn testing(self: *Client) Testing {
        return .{ .client = self };
    }

    fn api(self: *Client, comptime ApiType: type) ApiType {
        return .{ .client = self };
    }

    pub fn search(self: *Client) groups.Search.Api(Client) {
        return self.api(groups.Search.Api(Client));
    }

    pub fn discover(self: *Client) groups.Discover.Api(Client) {
        return self.api(groups.Discover.Api(Client));
    }

    pub fn find(self: *Client) groups.Find.Api(Client) {
        return self.api(groups.Find.Api(Client));
    }

    pub fn trending(self: *Client) groups.Trending.Api(Client) {
        return self.api(groups.Trending.Api(Client));
    }

    pub fn watchProviders(self: *Client) groups.WatchProviders.Api(Client) {
        return self.api(groups.WatchProviders.Api(Client));
    }

    pub fn collections(self: *Client) groups.Collections.Api(Client) {
        return self.api(groups.Collections.Api(Client));
    }

    pub fn companies(self: *Client) groups.Companies.Api(Client) {
        return self.api(groups.Companies.Api(Client));
    }

    pub fn genres(self: *Client) groups.Genres.Api(Client) {
        return self.api(groups.Genres.Api(Client));
    }

    pub fn keywords(self: *Client) groups.Keywords.Api(Client) {
        return self.api(groups.Keywords.Api(Client));
    }

    pub fn movie(self: *Client) groups.Movie.Api(Client) {
        return self.api(groups.Movie.Api(Client));
    }

    pub fn tv(self: *Client) groups.Tv.Api(Client) {
        return self.api(groups.Tv.Api(Client));
    }

    pub fn configuration(self: *Client) groups.Configuration.Api(Client) {
        return self.api(groups.Configuration.Api(Client));
    }

    pub fn networks(self: *Client) groups.Networks.Api(Client) {
        return self.api(groups.Networks.Api(Client));
    }

    pub fn reviews(self: *Client) groups.Reviews.Api(Client) {
        return self.api(groups.Reviews.Api(Client));
    }

    pub fn certifications(self: *Client) groups.Certifications.Api(Client) {
        return self.api(groups.Certifications.Api(Client));
    }

    pub fn changes(self: *Client) groups.Changes.Api(Client) {
        return self.api(groups.Changes.Api(Client));
    }

    pub fn people(self: *Client) groups.People.Api(Client) {
        return self.api(groups.People.Api(Client));
    }

    pub fn tvSeasons(self: *Client) groups.TvSeasons.Api(Client) {
        return self.api(groups.TvSeasons.Api(Client));
    }

    pub fn tvEpisodes(self: *Client) groups.TvEpisodes.Api(Client) {
        return self.api(groups.TvEpisodes.Api(Client));
    }

    pub fn searchId(
        self: *Client,
        media_type: types.MediaType,
        query: []const u8,
        year: ?u32,
    ) !?u64 {
        const parsed = try self.searchResults(media_type, query, year);
        defer parsed.deinit();

        if (parsed.value.results.len == 0) return null;
        return parsed.value.results[0].id;
    }

    pub fn searchSimpleId(
        self: *Client,
        kind: []const u8,
        query: []const u8,
        options: types.SearchQuery,
    ) !?u64 {
        const parsed = try self.searchSimpleResults(kind, query, options);
        defer parsed.deinit();

        if (parsed.value.results.len == 0) return null;
        return parsed.value.results[0].id;
    }

    pub fn searchResults(
        self: *Client,
        media_type: types.MediaType,
        query: []const u8,
        year: ?u32,
    ) !std.json.Parsed(types.SearchResponse) {
        const url = switch (media_type) {
            .movie => try self.buildSearchMovieUrl(query, .{ .year = year }),
            .series => try self.buildSearchTvUrl(query, .{ .year = year }),
        };
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(types.SearchResponse, body);
    }

    pub fn searchMovieResults(
        self: *Client,
        query: []const u8,
        options: types.SearchMovieQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildSearchMovieUrl(query, options);
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(types.SearchResponse, body);
    }

    pub fn searchTvResults(
        self: *Client,
        query: []const u8,
        options: types.SearchTvQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildSearchTvUrl(query, options);
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(types.SearchResponse, body);
    }

    pub fn searchPersonResults(
        self: *Client,
        query: []const u8,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        return try self.searchSimpleResults("person", query, options);
    }

    pub fn searchCollectionResults(
        self: *Client,
        query: []const u8,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        return try self.searchSimpleResults("collection", query, options);
    }

    pub fn searchCompanyResults(
        self: *Client,
        query: []const u8,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        return try self.searchSimpleResults("company", query, options);
    }

    pub fn searchKeywordResults(
        self: *Client,
        query: []const u8,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        return try self.searchSimpleResults("keyword", query, options);
    }

    pub fn searchMultiResults(
        self: *Client,
        query: []const u8,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        return try self.searchSimpleResults("multi", query, options);
    }

    fn searchSimpleResults(
        self: *Client,
        kind: []const u8,
        query: []const u8,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildSimpleSearchUrl(kind, query, options);
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(types.SearchResponse, body);
    }

    pub fn discoverMovie(self: *Client, query: types.DiscoverMovieQuery) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildDiscoverMovieUrl(query);
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(types.SearchResponse, body);
    }

    pub fn discoverTv(self: *Client, query: types.DiscoverTvQuery) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildDiscoverTvUrl(query);
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(types.SearchResponse, body);
    }

    pub fn findByExternalId(
        self: *Client,
        external_id: []const u8,
        external_source: types.FindExternalSource,
    ) !std.json.Parsed(types.FindResponse) {
        const url = try self.buildFindUrl(external_id, external_source);
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(types.FindResponse, body);
    }

    pub fn findFirstIdByExternalId(
        self: *Client,
        external_id: []const u8,
        external_source: types.FindExternalSource,
        kind: types.FindResultKind,
    ) !?u64 {
        const parsed = try self.findByExternalId(external_id, external_source);
        defer parsed.deinit();

        return firstFindResultId(parsed.value, kind);
    }

    pub fn fetchTrending(
        self: *Client,
        media_kind: []const u8,
        time_window: types.TrendingTimeWindow,
    ) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildTrendingUrl(media_kind, time_window);
        return try self.fetchJsonUrl(types.SearchResponse, url);
    }

    pub fn fetchMovieList(
        self: *Client,
        list_kind: []const u8,
        query: types.MovieListQuery,
    ) !std.json.Parsed(types.MovieListResponse) {
        const url = try self.buildMovieListUrl(list_kind, query);
        return try self.fetchJsonUrl(types.MovieListResponse, url);
    }

    pub fn fetchTvList(
        self: *Client,
        list_kind: []const u8,
        query: types.TvListQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildTvListUrl(list_kind, query);
        return try self.fetchJsonUrl(types.SearchResponse, url);
    }

    pub fn fetchMovieSubresource(
        self: *Client,
        comptime T: type,
        movie_id: u64,
        suffix: []const u8,
    ) !std.json.Parsed(T) {
        const url = try self.buildMovieSubresourceUrl(movie_id, suffix, null, null);
        return try self.fetchJsonUrl(T, url);
    }

    pub fn fetchMovieSubresourcePaged(
        self: *Client,
        comptime T: type,
        movie_id: u64,
        suffix: []const u8,
        page: ?u32,
    ) !std.json.Parsed(T) {
        const url = try self.buildMovieSubresourceUrl(movie_id, suffix, page, null);
        return try self.fetchJsonUrl(T, url);
    }

    pub fn fetchMovieImages(self: *Client, movie_id: u64) !std.json.Parsed(types.MediaImages) {
        const url = try self.buildMovieSubresourceUrl(movie_id, "images", null, self.config.include_image_language);
        return try self.fetchJsonUrl(types.MediaImages, url);
    }

    pub fn fetchMovieReviews(self: *Client, movie_id: u64, page: ?u32) !std.json.Parsed(types.ReviewsResponse) {
        return try self.fetchMovieSubresourcePaged(types.ReviewsResponse, movie_id, "reviews", page);
    }

    pub fn fetchTvSubresource(
        self: *Client,
        comptime T: type,
        series_id: u64,
        suffix: []const u8,
    ) !std.json.Parsed(T) {
        const url = try self.buildTvSubresourceUrl(series_id, suffix, null, null, null);
        return try self.fetchJsonUrl(T, url);
    }

    pub fn fetchTvSubresourcePaged(
        self: *Client,
        comptime T: type,
        series_id: u64,
        suffix: []const u8,
        page: ?u32,
    ) !std.json.Parsed(T) {
        const url = try self.buildTvSubresourceUrl(series_id, suffix, page, null, null);
        return try self.fetchJsonUrl(T, url);
    }

    pub fn fetchTvImages(self: *Client, series_id: u64) !std.json.Parsed(types.MediaImages) {
        const url = try self.buildTvSubresourceUrl(series_id, "images", null, self.config.include_image_language, null);
        return try self.fetchJsonUrl(types.MediaImages, url);
    }

    pub fn fetchTvVideos(self: *Client, series_id: u64) !std.json.Parsed(types.VideosResponse) {
        const url = try self.buildTvSubresourceUrl(series_id, "videos", null, null, self.config.include_image_language);
        return try self.fetchJsonUrl(types.VideosResponse, url);
    }

    pub fn fetchTvReviews(self: *Client, series_id: u64, page: ?u32) !std.json.Parsed(types.ReviewsResponse) {
        return try self.fetchTvSubresourcePaged(types.ReviewsResponse, series_id, "reviews", page);
    }

    pub fn fetchWatchProviders(
        self: *Client,
        media_kind: []const u8,
        watch_region: ?[]const u8,
    ) !std.json.Parsed(types.WatchProviderListResponse) {
        const url = try self.buildWatchProvidersUrl(media_kind, watch_region);
        return try self.fetchJsonUrl(types.WatchProviderListResponse, url);
    }

    pub fn fetchWatchProviderRegions(self: *Client) !std.json.Parsed(types.WatchProviderRegionsResponse) {
        const url = try self.buildWatchProviderRegionsUrl();
        return try self.fetchJsonUrl(types.WatchProviderRegionsResponse, url);
    }

    pub fn fetchConfigurationCountries(self: *Client) !std.json.Parsed(types.ConfigurationCountries) {
        return try self.fetchLanguageAwareJson(types.ConfigurationCountries, path_configuration_countries);
    }

    pub fn fetchConfigurationJobs(self: *Client) !std.json.Parsed(types.ConfigurationJobs) {
        return try self.fetchConfigurationJson(types.ConfigurationJobs, "jobs");
    }

    pub fn fetchConfigurationLanguages(self: *Client) !std.json.Parsed(types.ConfigurationLanguages) {
        return try self.fetchConfigurationJson(types.ConfigurationLanguages, "languages");
    }

    pub fn fetchConfigurationPrimaryTranslations(self: *Client) !std.json.Parsed(types.ConfigurationPrimaryTranslations) {
        return try self.fetchConfigurationJson(types.ConfigurationPrimaryTranslations, "primary_translations");
    }

    pub fn fetchConfigurationTimezones(self: *Client) !std.json.Parsed(types.ConfigurationTimezones) {
        return try self.fetchConfigurationJson(types.ConfigurationTimezones, "timezones");
    }

    pub fn fetchPopularPeople(self: *Client, options: types.SearchQuery) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildPeoplePopularUrl(options);
        return try self.fetchJsonUrl(types.SearchResponse, url);
    }

    pub fn fetchCollectionDetails(self: *Client, collection_id: u64) !std.json.Parsed(types.CollectionDetails) {
        return try self.fetchCollectionJson(types.CollectionDetails, collection_id, null, null);
    }

    pub fn fetchCollectionImages(self: *Client, collection_id: u64) !std.json.Parsed(types.MediaImages) {
        return try self.fetchCollectionJson(types.MediaImages, collection_id, "images", self.config.include_image_language);
    }

    pub fn fetchCollectionTranslations(self: *Client, collection_id: u64) !std.json.Parsed(types.CollectionTranslations) {
        return try self.fetchCollectionJson(types.CollectionTranslations, collection_id, "translations", null);
    }

    pub fn fetchCompanyDetails(self: *Client, company_id: u64) !std.json.Parsed(types.CompanyDetails) {
        return try self.fetchCompanyJson(types.CompanyDetails, company_id, null);
    }

    pub fn fetchCompanyAlternativeNames(self: *Client, company_id: u64) !std.json.Parsed(types.CompanyAlternativeNames) {
        return try self.fetchCompanyJson(types.CompanyAlternativeNames, company_id, "alternative_names");
    }

    pub fn fetchCompanyImages(self: *Client, company_id: u64) !std.json.Parsed(types.CompanyImages) {
        return try self.fetchCompanyJson(types.CompanyImages, company_id, "images");
    }

    pub fn fetchKeywordDetails(self: *Client, keyword_id: u64) !std.json.Parsed(types.KeywordDetails) {
        return try self.fetchKeywordJson(types.KeywordDetails, keyword_id, null, .{});
    }

    pub fn fetchKeywordMovies(
        self: *Client,
        keyword_id: u64,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.KeywordMoviesResponse) {
        return try self.fetchKeywordJson(types.KeywordMoviesResponse, keyword_id, "movies", options);
    }

    pub fn findMovieDetails(
        self: *Client,
        query: []const u8,
        year: ?u32,
    ) !?std.json.Parsed(types.MovieDetails) {
        const id = try self.searchId(.movie, query, year) orelse return null;
        return try self.fetchMovieDetails(id);
    }

    pub fn fetchMovieDetails(
        self: *Client,
        movie_id: u64,
    ) !std.json.Parsed(types.MovieDetails) {
        return try sendRequest(self.movieDetailsRequest(movie_id));
    }

    pub fn fetchMovieDetailsWithAppend(
        self: *Client,
        movie_id: u64,
        append_values: []const []const u8,
    ) !std.json.Parsed(types.MovieDetails) {
        return try sendRequestWithAppend(self.movieDetailsRequest(movie_id), append_values);
    }

    pub fn movieDetailsRequest(self: *Client, movie_id: u64) MovieDetailsRequest {
        return .{
            .allocator = self.allocator,
            .client = self,
            .media_type = .movie,
            .id = movie_id,
            .include_image_language = self.config.include_image_language,
        };
    }

    pub fn findTvDetails(
        self: *Client,
        query: []const u8,
        year: ?u32,
    ) !?std.json.Parsed(types.TvDetails) {
        const id = try self.searchId(.series, query, year) orelse return null;
        return try self.fetchTvDetails(id);
    }

    pub fn fetchTvDetails(
        self: *Client,
        series_id: u64,
    ) !std.json.Parsed(types.TvDetails) {
        return try sendRequest(self.tvDetailsRequest(series_id));
    }

    pub fn fetchTvDetailsWithAppend(
        self: *Client,
        series_id: u64,
        append_values: []const []const u8,
    ) !std.json.Parsed(types.TvDetails) {
        return try sendRequestWithAppend(self.tvDetailsRequest(series_id), append_values);
    }

    pub fn tvDetailsRequest(self: *Client, series_id: u64) TvDetailsRequest {
        return .{
            .allocator = self.allocator,
            .client = self,
            .media_type = .series,
            .id = series_id,
            .include_image_language = self.config.include_image_language,
        };
    }

    pub fn fetchTvSeasonDetails(
        self: *Client,
        series_id: u64,
        season_number: u32,
    ) !std.json.Parsed(types.TvSeasonDetails) {
        return try sendRequest(self.tvSeasonDetailsRequest(series_id, season_number));
    }

    pub fn fetchTvSeasonDetailsWithAppend(
        self: *Client,
        series_id: u64,
        season_number: u32,
        append_values: []const []const u8,
    ) !std.json.Parsed(types.TvSeasonDetails) {
        return try sendRequestWithAppend(self.tvSeasonDetailsRequest(series_id, season_number), append_values);
    }

    pub fn tvSeasonDetailsRequest(
        self: *Client,
        series_id: u64,
        season_number: u32,
    ) TvSeasonRequestImpl {
        return .{
            .allocator = self.allocator,
            .client = self,
            .series_id = series_id,
            .season_number = season_number,
            .include_image_language = self.config.include_image_language,
        };
    }

    pub fn fetchTvEpisodeDetails(
        self: *Client,
        series_id: u64,
        season_number: u32,
        episode_number: u32,
    ) !std.json.Parsed(types.TvEpisodeDetails) {
        return try sendRequest(self.tvEpisodeDetailsRequest(series_id, season_number, episode_number));
    }

    pub fn fetchTvEpisodeDetailsWithAppend(
        self: *Client,
        series_id: u64,
        season_number: u32,
        episode_number: u32,
        append_values: []const []const u8,
    ) !std.json.Parsed(types.TvEpisodeDetails) {
        return try sendRequestWithAppend(
            self.tvEpisodeDetailsRequest(series_id, season_number, episode_number),
            append_values,
        );
    }

    pub fn fetchConfiguration(self: *Client) !std.json.Parsed(types.ConfigurationDetails) {
        return try self.fetchCachedJson(types.ConfigurationDetails, &self.static_cache.configuration, path_configuration);
    }

    pub fn fetchLatestPerson(self: *Client) !std.json.Parsed(types.PersonDetails) {
        const body = try self.request(path_person_latest);
        defer self.allocator.free(body);

        return try self.parseJson(types.PersonDetails, body);
    }

    pub fn fetchPersonDetails(self: *Client, person_id: u64) !std.json.Parsed(types.PersonDetails) {
        return try sendRequest(self.personDetailsRequest(person_id));
    }

    pub fn fetchPersonDetailsWithAppend(
        self: *Client,
        person_id: u64,
        append_values: []const []const u8,
    ) !std.json.Parsed(types.PersonDetails) {
        return try sendRequestWithAppend(self.personDetailsRequest(person_id), append_values);
    }

    pub fn personDetailsRequest(self: *Client, person_id: u64) PersonRequestImpl {
        return .{
            .allocator = self.allocator,
            .client = self,
            .person_id = person_id,
        };
    }

    pub fn fetchPersonDetailsChanges(
        self: *Client,
        person_id: u64,
        query: types.ChangesQuery,
    ) !std.json.Parsed(types.PersonChanges) {
        const url = try self.buildPersonChangesUrl(person_id, query);
        return try self.fetchJsonUrl(types.PersonChanges, url);
    }

    pub fn fetchReviewDetails(self: *Client, review_id: []const u8) !std.json.Parsed(types.ReviewDetails) {
        const url = try std.fmt.allocPrint(
            self.allocator,
            "{s}/{s}/{s}",
            .{ api_base_url, resource_review, review_id },
        );
        return try self.fetchJsonUrl(types.ReviewDetails, url);
    }

    pub fn fetchMovieCertifications(self: *Client) !std.json.Parsed(types.CertificationList) {
        return try self.fetchCachedJson(
            types.CertificationList,
            &self.static_cache.movie_certifications,
            api_base_url ++ "/certification/movie/list",
        );
    }

    pub fn fetchTvCertifications(self: *Client) !std.json.Parsed(types.CertificationList) {
        return try self.fetchCachedJson(
            types.CertificationList,
            &self.static_cache.tv_certifications,
            api_base_url ++ "/certification/tv/list",
        );
    }

    pub fn fetchMovieChanges(self: *Client, query: types.ChangesQuery) !std.json.Parsed(types.ChangesList) {
        return try self.fetchChangesScope("movie", query);
    }

    pub fn fetchPersonChanges(self: *Client, query: types.ChangesQuery) !std.json.Parsed(types.ChangesList) {
        return try self.fetchChangesScope("person", query);
    }

    pub fn fetchTvChanges(self: *Client, query: types.ChangesQuery) !std.json.Parsed(types.ChangesList) {
        return try self.fetchChangesScope("tv", query);
    }

    pub fn fetchMovieGenres(self: *Client) !std.json.Parsed(types.GenreList) {
        const url = try self.buildLanguageAwareUrl(path_genre_movie_list);
        defer self.allocator.free(url);
        return try self.fetchCachedJson(types.GenreList, &self.static_cache.movie_genres, url);
    }

    pub fn fetchTvGenres(self: *Client) !std.json.Parsed(types.GenreList) {
        const url = try self.buildLanguageAwareUrl(path_genre_tv_list);
        defer self.allocator.free(url);
        return try self.fetchCachedJson(types.GenreList, &self.static_cache.tv_genres, url);
    }

    pub fn fetchGenreMovies(
        self: *Client,
        genre_id: u64,
        options: types.SearchQuery,
    ) !std.json.Parsed(types.SearchResponse) {
        const url = try self.buildGenreMoviesUrl(genre_id, options);
        return try self.fetchJsonUrl(types.SearchResponse, url);
    }

    pub fn tvEpisodeDetailsRequest(
        self: *Client,
        series_id: u64,
        season_number: u32,
        episode_number: u32,
    ) TvEpisodeRequestImpl {
        return .{
            .allocator = self.allocator,
            .client = self,
            .series_id = series_id,
            .season_number = season_number,
            .episode_number = episode_number,
            .include_image_language = self.config.include_image_language,
        };
    }

    fn enrichDetailsGenres(
        self: *Client,
        media_type: types.MediaType,
        detail_genres: []types.Genre,
    ) !void {
        if (detail_genres.len == 0) return;

        var parsed_genres = switch (media_type) {
            .movie => try self.fetchMovieGenres(),
            .series => try self.fetchTvGenres(),
        };
        defer parsed_genres.deinit();

        applyGenreNames(detail_genres, parsed_genres.value.genres);
    }

    fn applyGenreNames(target: []types.Genre, canonical: []const types.Genre) void {
        for (target) |*genre| {
            if (genre.name.len != 0) continue;

            for (canonical) |known| {
                if (known.id != genre.id) continue;
                genre.name = known.name;
                break;
            }
        }
    }

    fn parseJson(self: *Client, comptime T: type, body: []const u8) !std.json.Parsed(T) {
        return std.json.parseFromSlice(T, self.allocator, body, .{
            .ignore_unknown_fields = true,
            .allocate = .alloc_always,
        });
    }

    fn sendRequest(details_request: anytype) !@TypeOf(details_request.send()) {
        var mutable_request = details_request;
        defer mutable_request.deinit();
        return try mutable_request.send();
    }

    fn sendRequestWithAppend(
        details_request: anytype,
        append_values: []const []const u8,
    ) !@TypeOf(details_request.send()) {
        var mutable_request = details_request;
        defer mutable_request.deinit();
        _ = try mutable_request.appendManyRaw(append_values);
        return try mutable_request.send();
    }

    pub fn fetchJsonUrl(self: *Client, comptime T: type, url: []u8) !std.json.Parsed(T) {
        defer self.allocator.free(url);

        const body = try self.request(url);
        defer self.allocator.free(body);

        return try self.parseJson(T, body);
    }

    fn fetchCollectionJson(
        self: *Client,
        comptime T: type,
        collection_id: u64,
        suffix: ?[]const u8,
        include_image_language: ?[]const u8,
    ) !std.json.Parsed(T) {
        const url = try self.buildCollectionUrl(collection_id, suffix, include_image_language);
        return try self.fetchJsonUrl(T, url);
    }

    fn fetchCompanyJson(
        self: *Client,
        comptime T: type,
        company_id: u64,
        suffix: ?[]const u8,
    ) !std.json.Parsed(T) {
        const url = try self.buildCompanyUrl(company_id, suffix);
        return try self.fetchJsonUrl(T, url);
    }

    fn fetchKeywordJson(
        self: *Client,
        comptime T: type,
        keyword_id: u64,
        suffix: ?[]const u8,
        options: types.SearchQuery,
    ) !std.json.Parsed(T) {
        const url = try self.buildKeywordUrl(keyword_id, suffix, options);
        return try self.fetchJsonUrl(T, url);
    }

    fn fetchCachedJson(self: *Client, comptime T: type, slot: *?[]u8, url: []const u8) !std.json.Parsed(T) {
        const body = try self.cachedBody(slot, url);
        return try self.parseJson(T, body);
    }

    fn fetchLanguageAwareJson(self: *Client, comptime T: type, base_url: []const u8) !std.json.Parsed(T) {
        const url = try self.buildLanguageAwareUrl(base_url);
        return try self.fetchJsonUrl(T, url);
    }

    fn fetchConfigurationJson(self: *Client, comptime T: type, suffix: []const u8) !std.json.Parsed(T) {
        const url = try std.fmt.allocPrint(
            self.allocator,
            "{s}/{s}",
            .{ path_configuration, suffix },
        );
        return try self.fetchJsonUrl(T, url);
    }

    fn fetchChangesScope(self: *Client, scope: []const u8, query: types.ChangesQuery) !std.json.Parsed(types.ChangesList) {
        const url = try self.buildChangesUrl(scope, query);
        return try self.fetchJsonUrl(types.ChangesList, url);
    }

    pub fn fetchPersonJson(self: *Client, comptime T: type, person_id: u64, suffix: []const u8) !std.json.Parsed(T) {
        const url = try std.fmt.allocPrint(
            self.allocator,
            "{s}/{s}/{d}/{s}",
            .{ api_base_url, resource_person, person_id, suffix },
        );
        return try self.fetchJsonUrl(T, url);
    }

    pub fn fetchPersonLanguageJson(self: *Client, comptime T: type, person_id: u64, suffix: []const u8) !std.json.Parsed(T) {
        const url = try self.buildPersonLanguageUrl(person_id, suffix);
        return try self.fetchJsonUrl(T, url);
    }

    pub fn fetchPersonPageJson(
        self: *Client,
        comptime T: type,
        person_id: u64,
        suffix: []const u8,
        page: ?u32,
    ) !std.json.Parsed(T) {
        const url = try self.buildPersonPageUrl(person_id, suffix, page);
        return try self.fetchJsonUrl(T, url);
    }

    pub fn fetchNetworkJson(self: *Client, comptime T: type, network_id: u64, suffix: ?[]const u8) !std.json.Parsed(T) {
        const url = if (suffix) |value|
            try std.fmt.allocPrint(
                self.allocator,
                "{s}/{s}/{d}/{s}",
                .{ api_base_url, resource_network, network_id, value },
            )
        else
            try std.fmt.allocPrint(self.allocator, "{s}/{s}/{d}", .{ api_base_url, resource_network, network_id });

        return try self.fetchJsonUrl(T, url);
    }

    fn cachedBody(self: *Client, slot: *?[]u8, url: []const u8) ![]const u8 {
        if (slot.* == null) {
            slot.* = try self.request(url);
        }
        return slot.*.?;
    }

    fn request(self: *Client, url: []const u8) ![]u8 {
        var response_body = std.Io.Writer.Allocating.init(self.allocator);
        errdefer response_body.deinit();

        const authorization = try std.fmt.allocPrint(
            self.allocator,
            auth_bearer_prefix ++ "{s}",
            .{self.config.token},
        );
        defer self.allocator.free(authorization);

        const headers = [_]std.http.Header{
            .{ .name = accept_header_name, .value = accept_header_value },
            .{ .name = authorization_header_name, .value = authorization },
        };

        const result = try self.http_client.fetch(.{
            .location = .{ .url = url },
            .method = .GET,
            .extra_headers = &headers,
            .response_writer = &response_body.writer,
        });

        if (result.status != .ok) return error.TMDBRequestFailed;

        var list = response_body.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildSearchUrl(
        self: *Client,
        media_type: types.MediaType,
        query: []const u8,
        year: ?u32,
    ) ![]u8 {
        return switch (media_type) {
            .movie => self.buildSearchMovieUrl(query, .{ .year = year }),
            .series => self.buildSearchTvUrl(query, .{ .year = year }),
        };
    }

    fn buildSearchMovieUrl(
        self: *Client,
        query: []const u8,
        options: types.SearchMovieQuery,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.writeAll(api_base_url ++ "/search/movie");
        try writeQueryString(&writer.writer, &has_query, "query", query);
        try writeOptionalBool(&writer.writer, &has_query, "include_adult", options.include_adult);
        try writeOptionalU32(&writer.writer, &has_query, "page", options.page);
        try writeOptionalU32(&writer.writer, &has_query, "year", options.year);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildSearchTvUrl(
        self: *Client,
        query: []const u8,
        options: types.SearchTvQuery,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.writeAll(api_base_url ++ "/search/tv");
        try writeQueryString(&writer.writer, &has_query, "query", query);
        try writeOptionalBool(&writer.writer, &has_query, "include_adult", options.include_adult);
        try writeOptionalU32(&writer.writer, &has_query, "page", options.page);
        try writeOptionalU32(&writer.writer, &has_query, "year", options.year);
        try writeOptionalU32(&writer.writer, &has_query, "first_air_date_year", options.first_air_date_year);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildSimpleSearchUrl(
        self: *Client,
        kind: []const u8,
        query: []const u8,
        options: types.SearchQuery,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print("{s}/search/{s}", .{ api_base_url, kind });
        try writeQueryString(&writer.writer, &has_query, "query", query);
        try writeOptionalBool(&writer.writer, &has_query, "include_adult", options.include_adult);
        try writeOptionalU32(&writer.writer, &has_query, "page", options.page);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildDiscoverMovieUrl(self: *Client, query: types.DiscoverMovieQuery) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.writeAll(api_base_url ++ "/discover/movie");
        try writeOptionalString(&writer.writer, &has_query, "certification", query.certification);
        try writeOptionalString(&writer.writer, &has_query, "certification_country", query.certification_country);
        try writeOptionalString(&writer.writer, &has_query, "certification.gte", query.certification_gte);
        try writeOptionalString(&writer.writer, &has_query, "certification.lte", query.certification_lte);
        try writeOptionalBool(&writer.writer, &has_query, "include_adult", query.include_adult);
        try writeOptionalBool(&writer.writer, &has_query, "include_video", query.include_video);
        try writeOptionalU32(&writer.writer, &has_query, "page", query.page);
        try writeOptionalU32(&writer.writer, &has_query, "primary_release_year", query.primary_release_year);
        try writeOptionalString(&writer.writer, &has_query, "primary_release_date.gte", query.primary_release_date_gte);
        try writeOptionalString(&writer.writer, &has_query, "primary_release_date.lte", query.primary_release_date_lte);
        try writeOptionalString(&writer.writer, &has_query, "region", query.region);
        try writeOptionalString(&writer.writer, &has_query, "release_date.gte", query.release_date_gte);
        try writeOptionalString(&writer.writer, &has_query, "release_date.lte", query.release_date_lte);
        try writeOptionalString(&writer.writer, &has_query, "sort_by", query.sort_by);
        try writeOptionalF32(&writer.writer, &has_query, "vote_average.gte", query.vote_average_gte);
        try writeOptionalF32(&writer.writer, &has_query, "vote_average.lte", query.vote_average_lte);
        try writeOptionalU32(&writer.writer, &has_query, "vote_count.gte", query.vote_count_gte);
        try writeOptionalU32(&writer.writer, &has_query, "vote_count.lte", query.vote_count_lte);
        try writeOptionalString(&writer.writer, &has_query, "watch_region", query.watch_region);
        try writeOptionalString(&writer.writer, &has_query, "with_cast", query.with_cast);
        try writeOptionalString(&writer.writer, &has_query, "with_companies", query.with_companies);
        try writeOptionalString(&writer.writer, &has_query, "with_crew", query.with_crew);
        try writeOptionalString(&writer.writer, &has_query, "with_genres", query.with_genres);
        try writeOptionalString(&writer.writer, &has_query, "with_keywords", query.with_keywords);
        try writeOptionalString(&writer.writer, &has_query, "with_origin_country", query.with_origin_country);
        try writeOptionalString(&writer.writer, &has_query, "with_original_language", query.with_original_language);
        try writeOptionalString(&writer.writer, &has_query, "with_people", query.with_people);
        try writeOptionalString(&writer.writer, &has_query, "with_release_type", query.with_release_type);
        try writeOptionalU32(&writer.writer, &has_query, "with_runtime.gte", query.with_runtime_gte);
        try writeOptionalU32(&writer.writer, &has_query, "with_runtime.lte", query.with_runtime_lte);
        try writeOptionalString(&writer.writer, &has_query, "with_watch_monetization_types", query.with_watch_monetization_types);
        try writeOptionalString(&writer.writer, &has_query, "with_watch_providers", query.with_watch_providers);
        try writeOptionalString(&writer.writer, &has_query, "without_companies", query.without_companies);
        try writeOptionalString(&writer.writer, &has_query, "without_genres", query.without_genres);
        try writeOptionalString(&writer.writer, &has_query, "without_keywords", query.without_keywords);
        try writeOptionalString(&writer.writer, &has_query, "without_watch_providers", query.without_watch_providers);
        try writeOptionalU32(&writer.writer, &has_query, "year", query.year);
        try writeExtraParams(&writer.writer, &has_query, query.extra_params);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildDiscoverTvUrl(self: *Client, query: types.DiscoverTvQuery) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.writeAll(api_base_url ++ "/discover/tv");
        try writeOptionalString(&writer.writer, &has_query, "air_date.gte", query.air_date_gte);
        try writeOptionalString(&writer.writer, &has_query, "air_date.lte", query.air_date_lte);
        try writeOptionalU32(&writer.writer, &has_query, "first_air_date_year", query.first_air_date_year);
        try writeOptionalString(&writer.writer, &has_query, "first_air_date.gte", query.first_air_date_gte);
        try writeOptionalString(&writer.writer, &has_query, "first_air_date.lte", query.first_air_date_lte);
        try writeOptionalBool(&writer.writer, &has_query, "include_adult", query.include_adult);
        try writeOptionalBool(&writer.writer, &has_query, "include_null_first_air_dates", query.include_null_first_air_dates);
        try writeOptionalU32(&writer.writer, &has_query, "page", query.page);
        try writeOptionalBool(&writer.writer, &has_query, "screened_theatrically", query.screened_theatrically);
        try writeOptionalString(&writer.writer, &has_query, "sort_by", query.sort_by);
        try writeOptionalString(&writer.writer, &has_query, "timezone", query.timezone);
        try writeOptionalF32(&writer.writer, &has_query, "vote_average.gte", query.vote_average_gte);
        try writeOptionalF32(&writer.writer, &has_query, "vote_average.lte", query.vote_average_lte);
        try writeOptionalU32(&writer.writer, &has_query, "vote_count.gte", query.vote_count_gte);
        try writeOptionalU32(&writer.writer, &has_query, "vote_count.lte", query.vote_count_lte);
        try writeOptionalString(&writer.writer, &has_query, "watch_region", query.watch_region);
        try writeOptionalString(&writer.writer, &has_query, "with_companies", query.with_companies);
        try writeOptionalString(&writer.writer, &has_query, "with_genres", query.with_genres);
        try writeOptionalString(&writer.writer, &has_query, "with_keywords", query.with_keywords);
        try writeOptionalU32(&writer.writer, &has_query, "with_networks", query.with_networks);
        try writeOptionalString(&writer.writer, &has_query, "with_origin_country", query.with_origin_country);
        try writeOptionalString(&writer.writer, &has_query, "with_original_language", query.with_original_language);
        try writeOptionalU32(&writer.writer, &has_query, "with_runtime.gte", query.with_runtime_gte);
        try writeOptionalU32(&writer.writer, &has_query, "with_runtime.lte", query.with_runtime_lte);
        try writeOptionalString(&writer.writer, &has_query, "with_status", query.with_status);
        try writeOptionalString(&writer.writer, &has_query, "with_watch_monetization_types", query.with_watch_monetization_types);
        try writeOptionalString(&writer.writer, &has_query, "with_watch_providers", query.with_watch_providers);
        try writeOptionalString(&writer.writer, &has_query, "without_companies", query.without_companies);
        try writeOptionalString(&writer.writer, &has_query, "without_genres", query.without_genres);
        try writeOptionalString(&writer.writer, &has_query, "without_keywords", query.without_keywords);
        try writeOptionalString(&writer.writer, &has_query, "without_watch_providers", query.without_watch_providers);
        try writeOptionalString(&writer.writer, &has_query, "with_type", query.with_type);
        try writeExtraParams(&writer.writer, &has_query, query.extra_params);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildFindUrl(
        self: *Client,
        external_id: []const u8,
        external_source: types.FindExternalSource,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.writeAll(api_base_url ++ "/find/");
        try writer.writer.writeAll(external_id);
        try writeQueryString(&writer.writer, &has_query, "external_source", external_source.value());
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildTrendingUrl(
        self: *Client,
        media_kind: []const u8,
        time_window: types.TrendingTimeWindow,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print(
            "{s}/trending/{s}/{s}",
            .{ api_base_url, media_kind, time_window.value() },
        );
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildMovieListUrl(self: *Client, list_kind: []const u8, query: types.MovieListQuery) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print("{s}/movie/{s}", .{ api_base_url, list_kind });
        try writeOptionalU32(&writer.writer, &has_query, "page", query.page);
        try writeOptionalString(&writer.writer, &has_query, "region", query.region);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildTvListUrl(self: *Client, list_kind: []const u8, query: types.TvListQuery) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print("{s}/tv/{s}", .{ api_base_url, list_kind });
        try writeOptionalU32(&writer.writer, &has_query, "page", query.page);
        try writeOptionalString(&writer.writer, &has_query, "timezone", query.timezone);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildMovieSubresourceUrl(
        self: *Client,
        movie_id: u64,
        suffix: []const u8,
        page: ?u32,
        include_image_language: ?[]const u8,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print("{s}/movie/{d}/{s}", .{ api_base_url, movie_id, suffix });
        try writeOptionalU32(&writer.writer, &has_query, "page", page);
        try writeOptionalString(&writer.writer, &has_query, "include_image_language", include_image_language);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildTvSubresourceUrl(
        self: *Client,
        series_id: u64,
        suffix: []const u8,
        page: ?u32,
        include_image_language: ?[]const u8,
        include_video_language: ?[]const u8,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print("{s}/tv/{d}/{s}", .{ api_base_url, series_id, suffix });
        try writeOptionalU32(&writer.writer, &has_query, "page", page);
        try writeOptionalString(&writer.writer, &has_query, "include_image_language", include_image_language);
        try writeOptionalString(&writer.writer, &has_query, "include_video_language", include_video_language);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildWatchProvidersUrl(self: *Client, media_kind: []const u8, watch_region: ?[]const u8) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print("{s}/watch/providers/{s}", .{ api_base_url, media_kind });
        try writeOptionalString(&writer.writer, &has_query, "watch_region", watch_region);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildWatchProviderRegionsUrl(self: *Client) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.writeAll(path_watch_provider_regions);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildPeoplePopularUrl(self: *Client, options: types.SearchQuery) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.writeAll(api_base_url ++ "/person/popular");
        try writeOptionalU32(&writer.writer, &has_query, "page", options.page);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildCollectionUrl(
        self: *Client,
        collection_id: u64,
        suffix: ?[]const u8,
        include_image_language: ?[]const u8,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try self.writeResourcePath(&writer.writer, resource_collection, collection_id, suffix);
        try writeOptionalString(&writer.writer, &has_query, "include_image_language", include_image_language);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildCompanyUrl(self: *Client, company_id: u64, suffix: ?[]const u8) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try self.writeResourcePath(&writer.writer, resource_company, company_id, suffix);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildKeywordUrl(
        self: *Client,
        keyword_id: u64,
        suffix: ?[]const u8,
        options: types.SearchQuery,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try self.writeResourcePath(&writer.writer, resource_keyword, keyword_id, suffix);
        try writeOptionalBool(&writer.writer, &has_query, "include_adult", options.include_adult);
        try writeOptionalU32(&writer.writer, &has_query, "page", options.page);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildGenreMoviesUrl(
        self: *Client,
        genre_id: u64,
        options: types.SearchQuery,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        var has_query = false;
        try writer.writer.print("{s}/genre/{d}/movies", .{ api_base_url, genre_id });
        try writeOptionalBool(&writer.writer, &has_query, "include_adult", options.include_adult);
        try writeOptionalU32(&writer.writer, &has_query, "page", options.page);
        try self.writeOptionalLanguage(&writer.writer, &has_query);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildDetailsUrl(
        self: *Client,
        media_type: types.MediaType,
        id: u64,
        append_values: []const []const u8,
        include_image_language: ?[]const u8,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try writer.writer.print(
            "{s}/{s}/{d}",
            .{ api_base_url, media_type.detailsPath(), id },
        );

        try self.writeDetailsQuery(&writer.writer, append_values, include_image_language);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildTvSeasonDetailsUrl(
        self: *Client,
        series_id: u64,
        season_number: u32,
        append_values: []const []const u8,
        include_image_language: ?[]const u8,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try writer.writer.print(
            "{s}/tv/{d}/season/{d}",
            .{ api_base_url, series_id, season_number },
        );
        try self.writeDetailsQuery(&writer.writer, append_values, include_image_language);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildTvEpisodeDetailsUrl(
        self: *Client,
        series_id: u64,
        season_number: u32,
        episode_number: u32,
        append_values: []const []const u8,
        include_image_language: ?[]const u8,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try writer.writer.print(
            "{s}/tv/{d}/season/{d}/episode/{d}",
            .{ api_base_url, series_id, season_number, episode_number },
        );
        try self.writeDetailsQuery(&writer.writer, append_values, include_image_language);

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildLanguageAwareUrl(self: *Client, base_url: []const u8) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try writer.writer.writeAll(base_url);
        if (self.config.language) |language| {
            try writer.writer.writeAll("?language=");
            try std.Uri.Component.formatQuery(.{ .raw = language }, &writer.writer);
        }

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildChangesUrl(
        self: *Client,
        scope: []const u8,
        query: types.ChangesQuery,
    ) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try writer.writer.print("{s}/{s}/changes", .{ api_base_url, scope });

        var wrote_query = false;

        if (query.start_date) |start_date| {
            try writer.writer.writeAll(if (wrote_query) "&start_date=" else "?start_date=");
            try std.Uri.Component.formatQuery(.{ .raw = start_date }, &writer.writer);
            wrote_query = true;
        }

        if (query.end_date) |end_date| {
            try writer.writer.writeAll(if (wrote_query) "&end_date=" else "?end_date=");
            try std.Uri.Component.formatQuery(.{ .raw = end_date }, &writer.writer);
            wrote_query = true;
        }

        if (query.page) |page| {
            if (wrote_query) {
                try writer.writer.print("&page={d}", .{page});
            } else {
                try writer.writer.print("?page={d}", .{page});
            }
        }

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildPersonDetailsUrl(self: *Client, person_id: u64, append_values: []const []const u8) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try writer.writer.print("{s}/{s}/{d}", .{ api_base_url, resource_person, person_id });

        var wrote_query = false;
        if (append_values.len > 0) {
            try writer.writer.writeAll("?append_to_response=");
            wrote_query = true;
            for (append_values, 0..) |value, index| {
                if (index != 0) try writer.writer.writeAll(",");
                try writeAppendValue(&writer.writer, value);
            }
        }

        if (self.config.language) |language| {
            try writer.writer.writeAll(if (wrote_query) "&language=" else "?language=");
            try std.Uri.Component.formatQuery(.{ .raw = language }, &writer.writer);
        }

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildPersonLanguageUrl(self: *Client, person_id: u64, suffix: []const u8) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try self.writeResourcePath(&writer.writer, resource_person, person_id, suffix);
        if (self.config.language) |language| {
            try writer.writer.writeAll("?language=");
            try std.Uri.Component.formatQuery(.{ .raw = language }, &writer.writer);
        }

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildPersonPageUrl(self: *Client, person_id: u64, suffix: []const u8, page: ?u32) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try self.writeResourcePath(&writer.writer, resource_person, person_id, suffix);
        if (page) |value| {
            try writer.writer.print("?page={d}", .{value});
        }

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn buildPersonChangesUrl(self: *Client, person_id: u64, query: types.ChangesQuery) ![]u8 {
        var writer = std.Io.Writer.Allocating.init(self.allocator);
        errdefer writer.deinit();

        try writer.writer.print("{s}/{s}/{d}/changes", .{ api_base_url, resource_person, person_id });

        var wrote_query = false;
        if (query.start_date) |start_date| {
            try writer.writer.writeAll(if (wrote_query) "&start_date=" else "?start_date=");
            try std.Uri.Component.formatQuery(.{ .raw = start_date }, &writer.writer);
            wrote_query = true;
        }
        if (query.end_date) |end_date| {
            try writer.writer.writeAll(if (wrote_query) "&end_date=" else "?end_date=");
            try std.Uri.Component.formatQuery(.{ .raw = end_date }, &writer.writer);
            wrote_query = true;
        }
        if (query.page) |page| {
            if (wrote_query) {
                try writer.writer.print("&page={d}", .{page});
            } else {
                try writer.writer.print("?page={d}", .{page});
            }
        }

        var list = writer.toArrayList();
        return try list.toOwnedSlice(self.allocator);
    }

    fn writeOptionalLanguage(self: *Client, writer: *std.Io.Writer, has_query: *bool) !void {
        try writeOptionalString(writer, has_query, "language", self.config.language);
    }

    fn writeQuerySeparator(writer: *std.Io.Writer, has_query: *bool) !void {
        try writer.writeByte(if (has_query.*) '&' else '?');
        has_query.* = true;
    }

    fn writeResourcePath(
        self: *Client,
        writer: *std.Io.Writer,
        resource: []const u8,
        id: u64,
        suffix: ?[]const u8,
    ) !void {
        _ = self;
        if (suffix) |value|
            try writer.print("{s}/{s}/{d}/{s}", .{ api_base_url, resource, id, value })
        else
            try writer.print("{s}/{s}/{d}", .{ api_base_url, resource, id });
    }

    fn writeQueryString(writer: *std.Io.Writer, has_query: *bool, name: []const u8, value: []const u8) !void {
        try writeQuerySeparator(writer, has_query);
        try writer.print("{s}=", .{name});
        try std.Uri.Component.formatQuery(.{ .raw = value }, writer);
    }

    fn writeOptionalString(writer: *std.Io.Writer, has_query: *bool, name: []const u8, value: ?[]const u8) !void {
        if (value) |raw| {
            try writeQueryString(writer, has_query, name, raw);
        }
    }

    fn writeOptionalBool(writer: *std.Io.Writer, has_query: *bool, name: []const u8, value: ?bool) !void {
        if (value) |raw| {
            try writeQuerySeparator(writer, has_query);
            try writer.print("{s}={s}", .{ name, if (raw) "true" else "false" });
        }
    }

    fn writeOptionalU32(writer: *std.Io.Writer, has_query: *bool, name: []const u8, value: ?u32) !void {
        if (value) |raw| {
            try writeQuerySeparator(writer, has_query);
            try writer.print("{s}={d}", .{ name, raw });
        }
    }

    fn writeOptionalF32(writer: *std.Io.Writer, has_query: *bool, name: []const u8, value: ?f32) !void {
        if (value) |raw| {
            try writeQuerySeparator(writer, has_query);
            try writer.print("{s}={}", .{ name, raw });
        }
    }

    fn firstFindResultId(response: types.FindResponse, kind: types.FindResultKind) ?u64 {
        const results = switch (kind) {
            .movie => response.movie_results,
            .person => response.person_results,
            .tv => response.tv_results,
            .tv_episode => response.tv_episode_results,
            .tv_season => response.tv_season_results,
        };

        if (results.len == 0) return null;
        return results[0].id;
    }

    fn writeExtraParams(writer: *std.Io.Writer, has_query: *bool, params: []const types.QueryParam) !void {
        for (params) |param| {
            try writeQueryString(writer, has_query, param.name, param.value);
        }
    }

    fn writeDetailsQuery(
        self: *Client,
        writer: *std.Io.Writer,
        append_values: []const []const u8,
        include_image_language: ?[]const u8,
    ) !void {
        var wrote_query = false;

        if (append_values.len > 0) {
            try writer.writeAll("?append_to_response=");
            wrote_query = true;
            for (append_values, 0..) |value, index| {
                if (index != 0) try writer.writeAll(",");
                try writeAppendValue(writer, value);
            }
        }

        if (include_image_language) |value| {
            try writer.writeAll(
                if (wrote_query) "&include_image_language=" else "?include_image_language=",
            );
            try std.Uri.Component.formatQuery(.{ .raw = value }, writer);
            wrote_query = true;
        }

        if (self.config.language) |language| {
            try writer.writeAll(if (wrote_query) "&language=" else "?language=");
            try std.Uri.Component.formatQuery(.{ .raw = language }, writer);
        }
    }

    fn writeAppendValue(writer: *std.Io.Writer, value: []const u8) !void {
        var start: usize = 0;
        for (value, 0..) |char, index| {
            if (isAppendValueChar(char)) continue;
            try writer.print("{s}%{X:0>2}", .{ value[start..index], char });
            start = index + 1;
        }
        try writer.writeAll(value[start..]);
    }

    fn isAppendValueChar(char: u8) bool {
        return std.ascii.isAlphanumeric(char) or char == '-' or char == '.' or char == '_' or char == '~';
    }
};
