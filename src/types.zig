const std = @import("std");

pub const MediaType = enum {
    movie,
    series,

    pub fn searchBaseUrl(self: MediaType, movie_search_base_url: []const u8, series_search_base_url: []const u8) []const u8 {
        return switch (self) {
            .movie => movie_search_base_url,
            .series => series_search_base_url,
        };
    }

    pub fn detailsPath(self: MediaType) []const u8 {
        return switch (self) {
            .movie => "movie",
            .series => "tv",
        };
    }
};

pub fn PagedResponse(comptime T: type) type {
    return struct {
        page: u32 = 0,
        results: []const T = &.{},
        total_pages: u32 = 0,
        total_results: u32 = 0,
    };
}

pub const QueryParam = struct {
    name: []const u8,
    value: []const u8,
};

pub const SearchQuery = struct {
    include_adult: ?bool = null,
    page: ?u32 = null,
};

pub const MovieListQuery = struct {
    page: ?u32 = null,
    region: ?[]const u8 = null,
};

pub const TvListQuery = struct {
    page: ?u32 = null,
    timezone: ?[]const u8 = null,
};

pub const SearchMovieQuery = struct {
    year: ?u32 = null,
    include_adult: ?bool = null,
    page: ?u32 = null,
};

pub const SearchTvQuery = struct {
    year: ?u32 = null,
    first_air_date_year: ?u32 = null,
    include_adult: ?bool = null,
    page: ?u32 = null,
};

pub const DiscoverMovieQuery = struct {
    certification: ?[]const u8 = null,
    certification_country: ?[]const u8 = null,
    certification_gte: ?[]const u8 = null,
    certification_lte: ?[]const u8 = null,
    include_adult: ?bool = null,
    include_video: ?bool = null,
    page: ?u32 = null,
    primary_release_year: ?u32 = null,
    primary_release_date_gte: ?[]const u8 = null,
    primary_release_date_lte: ?[]const u8 = null,
    region: ?[]const u8 = null,
    release_date_gte: ?[]const u8 = null,
    release_date_lte: ?[]const u8 = null,
    sort_by: ?[]const u8 = null,
    vote_average_gte: ?f32 = null,
    vote_average_lte: ?f32 = null,
    vote_count_gte: ?u32 = null,
    vote_count_lte: ?u32 = null,
    watch_region: ?[]const u8 = null,
    with_cast: ?[]const u8 = null,
    with_companies: ?[]const u8 = null,
    with_crew: ?[]const u8 = null,
    with_genres: ?[]const u8 = null,
    with_keywords: ?[]const u8 = null,
    with_origin_country: ?[]const u8 = null,
    with_original_language: ?[]const u8 = null,
    with_people: ?[]const u8 = null,
    with_release_type: ?[]const u8 = null,
    with_runtime_gte: ?u32 = null,
    with_runtime_lte: ?u32 = null,
    with_watch_monetization_types: ?[]const u8 = null,
    with_watch_providers: ?[]const u8 = null,
    without_companies: ?[]const u8 = null,
    without_genres: ?[]const u8 = null,
    without_keywords: ?[]const u8 = null,
    without_watch_providers: ?[]const u8 = null,
    year: ?u32 = null,
    extra_params: []const QueryParam = &.{},
};

pub const DiscoverTvQuery = struct {
    air_date_gte: ?[]const u8 = null,
    air_date_lte: ?[]const u8 = null,
    first_air_date_year: ?u32 = null,
    first_air_date_gte: ?[]const u8 = null,
    first_air_date_lte: ?[]const u8 = null,
    include_adult: ?bool = null,
    include_null_first_air_dates: ?bool = null,
    page: ?u32 = null,
    screened_theatrically: ?bool = null,
    sort_by: ?[]const u8 = null,
    timezone: ?[]const u8 = null,
    vote_average_gte: ?f32 = null,
    vote_average_lte: ?f32 = null,
    vote_count_gte: ?u32 = null,
    vote_count_lte: ?u32 = null,
    watch_region: ?[]const u8 = null,
    with_companies: ?[]const u8 = null,
    with_genres: ?[]const u8 = null,
    with_keywords: ?[]const u8 = null,
    with_networks: ?u32 = null,
    with_origin_country: ?[]const u8 = null,
    with_original_language: ?[]const u8 = null,
    with_runtime_gte: ?u32 = null,
    with_runtime_lte: ?u32 = null,
    with_status: ?[]const u8 = null,
    with_watch_monetization_types: ?[]const u8 = null,
    with_watch_providers: ?[]const u8 = null,
    without_companies: ?[]const u8 = null,
    without_genres: ?[]const u8 = null,
    without_keywords: ?[]const u8 = null,
    without_watch_providers: ?[]const u8 = null,
    with_type: ?[]const u8 = null,
    extra_params: []const QueryParam = &.{},
};

pub const FindExternalSource = enum {
    imdb_id,
    facebook_id,
    instagram_id,
    tvdb_id,
    tiktok_id,
    twitter_id,
    wikidata_id,
    youtube_id,

    pub fn value(self: FindExternalSource) []const u8 {
        return @tagName(self);
    }
};

pub const TrendingTimeWindow = enum {
    day,
    week,

    pub fn value(self: TrendingTimeWindow) []const u8 {
        return @tagName(self);
    }
};

pub const SearchResult = struct {
    adult: ?bool = null,
    backdrop_path: ?[]const u8 = null,
    first_air_date: ?[]const u8 = null,
    gender: ?u32 = null,
    genre_ids: []const u64 = &.{},
    id: u64 = 0,
    known_for: []const std.json.Value = &.{},
    known_for_department: ?[]const u8 = null,
    media_type: ?[]const u8 = null,
    name: ?[]const u8 = null,
    origin_country: []const []const u8 = &.{},
    original_language: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    original_title: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    popularity: ?f32 = null,
    poster_path: ?[]const u8 = null,
    profile_path: ?[]const u8 = null,
    release_date: ?[]const u8 = null,
    title: ?[]const u8 = null,
    video: ?bool = null,
    vote_average: ?f32 = null,
    vote_count: ?u64 = null,
};

pub const SearchResponse = PagedResponse(SearchResult);

pub const ListDates = struct {
    maximum: ?[]const u8 = null,
    minimum: ?[]const u8 = null,
};

pub const MovieListResponse = struct {
    dates: ?ListDates = null,
    page: u32 = 0,
    results: []const SearchResult = &.{},
    total_pages: u32 = 0,
    total_results: u32 = 0,
};

pub const FindResponse = struct {
    movie_results: []const SearchResult = &.{},
    person_results: []const SearchResult = &.{},
    tv_results: []const SearchResult = &.{},
    tv_episode_results: []const SearchResult = &.{},
    tv_season_results: []const SearchResult = &.{},
};

pub const FindResultKind = enum {
    movie,
    person,
    tv,
    tv_episode,
    tv_season,
};

pub const Genre = struct {
    id: u64 = 0,
    name: []const u8 = "",
};

pub const GenreList = struct {
    genres: []Genre = &.{},
};

pub const Certification = struct {
    certification: []const u8 = "",
    meaning: []const u8 = "",
    order: u32 = 0,
};

pub const CertificationMap = std.json.ArrayHashMap([]const Certification);

pub const CertificationList = struct {
    certifications: CertificationMap = .{},

    pub fn byCountry(self: *const CertificationList, iso_3166_1: []const u8) ?[]const Certification {
        return self.certifications.map.get(iso_3166_1);
    }
};

pub const Network = struct {
    id: u64 = 0,
    logo_path: ?[]const u8 = null,
    name: []const u8 = "",
    origin_country: []const u8 = "",
};

pub const NetworkDetails = struct {
    headquarters: ?[]const u8 = null,
    homepage: ?[]const u8 = null,
    id: u64 = 0,
    logo_path: ?[]const u8 = null,
    name: ?[]const u8 = null,
    origin_country: ?[]const u8 = null,
};

pub const NetworkAlternativeName = struct {
    name: ?[]const u8 = null,
    type: ?[]const u8 = null,
};

pub const NetworkAlternativeNames = struct {
    id: u64 = 0,
    results: []const NetworkAlternativeName = &.{},
};

pub const NetworkLogo = struct {
    aspect_ratio: f32 = 0,
    file_path: ?[]const u8 = null,
    file_type: ?[]const u8 = null,
    height: u32 = 0,
    id: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
    width: u32 = 0,
};

pub const NetworkImages = struct {
    id: u64 = 0,
    logos: []const NetworkLogo = &.{},
};

pub const Image = struct {
    height: u32 = 0,
    file_path: []const u8 = "",
    width: u32 = 0,
};

pub const Images = struct {
    backdrops: []const Image = &.{},
    logos: []const Image = &.{},
    posters: []const Image = &.{},
};

pub const MediaImages = struct {
    id: u64 = 0,
    backdrops: []const Image = &.{},
    logos: []const Image = &.{},
    posters: []const Image = &.{},
};

pub const Video = struct {
    iso_639_1: ?[]const u8 = null,
    iso_3166_1: ?[]const u8 = null,
    name: ?[]const u8 = null,
    key: ?[]const u8 = null,
    site: ?[]const u8 = null,
    size: ?u32 = null,
    type: ?[]const u8 = null,
    official: ?bool = null,
    published_at: ?[]const u8 = null,
    id: ?[]const u8 = null,
};

pub const VideosResponse = struct {
    id: u64 = 0,
    results: []const Video = &.{},
};

pub const WatchProvider = struct {
    display_priorities: ?std.json.Value = null,
    display_priority: ?u32 = null,
    logo_path: ?[]const u8 = null,
    provider_name: ?[]const u8 = null,
    provider_id: ?u32 = null,
};

pub const WatchProviderListResponse = struct {
    results: []const WatchProvider = &.{},
};

pub const WatchProviderRegion = struct {
    iso_3166_1: ?[]const u8 = null,
    english_name: ?[]const u8 = null,
    native_name: ?[]const u8 = null,
};

pub const WatchProviderRegionsResponse = struct {
    results: []const WatchProviderRegion = &.{},
};

pub const CastCredit = struct {
    adult: ?bool = null,
    gender: ?u32 = null,
    id: u64 = 0,
    known_for_department: ?[]const u8 = null,
    name: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    popularity: ?f32 = null,
    profile_path: ?[]const u8 = null,
    cast_id: ?u32 = null,
    character: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    order: ?u32 = null,
};

pub const CrewCredit = struct {
    adult: ?bool = null,
    gender: ?u32 = null,
    id: u64 = 0,
    known_for_department: ?[]const u8 = null,
    name: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    popularity: ?f32 = null,
    profile_path: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    department: ?[]const u8 = null,
    job: ?[]const u8 = null,
};

pub const CreditsResponse = struct {
    id: u64 = 0,
    cast: []const CastCredit = &.{},
    crew: []const CrewCredit = &.{},
};

pub const Season = struct {
    air_date: ?[]const u8 = null,
    episode_count: u32 = 0,
    id: u64 = 0,
    overview: ?[]const u8 = null,
    poster_path: ?[]const u8 = null,
    season_number: u32 = 0,
    vote_average: f32 = 0,
};

pub const Episode = struct {
    air_date: ?[]const u8 = null,
    episode_type: ?[]const u8 = null,
    name: ?[]const u8 = null,
    episode_number: u32 = 0,
    overview: ?[]const u8 = null,
    season_number: u32 = 0,
    still_path: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const ExternalIds = struct {
    imdb_id: ?[]const u8 = null,
};

pub const ImageKind = enum {
    backdrop,
    logo,
    poster,
    profile,
    still,
};

pub const ConfigurationImages = struct {
    base_url: []const u8 = "",
    secure_base_url: []const u8 = "",
    backdrop_sizes: []const []const u8 = &.{},
    logo_sizes: []const []const u8 = &.{},
    poster_sizes: []const []const u8 = &.{},
    profile_sizes: []const []const u8 = &.{},
    still_sizes: []const []const u8 = &.{},

    pub fn sizesFor(self: ConfigurationImages, kind: ImageKind) []const []const u8 {
        return switch (kind) {
            .backdrop => self.backdrop_sizes,
            .logo => self.logo_sizes,
            .poster => self.poster_sizes,
            .profile => self.profile_sizes,
            .still => self.still_sizes,
        };
    }

    pub fn supportsSize(self: ConfigurationImages, kind: ImageKind, size: []const u8) bool {
        for (self.sizesFor(kind)) |candidate| {
            if (std.mem.eql(u8, candidate, size)) return true;
        }
        return false;
    }

    pub fn imageUrl(
        self: ConfigurationImages,
        allocator: std.mem.Allocator,
        kind: ImageKind,
        size: []const u8,
        file_path: ?[]const u8,
    ) (std.mem.Allocator.Error || error{InvalidImageSize})!?[]u8 {
        const path = file_path orelse return null;
        if (!self.supportsSize(kind, size)) return error.InvalidImageSize;
        const full_url = try std.fmt.allocPrint(allocator, "{s}{s}{s}", .{
            self.secure_base_url,
            size,
            path,
        });
        return @as(?[]u8, full_url);
    }

    pub fn backdropUrl(
        self: ConfigurationImages,
        allocator: std.mem.Allocator,
        size: []const u8,
        file_path: ?[]const u8,
    ) (std.mem.Allocator.Error || error{InvalidImageSize})!?[]u8 {
        return self.imageUrl(allocator, .backdrop, size, file_path);
    }

    pub fn logoUrl(
        self: ConfigurationImages,
        allocator: std.mem.Allocator,
        size: []const u8,
        file_path: ?[]const u8,
    ) (std.mem.Allocator.Error || error{InvalidImageSize})!?[]u8 {
        return self.imageUrl(allocator, .logo, size, file_path);
    }

    pub fn posterUrl(
        self: ConfigurationImages,
        allocator: std.mem.Allocator,
        size: []const u8,
        file_path: ?[]const u8,
    ) (std.mem.Allocator.Error || error{InvalidImageSize})!?[]u8 {
        return self.imageUrl(allocator, .poster, size, file_path);
    }

    pub fn profileUrl(
        self: ConfigurationImages,
        allocator: std.mem.Allocator,
        size: []const u8,
        file_path: ?[]const u8,
    ) (std.mem.Allocator.Error || error{InvalidImageSize})!?[]u8 {
        return self.imageUrl(allocator, .profile, size, file_path);
    }

    pub fn stillUrl(
        self: ConfigurationImages,
        allocator: std.mem.Allocator,
        size: []const u8,
        file_path: ?[]const u8,
    ) (std.mem.Allocator.Error || error{InvalidImageSize})!?[]u8 {
        return self.imageUrl(allocator, .still, size, file_path);
    }
};

pub const ConfigurationDetails = struct {
    images: ConfigurationImages = .{},
    change_keys: []const []const u8 = &.{},
};

pub const ConfigurationCountry = struct {
    iso_3166_1: ?[]const u8 = null,
    english_name: ?[]const u8 = null,
    native_name: ?[]const u8 = null,
};

pub const ConfigurationCountries = []const ConfigurationCountry;

pub const ConfigurationJob = struct {
    department: ?[]const u8 = null,
    jobs: []const []const u8 = &.{},
};

pub const ConfigurationJobs = []const ConfigurationJob;

pub const ConfigurationLanguage = struct {
    iso_639_1: ?[]const u8 = null,
    english_name: ?[]const u8 = null,
    name: ?[]const u8 = null,
};

pub const ConfigurationLanguages = []const ConfigurationLanguage;
pub const ConfigurationPrimaryTranslations = []const []const u8;

pub const ConfigurationTimezone = struct {
    iso_3166_1: ?[]const u8 = null,
    zones: []const []const u8 = &.{},
};

pub const ConfigurationTimezones = []const ConfigurationTimezone;

pub const ReviewAuthorDetails = struct {
    avatar_path: ?[]const u8 = null,
    name: ?[]const u8 = null,
    rating: ?f32 = null,
    username: ?[]const u8 = null,
};

pub const ReviewDetails = struct {
    author: ?[]const u8 = null,
    author_details: ?ReviewAuthorDetails = null,
    content: ?[]const u8 = null,
    created_at: ?[]const u8 = null,
    id: ?[]const u8 = null,
    iso_639_1: ?[]const u8 = null,
    media_id: ?u64 = null,
    media_title: ?[]const u8 = null,
    media_type: ?[]const u8 = null,
    updated_at: ?[]const u8 = null,
    url: ?[]const u8 = null,
};

pub const ReviewSummary = struct {
    author: ?[]const u8 = null,
    author_details: ?ReviewAuthorDetails = null,
    content: ?[]const u8 = null,
    created_at: ?[]const u8 = null,
    id: ?[]const u8 = null,
    updated_at: ?[]const u8 = null,
    url: ?[]const u8 = null,
};

pub const ReviewsResponse = PagedResponse(ReviewSummary);

pub const ChangesQuery = struct {
    start_date: ?[]const u8 = null,
    end_date: ?[]const u8 = null,
    page: ?u32 = null,
};

pub const ChangeListEntry = struct {
    adult: ?bool = null,
    id: u64 = 0,
};

pub const ChangesList = PagedResponse(ChangeListEntry);

pub const PersonDetails = struct {
    adult: bool = false,
    also_known_as: []const []const u8 = &.{},
    biography: ?[]const u8 = null,
    birthday: ?[]const u8 = null,
    deathday: ?[]const u8 = null,
    gender: ?u32 = null,
    homepage: ?[]const u8 = null,
    id: u64 = 0,
    imdb_id: ?[]const u8 = null,
    known_for_department: ?[]const u8 = null,
    name: ?[]const u8 = null,
    place_of_birth: ?[]const u8 = null,
    popularity: f32 = 0,
    profile_path: ?[]const u8 = null,
};

pub const CollectionDetails = struct {
    id: u64 = 0,
    name: ?[]const u8 = null,
    original_language: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    poster_path: ?[]const u8 = null,
    backdrop_path: ?[]const u8 = null,
    parts: []const SearchResult = &.{},
};

pub const CollectionTranslation = struct {
    iso_3166_1: ?[]const u8 = null,
    iso_639_1: ?[]const u8 = null,
    name: ?[]const u8 = null,
    english_name: ?[]const u8 = null,
    data: ?std.json.Value = null,
};

pub const CollectionTranslations = struct {
    id: u64 = 0,
    translations: []const CollectionTranslation = &.{},
};

pub const CompanyDetails = struct {
    description: ?[]const u8 = null,
    headquarters: ?[]const u8 = null,
    homepage: ?[]const u8 = null,
    id: u64 = 0,
    logo_path: ?[]const u8 = null,
    name: ?[]const u8 = null,
    origin_country: ?[]const u8 = null,
    parent_company: ?std.json.Value = null,
};

pub const CompanyAlternativeNames = struct {
    id: u64 = 0,
    results: []const NetworkAlternativeName = &.{},
};

pub const CompanyImages = struct {
    id: u64 = 0,
    logos: []const NetworkLogo = &.{},
};

pub const KeywordDetails = struct {
    id: u64 = 0,
    name: ?[]const u8 = null,
};

pub const KeywordMoviesResponse = struct {
    id: u64 = 0,
    page: u32 = 0,
    results: []const SearchResult = &.{},
    total_pages: u32 = 0,
    total_results: u32 = 0,
};

pub const PersonExternalIds = struct {
    facebook_id: ?[]const u8 = null,
    freebase_id: ?[]const u8 = null,
    freebase_mid: ?[]const u8 = null,
    id: u64 = 0,
    imdb_id: ?[]const u8 = null,
    instagram_id: ?[]const u8 = null,
    tiktok_id: ?[]const u8 = null,
    tvrage_id: ?u64 = null,
    twitter_id: ?[]const u8 = null,
    wikidata_id: ?[]const u8 = null,
    youtube_id: ?[]const u8 = null,
};

pub const PersonImage = struct {
    aspect_ratio: f32 = 0,
    file_path: ?[]const u8 = null,
    height: u32 = 0,
    iso_639_1: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
    width: u32 = 0,
};

pub const PersonImages = struct {
    id: u64 = 0,
    profiles: []const PersonImage = &.{},
};

pub const PersonChange = struct {
    key: ?[]const u8 = null,
    items: []const std.json.Value = &.{},
};

pub const PersonChanges = struct {
    changes: []const PersonChange = &.{},
};

pub const PersonCombinedCastCredit = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    character: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    episode_count: ?u32 = null,
    first_air_date: ?[]const u8 = null,
    genre_ids: []const u64 = &.{},
    id: u64 = 0,
    media_type: ?[]const u8 = null,
    name: ?[]const u8 = null,
    order: ?u32 = null,
    origin_country: []const []const u8 = &.{},
    original_language: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    original_title: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    popularity: f32 = 0,
    poster_path: ?[]const u8 = null,
    release_date: ?[]const u8 = null,
    title: ?[]const u8 = null,
    video: ?bool = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const PersonCombinedCrewCredit = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    department: ?[]const u8 = null,
    episode_count: ?u32 = null,
    first_air_date: ?[]const u8 = null,
    genre_ids: []const u64 = &.{},
    id: u64 = 0,
    job: ?[]const u8 = null,
    media_type: ?[]const u8 = null,
    name: ?[]const u8 = null,
    origin_country: []const []const u8 = &.{},
    original_language: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    original_title: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    popularity: f32 = 0,
    poster_path: ?[]const u8 = null,
    release_date: ?[]const u8 = null,
    title: ?[]const u8 = null,
    video: ?bool = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const PersonCombinedCredits = struct {
    cast: []const PersonCombinedCastCredit = &.{},
    crew: []const PersonCombinedCrewCredit = &.{},
    id: u64 = 0,
};

pub const PersonMovieCastCredit = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    character: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    genre_ids: []const u64 = &.{},
    id: u64 = 0,
    order: ?u32 = null,
    original_language: ?[]const u8 = null,
    original_title: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    popularity: f32 = 0,
    poster_path: ?[]const u8 = null,
    release_date: ?[]const u8 = null,
    title: ?[]const u8 = null,
    video: ?bool = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const PersonMovieCrewCredit = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    department: ?[]const u8 = null,
    genre_ids: []const u64 = &.{},
    id: u64 = 0,
    job: ?[]const u8 = null,
    original_language: ?[]const u8 = null,
    original_title: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    popularity: f32 = 0,
    poster_path: ?[]const u8 = null,
    release_date: ?[]const u8 = null,
    title: ?[]const u8 = null,
    video: ?bool = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const PersonMovieCredits = struct {
    cast: []const PersonMovieCastCredit = &.{},
    crew: []const PersonMovieCrewCredit = &.{},
    id: u64 = 0,
};

pub const PersonTvCastCredit = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    character: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    episode_count: ?u32 = null,
    first_air_date: ?[]const u8 = null,
    genre_ids: []const u64 = &.{},
    id: u64 = 0,
    name: ?[]const u8 = null,
    origin_country: []const []const u8 = &.{},
    original_language: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    popularity: f32 = 0,
    poster_path: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const PersonTvCrewCredit = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    department: ?[]const u8 = null,
    episode_count: ?u32 = null,
    first_air_date: ?[]const u8 = null,
    genre_ids: []const u64 = &.{},
    id: u64 = 0,
    job: ?[]const u8 = null,
    name: ?[]const u8 = null,
    origin_country: []const []const u8 = &.{},
    original_language: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    popularity: f32 = 0,
    poster_path: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const PersonTvCredits = struct {
    cast: []const PersonTvCastCredit = &.{},
    crew: []const PersonTvCrewCredit = &.{},
    id: u64 = 0,
};

pub const PersonTaggedImageResult = struct {
    aspect_ratio: f32 = 0,
    file_path: ?[]const u8 = null,
    height: u32 = 0,
    id: ?[]const u8 = null,
    image_type: ?[]const u8 = null,
    iso_639_1: ?[]const u8 = null,
    media: ?std.json.Value = null,
    media_type: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
    width: u32 = 0,
};

pub const PersonTaggedImages = struct {
    id: u64 = 0,
    page: u32 = 0,
    results: []const PersonTaggedImageResult = &.{},
    total_pages: u32 = 0,
    total_results: u32 = 0,
};

pub const PersonTranslation = struct {
    data: ?std.json.Value = null,
    english_name: ?[]const u8 = null,
    iso_3166_1: ?[]const u8 = null,
    iso_639_1: ?[]const u8 = null,
    name: ?[]const u8 = null,
};

pub const PersonTranslations = struct {
    id: u64 = 0,
    translations: []const PersonTranslation = &.{},
};

pub const TvCrewMember = struct {
    adult: bool = false,
    credit_id: ?[]const u8 = null,
    department: ?[]const u8 = null,
    gender: u32 = 0,
    id: u64 = 0,
    job: ?[]const u8 = null,
    known_for_department: ?[]const u8 = null,
    name: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    popularity: f32 = 0,
    profile_path: ?[]const u8 = null,
};

pub const TvGuestStar = struct {
    adult: bool = false,
    character: ?[]const u8 = null,
    credit_id: ?[]const u8 = null,
    gender: u32 = 0,
    id: u64 = 0,
    known_for_department: ?[]const u8 = null,
    name: ?[]const u8 = null,
    order: u32 = 0,
    original_name: ?[]const u8 = null,
    popularity: f32 = 0,
    profile_path: ?[]const u8 = null,
};

pub const TvEpisodeSummary = struct {
    air_date: ?[]const u8 = null,
    crew: []const TvCrewMember = &.{},
    episode_number: u32 = 0,
    episode_type: ?[]const u8 = null,
    guest_stars: []const TvGuestStar = &.{},
    id: u64 = 0,
    name: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    production_code: ?[]const u8 = null,
    runtime: ?u32 = null,
    season_number: u32 = 0,
    show_id: ?u64 = null,
    still_path: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const TvSeasonDetails = struct {
    _id: ?[]const u8 = null,
    air_date: ?[]const u8 = null,
    episodes: []const TvEpisodeSummary = &.{},
    id: u64 = 0,
    name: ?[]const u8 = null,
    networks: []const Network = &.{},
    overview: ?[]const u8 = null,
    poster_path: ?[]const u8 = null,
    season_number: u32 = 0,
    vote_average: f32 = 0,
};

pub const TvEpisodeDetails = struct {
    air_date: ?[]const u8 = null,
    crew: []const TvCrewMember = &.{},
    episode_number: u32 = 0,
    guest_stars: []const TvGuestStar = &.{},
    id: u64 = 0,
    name: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    production_code: ?[]const u8 = null,
    runtime: ?u32 = null,
    season_number: u32 = 0,
    still_path: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,
};

pub const MovieDetails = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    external_ids: ?ExternalIds = null,
    genres: []Genre = &.{},
    id: u64 = 0,
    images: ?Images = null,
    original_language: ?[]const u8 = null,
    original_title: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    poster_path: ?[]const u8 = null,
    release_date: ?[]const u8 = null,
    runtime: ?u32 = null,
    status: ?[]const u8 = null,
    title: ?[]const u8 = null,
    video: ?bool = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,

    pub fn displayTitle(self: MovieDetails) ?[]const u8 {
        return self.title orelse self.original_title;
    }
};

pub const TvDetails = struct {
    adult: bool = false,
    backdrop_path: ?[]const u8 = null,
    external_ids: ?ExternalIds = null,
    first_air_date: ?[]const u8 = null,
    genres: []Genre = &.{},
    id: u64,
    images: ?Images = null,
    in_production: ?bool = null,
    last_episode_to_air: ?Episode = null,
    last_air_date: ?[]const u8 = null,
    name: ?[]const u8 = null,
    networks: []const Network = &.{},
    next_episode_to_air: ?Episode = null,
    number_of_episodes: ?u32 = null,
    number_of_seasons: ?u32 = null,
    original_language: ?[]const u8 = null,
    original_name: ?[]const u8 = null,
    overview: ?[]const u8 = null,
    poster_path: ?[]const u8 = null,
    runtime: ?u32 = null,
    seasons: []const Season = &.{},
    status: ?[]const u8 = null,
    type: ?[]const u8 = null,
    vote_average: f32 = 0,
    vote_count: u64 = 0,

    pub fn displayTitle(self: TvDetails) ?[]const u8 {
        return self.name orelse self.original_name;
    }
};
