const std = @import("std");

const Client = @import("client.zig").Client;
const dotenv = @import("dotenv.zig");
const types = @import("types.zig");

test "search url encodes query and optional year" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "it-IT",
    });
    defer client.deinit();

    const url = try client.buildSearchUrl(.movie, "Spider Man", 2002);
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/search/movie?query=Spider%20Man&year=2002&language=it-IT",
        url,
    );
}

test "search movie options url supports page and include_adult" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildSearchMovieUrl("Alien", .{
        .year = 1979,
        .include_adult = false,
        .page = 3,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/search/movie?query=Alien&include_adult=false&page=3&year=1979&language=en-US",
        url,
    );
}

test "search person url encodes include_adult and page" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildSimpleSearchUrl("person", "Brad Pitt", .{
        .include_adult = false,
        .page = 2,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/search/person?query=Brad%20Pitt&include_adult=false&page=2&language=en-US",
        url,
    );
}

test "search collection url encodes page and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildSimpleSearchUrl("collection", "Star Wars", .{
        .page = 2,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/search/collection?query=Star%20Wars&page=2&language=en-US",
        url,
    );
}

test "search company url encodes include_adult and page" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildSimpleSearchUrl("company", "Pixar", .{
        .include_adult = false,
        .page = 3,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/search/company?query=Pixar&include_adult=false&page=3&language=en-US",
        url,
    );
}

test "search keyword url encodes include_adult and page" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildSimpleSearchUrl("keyword", "cyberpunk", .{
        .include_adult = false,
        .page = 4,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/search/keyword?query=cyberpunk&include_adult=false&page=4&language=en-US",
        url,
    );
}

test "search tv options url supports first_air_date_year" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildSearchTvUrl("Battlestar Galactica", .{
        .year = 2004,
        .first_air_date_year = 2004,
        .page = 1,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/search/tv?query=Battlestar%20Galactica&page=1&year=2004&first_air_date_year=2004&language=en-US",
        url,
    );
}

test "genre list url keeps optional language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "it-IT",
    });
    defer client.deinit();

    const url = try client.buildLanguageAwareUrl("https://api.themoviedb.org/3/genre/movie/list");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/genre/movie/list?language=it-IT",
        url,
    );
}

test "genre movies url encodes include_adult page and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildGenreMoviesUrl(28, .{
        .include_adult = false,
        .page = 3,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/genre/28/movies?include_adult=false&page=3&language=en-US",
        url,
    );
}

test "discover movie url supports typed params and extra params" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildDiscoverMovieUrl(.{
        .page = 2,
        .sort_by = "vote_average.desc",
        .with_genres = "28,12",
        .vote_count_gte = 500,
        .include_adult = false,
        .extra_params = &.{.{ .name = "with_text_query", .value = "space opera" }},
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/discover/movie?include_adult=false&page=2&sort_by=vote_average.desc&vote_count.gte=500&with_genres=28,12&with_text_query=space%20opera&language=en-US",
        url,
    );
}

test "discover tv url supports typed params" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildDiscoverTvUrl(.{
        .page = 4,
        .sort_by = "popularity.desc",
        .with_genres = "10765",
        .with_networks = 49,
        .include_null_first_air_dates = false,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/discover/tv?include_null_first_air_dates=false&page=4&sort_by=popularity.desc&with_genres=10765&with_networks=49&language=en-US",
        url,
    );
}

test "find url encodes external id and source" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildFindUrl("tt0133093", .imdb_id);
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/find/tt0133093?external_source=imdb_id&language=en-US",
        url,
    );
}

test "trending url encodes media kind and time window" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "it-IT",
    });
    defer client.deinit();

    const url = try client.buildTrendingUrl("movie", .week);
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/trending/movie/week?language=it-IT",
        url,
    );
}

test "movie list url encodes page region and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildMovieListUrl("now_playing", .{
        .page = 2,
        .region = "IT",
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/movie/now_playing?page=2&region=IT&language=en-US",
        url,
    );
}

test "tv list url encodes page timezone and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildTvListUrl("airing_today", .{
        .page = 3,
        .timezone = "Europe/Rome",
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/tv/airing_today?page=3&timezone=Europe/Rome&language=en-US",
        url,
    );
}

test "movie subresource url encodes page and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildMovieSubresourceUrl(603, "similar", 2, null);
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/movie/603/similar?page=2&language=en-US",
        url,
    );
}

test "movie images subresource url encodes include_image_language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
        .include_image_language = "en-US,null",
    });
    defer client.deinit();

    const url = try client.buildMovieSubresourceUrl(603, "images", null, "en-US,null");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/movie/603/images?include_image_language=en-US,null&language=en-US",
        url,
    );
}

test "tv videos subresource url encodes include_video_language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildTvSubresourceUrl(1399, "videos", null, null, "en-US,null");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/tv/1399/videos?include_video_language=en-US,null&language=en-US",
        url,
    );
}

test "watch providers url encodes watch_region and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildWatchProvidersUrl("movie", "IT");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/watch/providers/movie?watch_region=IT&language=en-US",
        url,
    );
}

test "watch provider regions url keeps language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildWatchProviderRegionsUrl();
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/watch/providers/regions?language=en-US",
        url,
    );
}

test "people popular url encodes page and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildPeoplePopularUrl(.{ .page = 4 });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/person/popular?page=4&language=en-US",
        url,
    );
}

test "collection images url encodes include_image_language and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
        .include_image_language = "en-US,null",
    });
    defer client.deinit();

    const url = try client.buildCollectionUrl(10, "images", "en-US,null");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/collection/10/images?include_image_language=en-US,null&language=en-US",
        url,
    );
}

test "keyword movies url encodes include_adult page and language" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildKeywordUrl(42, "movies", .{
        .include_adult = false,
        .page = 3,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/keyword/42/movies?include_adult=false&page=3&language=en-US",
        url,
    );
}

test "changes url encodes date range and page" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
    });
    defer client.deinit();

    const url = try client.buildChangesUrl("movie", .{
        .start_date = "2025-01-01",
        .end_date = "2025-01-31",
        .page = 3,
    });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/movie/changes?start_date=2025-01-01&end_date=2025-01-31&page=3",
        url,
    );
}

test "person details url supports append_to_response" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const url = try client.buildPersonDetailsUrl(287, &.{ "external_ids", "images" });
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/person/287?append_to_response=external_ids,images&language=en-US",
        url,
    );
}

test "genre enrichment fills missing names from canonical genre list" {
    var target = [_]types.Genre{
        .{ .id = 28, .name = "" },
        .{ .id = 12, .name = "Adventure" },
        .{ .id = 99, .name = "" },
    };
    const canonical = [_]types.Genre{
        .{ .id = 28, .name = "Action" },
        .{ .id = 12, .name = "Adventure" },
    };

    Client.applyGenreNames(&target, &canonical);

    try std.testing.expectEqualStrings("Action", target[0].name);
    try std.testing.expectEqualStrings("Adventure", target[1].name);
    try std.testing.expectEqualStrings("", target[2].name);
}

test "details url encodes arbitrary appended namespace paths" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
    });
    defer client.deinit();

    const append_values = [_][]const u8{ "images", "videos", "season/3" };
    const url = try client.buildDetailsUrl(.series, 1399, &append_values, "en-US,null");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/tv/1399?append_to_response=images,videos,season%2F3&include_image_language=en-US,null",
        url,
    );
}

test "details request supports chain append builder" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "it-IT",
    });
    defer client.deinit();

    var request = client.movie().detailsRequest(11);
    defer request.deinit();

    _ = try request.appendToResponse("images");
    _ = try request.appendToResponse("videos");

    const url = try request.build();
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/movie/11?append_to_response=images,videos&include_image_language=en-US,null&language=it-IT",
        url,
    );
}

test "details request supports append array" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
    });
    defer client.deinit();

    var request = client.movie().detailsRequest(11);
    defer request.deinit();

    const values = [_][]const u8{ "images", "videos" };
    _ = try request.appendMany(&values);
    _ = request.setIncludeImageLanguage(null);

    const url = try request.build();
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/movie/11?append_to_response=images,videos",
        url,
    );
}

test "tv details request supports arbitrary appended namespace paths" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    var request = client.tv().detailsRequest(226285);
    defer request.deinit();

    _ = try request.appendToResponse("external_ids");
    _ = try request.appendToResponse("season/3");
    _ = request.setIncludeImageLanguage(null);

    const url = try request.build();
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/tv/226285?append_to_response=external_ids,season%2F3&language=en-US",
        url,
    );
}

test "configuration images builds full image url when file path exists" {
    const config_images: types.ConfigurationImages = .{
        .base_url = "http://image.tmdb.org/t/p/",
        .secure_base_url = "https://image.tmdb.org/t/p/",
        .backdrop_sizes = &.{ "w300", "w780", "w1280", "original" },
        .logo_sizes = &.{ "w45", "w92", "w154", "w185", "w300", "w500", "original" },
        .poster_sizes = &.{ "w92", "w154", "w185", "w342", "w500", "w780", "original" },
        .profile_sizes = &.{ "w45", "w185", "h632", "original" },
        .still_sizes = &.{ "w92", "w185", "w300", "original" },
    };

    const url = try config_images.backdropUrl(
        std.testing.allocator,
        "w1280",
        "/b9HyPoxwxjxkWEUL5ErZdhApQe2.jpg",
    );
    defer std.testing.allocator.free(url.?);

    try std.testing.expectEqualStrings(
        "https://image.tmdb.org/t/p/w1280/b9HyPoxwxjxkWEUL5ErZdhApQe2.jpg",
        url.?,
    );
}

test "configuration images returns null when image path is missing" {
    const config_images: types.ConfigurationImages = .{
        .secure_base_url = "https://image.tmdb.org/t/p/",
        .poster_sizes = &.{ "w92", "original" },
    };

    const url = try config_images.posterUrl(std.testing.allocator, "w92", null);
    try std.testing.expect(url == null);
}

test "configuration images validates supported sizes" {
    const config_images: types.ConfigurationImages = .{
        .secure_base_url = "https://image.tmdb.org/t/p/",
        .still_sizes = &.{ "w92", "w185", "w300", "original" },
    };

    try std.testing.expectError(
        error.InvalidImageSize,
        config_images.stillUrl(std.testing.allocator, "w1280", "/still.jpg"),
    );
}

test "tv season details url supports append_to_response" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
    });
    defer client.deinit();

    const append_values = [_][]const u8{ "images", "videos" };
    const url = try client.buildTvSeasonDetailsUrl(1399, 1, &append_values, "en-US,null");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/tv/1399/season/1?append_to_response=images,videos&include_image_language=en-US,null",
        url,
    );
}

test "tv episode details url supports append_to_response" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
        .language = "en-US",
    });
    defer client.deinit();

    const append_values = [_][]const u8{ "images", "videos" };
    const url = try client.buildTvEpisodeDetailsUrl(1399, 1, 1, &append_values, "en-US,null");
    defer std.testing.allocator.free(url);

    try std.testing.expectEqualStrings(
        "https://api.themoviedb.org/3/tv/1399/season/1/episode/1?append_to_response=images,videos&include_image_language=en-US,null&language=en-US",
        url,
    );
}

test "search response parsing ignores unknown fields" {
    const json =
        \\{
        \\  "page": 1,
        \\  "results": [
        \\    { "id": 42, "name": "Example", "media_type": "person", "ignored": true }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.SearchResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 1), parsed.value.results.len);
    try std.testing.expectEqual(@as(u64, 42), parsed.value.results[0].id);
    try std.testing.expectEqualStrings("Example", parsed.value.results[0].name.?);
    try std.testing.expectEqualStrings("person", parsed.value.results[0].media_type.?);
}

test "find response parsing keeps per-media result buckets" {
    const json =
        \\{
        \\  "movie_results": [{ "id": 603, "title": "The Matrix", "media_type": "movie" }],
        \\  "person_results": [{ "id": 287, "name": "Brad Pitt", "media_type": "person" }],
        \\  "tv_results": [{ "id": 1399, "name": "Game of Thrones", "media_type": "tv" }]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.FindResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 1), parsed.value.movie_results.len);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.person_results.len);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.tv_results.len);
    try std.testing.expectEqualStrings("The Matrix", parsed.value.movie_results[0].title.?);
    try std.testing.expectEqualStrings("Brad Pitt", parsed.value.person_results[0].name.?);
    try std.testing.expectEqualStrings("tv", parsed.value.tv_results[0].media_type.?);
}

test "find response helper returns first id for each result kind" {
    const response = types.FindResponse{
        .movie_results = &.{.{ .id = 603 }},
        .person_results = &.{.{ .id = 287 }},
        .tv_results = &.{.{ .id = 1399 }},
        .tv_episode_results = &.{.{ .id = 42 }},
        .tv_season_results = &.{.{ .id = 7 }},
    };

    try std.testing.expectEqual(@as(?u64, 603), Client.firstFindResultId(response, .movie));
    try std.testing.expectEqual(@as(?u64, 287), Client.firstFindResultId(response, .person));
    try std.testing.expectEqual(@as(?u64, 1399), Client.firstFindResultId(response, .tv));
    try std.testing.expectEqual(@as(?u64, 42), Client.firstFindResultId(response, .tv_episode));
    try std.testing.expectEqual(@as(?u64, 7), Client.firstFindResultId(response, .tv_season));
}

test "trending response parsing keeps mixed result fields" {
    const json =
        \\{
        \\  "page": 1,
        \\  "results": [
        \\    { "id": 603, "title": "The Matrix", "media_type": "movie", "vote_average": 8.7 },
        \\    { "id": 287, "name": "Brad Pitt", "media_type": "person", "known_for_department": "Acting" }
        \\  ],
        \\  "total_pages": 100,
        \\  "total_results": 2000
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.SearchResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 2), parsed.value.results.len);
    try std.testing.expectEqualStrings("movie", parsed.value.results[0].media_type.?);
    try std.testing.expectEqualStrings("The Matrix", parsed.value.results[0].title.?);
    try std.testing.expectEqualStrings("person", parsed.value.results[1].media_type.?);
    try std.testing.expectEqualStrings("Brad Pitt", parsed.value.results[1].name.?);
}

test "movie list response parsing keeps optional dates" {
    const json =
        \\{
        \\  "dates": { "maximum": "2026-04-01", "minimum": "2026-03-01" },
        \\  "page": 1,
        \\  "results": [
        \\    { "id": 603, "title": "The Matrix", "release_date": "1999-03-31", "media_type": "movie" }
        \\  ],
        \\  "total_pages": 5,
        \\  "total_results": 100
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.MovieListResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expect(parsed.value.dates != null);
    try std.testing.expectEqualStrings("2026-04-01", parsed.value.dates.?.maximum.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.results.len);
    try std.testing.expectEqualStrings("The Matrix", parsed.value.results[0].title.?);
}

test "credits response parsing keeps cast and crew" {
    const json =
        \\{
        \\  "id": 603,
        \\  "cast": [
        \\    { "id": 6384, "name": "Keanu Reeves", "character": "Neo", "order": 0 }
        \\  ],
        \\  "crew": [
        \\    { "id": 933, "name": "Lana Wachowski", "job": "Director", "department": "Directing" }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.CreditsResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 603), parsed.value.id);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.cast.len);
    try std.testing.expectEqualStrings("Neo", parsed.value.cast[0].character.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.crew.len);
    try std.testing.expectEqualStrings("Director", parsed.value.crew[0].job.?);
}

test "videos response parsing keeps entries" {
    const json =
        \\{
        \\  "id": 603,
        \\  "results": [
        \\    { "id": "abc", "name": "Trailer", "site": "YouTube", "key": "xyz", "official": true }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.VideosResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 603), parsed.value.id);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.results.len);
    try std.testing.expectEqualStrings("Trailer", parsed.value.results[0].name.?);
    try std.testing.expectEqualStrings("YouTube", parsed.value.results[0].site.?);
}

test "media images parsing keeps image buckets" {
    const json =
        \\{
        \\  "id": 603,
        \\  "backdrops": [
        \\    { "file_path": "/backdrop.jpg", "width": 1920, "height": 1080 }
        \\  ],
        \\  "posters": [
        \\    { "file_path": "/poster.jpg", "width": 1000, "height": 1500 }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.MediaImages, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 603), parsed.value.id);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.backdrops.len);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.posters.len);
    try std.testing.expectEqualStrings("/poster.jpg", parsed.value.posters[0].file_path);
}

test "watch provider list response parsing keeps entries" {
    const json =
        \\{
        \\  "results": [
        \\    {
        \\      "display_priority": 4,
        \\      "logo_path": "/peURlLlr8jggOwK53fJ5wdQl05y.jpg",
        \\      "provider_name": "Apple TV",
        \\      "provider_id": 2
        \\    }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.WatchProviderListResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 1), parsed.value.results.len);
    try std.testing.expectEqualStrings("Apple TV", parsed.value.results[0].provider_name.?);
    try std.testing.expectEqual(@as(u32, 2), parsed.value.results[0].provider_id.?);
}

test "watch provider regions response parsing keeps entries" {
    const json =
        \\{
        \\  "results": [
        \\    { "iso_3166_1": "IT", "english_name": "Italy", "native_name": "Italia" }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.WatchProviderRegionsResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 1), parsed.value.results.len);
    try std.testing.expectEqualStrings("IT", parsed.value.results[0].iso_3166_1.?);
    try std.testing.expectEqualStrings("Italy", parsed.value.results[0].english_name.?);
}

test "configuration countries parsing keeps entries" {
    const json =
        \\[
        \\  { "iso_3166_1": "IT", "english_name": "Italy", "native_name": "Italia" }
        \\]
    ;

    var parsed = try std.json.parseFromSlice(types.ConfigurationCountries, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 1), parsed.value.len);
    try std.testing.expectEqualStrings("IT", parsed.value[0].iso_3166_1.?);
}

test "collection details parsing keeps parts" {
    const json =
        \\{
        \\  "id": 10,
        \\  "name": "Star Wars Collection",
        \\  "parts": [
        \\    { "id": 11, "title": "Star Wars", "release_date": "1977-05-25" }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.CollectionDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 10), parsed.value.id);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.parts.len);
    try std.testing.expectEqualStrings("Star Wars", parsed.value.parts[0].title.?);
}

test "company details parsing keeps fields" {
    const json =
        \\{
        \\  "id": 1,
        \\  "name": "Lucasfilm Ltd.",
        \\  "origin_country": "US",
        \\  "homepage": "https://www.lucasfilm.com"
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.CompanyDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 1), parsed.value.id);
    try std.testing.expectEqualStrings("Lucasfilm Ltd.", parsed.value.name.?);
}

test "keyword movies response parsing keeps items" {
    const json =
        \\{
        \\  "id": 42,
        \\  "page": 1,
        \\  "results": [
        \\    { "id": 603, "title": "The Matrix", "release_date": "1999-03-31" }
        \\  ],
        \\  "total_pages": 2,
        \\  "total_results": 20
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.KeywordMoviesResponse, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 42), parsed.value.id);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.results.len);
    try std.testing.expectEqualStrings("The Matrix", parsed.value.results[0].title.?);
}

test "movie details parsing keeps nested tmdb fields" {
    const json =
        \\{
        \\  "id": 603,
        \\  "title": "The Matrix",
        \\  "genres": [
        \\    { "id": 878, "name": "Science Fiction" }
        \\  ],
        \\  "images": {
        \\    "posters": [
        \\      { "height": 1000, "width": 700, "file_path": "/poster.jpg" }
        \\    ]
        \\  },
        \\  "external_ids": {
        \\    "imdb_id": "tt0133093"
        \\  }
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.MovieDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 603), parsed.value.id);
    try std.testing.expectEqualStrings("The Matrix", parsed.value.title.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.genres.len);
    try std.testing.expectEqualStrings("Science Fiction", parsed.value.genres[0].name);
    try std.testing.expectEqualStrings("tt0133093", parsed.value.external_ids.?.imdb_id.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.images.?.posters.len);
}

test "tv details parsing keeps tv-specific fields" {
    const json =
        \\{
        \\  "id": 1399,
        \\  "name": "Game of Thrones",
        \\  "first_air_date": "2011-04-17",
        \\  "genres": [
        \\    { "id": 10765, "name": "Sci-Fi & Fantasy" }
        \\  ],
        \\  "networks": [
        \\    { "id": 49, "name": "HBO", "origin_country": "US" }
        \\  ],
        \\  "seasons": [
        \\    { "id": 3624, "name": "Season 1", "season_number": 1, "episode_count": 10 }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.TvDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 1399), parsed.value.id);
    try std.testing.expectEqualStrings("Game of Thrones", parsed.value.name.?);
    try std.testing.expectEqualStrings("2011-04-17", parsed.value.first_air_date.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.genres.len);
    try std.testing.expectEqualStrings("Sci-Fi & Fantasy", parsed.value.genres[0].name);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.networks.len);
    try std.testing.expectEqualStrings("HBO", parsed.value.networks[0].name);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.seasons.len);
    try std.testing.expectEqual(@as(u32, 1), parsed.value.seasons[0].season_number);
}

test "tv season details parsing keeps episodes" {
    const json =
        \\{
        \\  "_id": "5256c89f19c2956ff6046d47",
        \\  "air_date": "2011-04-17",
        \\  "episodes": [
        \\    {
        \\      "air_date": "2011-04-17",
        \\      "episode_number": 1,
        \\      "episode_type": "standard",
        \\      "id": 63056,
        \\      "name": "Winter Is Coming",
        \\      "overview": "Episode overview",
        \\      "production_code": "101",
        \\      "runtime": 62,
        \\      "season_number": 1,
        \\      "show_id": 1399,
        \\      "still_path": "/still.jpg",
        \\      "vote_average": 8.1,
        \\      "vote_count": 396,
        \\      "crew": [
        \\        { "id": 44797, "name": "Tim Van Patten", "job": "Director", "department": "Directing" }
        \\      ],
        \\      "guest_stars": [
        \\        { "id": 119783, "name": "Joseph Mawle", "character": "Benjen Stark", "order": 61 }
        \\      ]
        \\    }
        \\  ],
        \\  "id": 3624,
        \\  "name": "Season 1",
        \\  "overview": "Season overview",
        \\  "poster_path": "/season.jpg",
        \\  "season_number": 1,
        \\  "vote_average": 8.6
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.TvSeasonDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 3624), parsed.value.id);
    try std.testing.expectEqualStrings("Season 1", parsed.value.name.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.episodes.len);
    try std.testing.expectEqualStrings("Winter Is Coming", parsed.value.episodes[0].name.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.episodes[0].crew.len);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.episodes[0].guest_stars.len);
}

test "tv episode details parsing keeps cast and crew" {
    const json =
        \\{
        \\  "air_date": "2011-04-17",
        \\  "crew": [
        \\    { "id": 44797, "name": "Timothy Van Patten", "job": "Director", "department": "Directing" }
        \\  ],
        \\  "episode_number": 1,
        \\  "guest_stars": [
        \\    { "id": 119783, "name": "Joseph Mawle", "character": "Benjen Stark", "order": 62 }
        \\  ],
        \\  "name": "Winter Is Coming",
        \\  "overview": "Episode overview",
        \\  "id": 63056,
        \\  "production_code": "101",
        \\  "runtime": 62,
        \\  "season_number": 1,
        \\  "still_path": "/still.jpg",
        \\  "vote_average": 7.8,
        \\  "vote_count": 286
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.TvEpisodeDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 63056), parsed.value.id);
    try std.testing.expectEqualStrings("Winter Is Coming", parsed.value.name.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.crew.len);
    try std.testing.expectEqualStrings("Director", parsed.value.crew[0].job.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.guest_stars.len);
    try std.testing.expectEqualStrings("Benjen Stark", parsed.value.guest_stars[0].character.?);
}

test "configuration details parsing keeps image sizes" {
    const json =
        \\{
        \\  "images": {
        \\    "base_url": "http://image.tmdb.org/t/p/",
        \\    "secure_base_url": "https://image.tmdb.org/t/p/",
        \\    "backdrop_sizes": ["w300", "w780", "w1280", "original"],
        \\    "logo_sizes": ["w45", "w92", "original"],
        \\    "poster_sizes": ["w92", "w154", "original"],
        \\    "profile_sizes": ["w45", "h632", "original"],
        \\    "still_sizes": ["w92", "w185", "original"]
        \\  },
        \\  "change_keys": ["images", "overview", "videos"]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.ConfigurationDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 4), parsed.value.images.backdrop_sizes.len);
    try std.testing.expectEqualStrings("https://image.tmdb.org/t/p/", parsed.value.images.secure_base_url);
    try std.testing.expectEqual(@as(usize, 3), parsed.value.change_keys.len);
}

test "network details parsing keeps fields" {
    const json =
        \\{
        \\  "headquarters": "New York",
        \\  "homepage": "https://www.hbo.com",
        \\  "id": 49,
        \\  "logo_path": "/tuomPhY2UtuPTqqFnKMVHvSb724.png",
        \\  "name": "HBO",
        \\  "origin_country": "US"
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.NetworkDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 49), parsed.value.id);
    try std.testing.expectEqualStrings("HBO", parsed.value.name.?);
    try std.testing.expectEqualStrings("US", parsed.value.origin_country.?);
}

test "review details parsing keeps author details" {
    const json =
        \\{
        \\  "id": "123",
        \\  "author": "alice",
        \\  "author_details": {
        \\    "name": "Alice",
        \\    "username": "alice",
        \\    "avatar_path": "/avatar.png",
        \\    "rating": 8
        \\  },
        \\  "content": "Review body",
        \\  "media_id": 550,
        \\  "media_title": "Fight Club",
        \\  "media_type": "movie",
        \\  "url": "https://www.themoviedb.org/review/123"
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.ReviewDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqualStrings("alice", parsed.value.author.?);
    try std.testing.expectEqual(@as(u64, 550), parsed.value.media_id.?);
    try std.testing.expectEqual(@as(f32, 8), parsed.value.author_details.?.rating.?);
}

test "certification list parsing supports dynamic country keys" {
    const json =
        \\{
        \\  "certifications": {
        \\    "US": [
        \\      { "certification": "PG-13", "meaning": "Parents Strongly Cautioned", "order": 3 }
        \\    ],
        \\    "IT": [
        \\      { "certification": "T", "meaning": "Per tutti", "order": 1 }
        \\    ]
        \\  }
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.CertificationList, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    const us = parsed.value.byCountry("US").?;
    const it = parsed.value.byCountry("IT").?;

    try std.testing.expectEqual(@as(usize, 1), us.len);
    try std.testing.expectEqualStrings("PG-13", us[0].certification);
    try std.testing.expectEqualStrings("T", it[0].certification);
}

test "changes list parsing keeps page results" {
    const json =
        \\{
        \\  "page": 1,
        \\  "results": [
        \\    { "id": 550, "adult": false },
        \\    { "id": 603 }
        \\  ],
        \\  "total_pages": 10,
        \\  "total_results": 20
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.ChangesList, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u32, 1), parsed.value.page);
    try std.testing.expectEqual(@as(usize, 2), parsed.value.results.len);
    try std.testing.expectEqual(@as(u64, 550), parsed.value.results[0].id);
    try std.testing.expectEqual(false, parsed.value.results[0].adult.?);
    try std.testing.expect(parsed.value.results[1].adult == null);
}

test "person details parsing keeps primary fields" {
    const json =
        \\{
        \\  "adult": false,
        \\  "also_known_as": ["William Bradley Pitt"],
        \\  "biography": "Actor biography",
        \\  "birthday": "1963-12-18",
        \\  "gender": 2,
        \\  "id": 287,
        \\  "imdb_id": "nm0000093",
        \\  "known_for_department": "Acting",
        \\  "name": "Brad Pitt",
        \\  "place_of_birth": "Shawnee, Oklahoma, USA",
        \\  "popularity": 42.5,
        \\  "profile_path": "/profile.jpg"
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.PersonDetails, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 287), parsed.value.id);
    try std.testing.expectEqualStrings("Brad Pitt", parsed.value.name.?);
    try std.testing.expectEqualStrings("nm0000093", parsed.value.imdb_id.?);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.also_known_as.len);
}

test "person combined credits parsing keeps cast and crew" {
    const json =
        \\{
        \\  "id": 287,
        \\  "cast": [
        \\    {
        \\      "id": 550,
        \\      "title": "Fight Club",
        \\      "character": "Tyler Durden",
        \\      "credit_id": "52fe4250c3a36847f80149f3",
        \\      "media_type": "movie"
        \\    }
        \\  ],
        \\  "crew": [
        \\    {
        \\      "id": 550,
        \\      "title": "Fight Club",
        \\      "job": "Producer",
        \\      "department": "Production",
        \\      "credit_id": "abc",
        \\      "media_type": "movie"
        \\    }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.PersonCombinedCredits, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 287), parsed.value.id);
    try std.testing.expectEqual(@as(usize, 1), parsed.value.cast.len);
    try std.testing.expectEqualStrings("Fight Club", parsed.value.cast[0].title.?);
    try std.testing.expectEqualStrings("Producer", parsed.value.crew[0].job.?);
}

test "genre list parsing keeps entries" {
    const json =
        \\{
        \\  "genres": [
        \\    { "id": 28, "name": "Action" },
        \\    { "id": 12, "name": "Adventure" }
        \\  ]
        \\}
    ;

    var parsed = try std.json.parseFromSlice(types.GenreList, std.testing.allocator, json, .{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    });
    defer parsed.deinit();

    try std.testing.expectEqual(@as(usize, 2), parsed.value.genres.len);
    try std.testing.expectEqual(@as(u64, 28), parsed.value.genres[0].id);
    try std.testing.expectEqualStrings("Action", parsed.value.genres[0].name);
}

test "grouped apis stay available on client" {
    var client = Client.init(std.testing.allocator, .{
        .token = "token",
    });
    defer client.deinit();

    _ = client.search();
    _ = client.discover();
    _ = client.find();
    _ = client.trending();
    _ = client.watchProviders();
    _ = client.collections();
    _ = client.companies();
    _ = client.genres();
    _ = client.keywords();
    _ = client.movie();
    _ = client.tv();
    _ = client.configuration();
    _ = client.networks();
    _ = client.reviews();
    _ = client.certifications();
    _ = client.changes();
    _ = client.people();
    _ = client.tvSeasons();
    _ = client.tvEpisodes();
}

test "integration fetches tmdb details using grouped tv api" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var parsed = try client.tv().details(226285);
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 226285), parsed.value.id);
    try std.testing.expect(parsed.value.name != null);
}

test "integration fetches tmdb tv details with external_ids and season append" {
    const AppendedTvDetails = struct {
        id: u64 = 0,
        name: ?[]const u8 = null,
        external_ids: ?types.ExternalIds = null,
        @"season/3": ?types.TvSeasonDetails = null,
    };

    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var request = client.tv().detailsRequest(226285);
    defer request.deinit();

    _ = try request.appendToResponse("external_ids");
    _ = try request.appendToResponse("season/3");
    _ = request.setIncludeImageLanguage(null);

    var parsed = try request.sendAs(AppendedTvDetails);
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 226285), parsed.value.id);
    try std.testing.expect(parsed.value.external_ids != null);
    try std.testing.expect(parsed.value.@"season/3" != null);
    try std.testing.expectEqual(@as(u32, 3), parsed.value.@"season/3".?.season_number);
}

test "integration fetches tmdb tv season details" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var parsed = try client.tvSeasons().details(1399, 1);
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u32, 1), parsed.value.season_number);
    try std.testing.expect(parsed.value.episodes.len > 0);
}

test "integration fetches tmdb tv episode details" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var parsed = try client.tvEpisodes().details(1399, 1, 1);
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u32, 1), parsed.value.episode_number);
    try std.testing.expect(parsed.value.name != null);
}

test "integration fetches tmdb configuration" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
    });
    defer client.deinit();

    var parsed = try client.configuration().details();
    defer parsed.deinit();

    const url = try parsed.value.images.backdropUrl(
        std.testing.allocator,
        "w1280",
        "/b9HyPoxwxjxkWEUL5ErZdhApQe2.jpg",
    );
    defer if (url) |value| std.testing.allocator.free(value);

    try std.testing.expect(parsed.value.images.secure_base_url.len > 0);
    try std.testing.expect(url != null);
}

test "integration fetches tmdb network details and images" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
    });
    defer client.deinit();

    var details = try client.networks().details(49);
    defer details.deinit();

    var images = try client.networks().images(49);
    defer images.deinit();

    try std.testing.expectEqual(@as(u64, 49), details.value.id);
    try std.testing.expect(details.value.name != null);
    try std.testing.expectEqual(@as(u64, 49), images.value.id);
}

test "integration fetches tmdb review details" {
    const ReviewList = struct {
        results: []const struct {
            id: []const u8 = "",
        } = &.{},
    };

    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    const body = try client.request("https://api.themoviedb.org/3/movie/550/reviews?language=en-US&page=1");
    defer std.testing.allocator.free(body);

    var list = try client.parseJson(ReviewList, body);
    defer list.deinit();

    if (list.value.results.len == 0) return error.SkipZigTest;

    var review = try client.reviews().details(list.value.results[0].id);
    defer review.deinit();

    try std.testing.expect(review.value.id != null);
    try std.testing.expect(review.value.content != null);
}

test "integration fetches tmdb movie and tv certifications" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
    });
    defer client.deinit();

    var movie_certs = try client.certifications().movie();
    defer movie_certs.deinit();

    var tv_certs = try client.certifications().tv();
    defer tv_certs.deinit();

    try std.testing.expect(movie_certs.value.byCountry("US") != null);
    try std.testing.expect(tv_certs.value.byCountry("US") != null);
}

test "integration fetches tmdb change lists" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
    });
    defer client.deinit();

    var movie_changes = try client.changes().movie(.{ .page = 1 });
    defer movie_changes.deinit();

    var person_changes = try client.changes().person(.{ .page = 1 });
    defer person_changes.deinit();

    var tv_changes = try client.changes().tv(.{ .page = 1 });
    defer tv_changes.deinit();

    try std.testing.expectEqual(@as(u32, 1), movie_changes.value.page);
    try std.testing.expectEqual(@as(u32, 1), person_changes.value.page);
    try std.testing.expectEqual(@as(u32, 1), tv_changes.value.page);
}

test "integration fetches tmdb person details with append" {
    const AppendedPersonDetails = struct {
        id: u64 = 0,
        name: ?[]const u8 = null,
        external_ids: ?types.PersonExternalIds = null,
        images: ?types.PersonImages = null,
    };

    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var request = client.people().detailsRequest(287);
    defer request.deinit();

    _ = try request.appendMany(&.{ "external_ids", "images" });

    var parsed = try request.sendAs(AppendedPersonDetails);
    defer parsed.deinit();

    try std.testing.expectEqual(@as(u64, 287), parsed.value.id);
    try std.testing.expect(parsed.value.name != null);
    try std.testing.expect(parsed.value.external_ids != null);
    try std.testing.expect(parsed.value.images != null);
}

test "integration fetches tmdb person credits and changes" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var combined = try client.people().combinedCredits(287);
    defer combined.deinit();

    var movie_credits = try client.people().movieCredits(287);
    defer movie_credits.deinit();

    var tv_credits = try client.people().tvCredits(287);
    defer tv_credits.deinit();

    var changes = try client.people().changes(287, .{ .page = 1 });
    defer changes.deinit();

    try std.testing.expectEqual(@as(u64, 287), combined.value.id);
    try std.testing.expectEqual(@as(u64, 287), movie_credits.value.id);
    try std.testing.expectEqual(@as(u64, 287), tv_credits.value.id);
    try std.testing.expect(changes.value.changes.len >= 0);
}

test "integration fetches tmdb movie genres" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var parsed = try client.genres().movie();
    defer parsed.deinit();

    try std.testing.expect(parsed.value.genres.len > 0);
}

test "integration fetches tmdb tv genres" {
    var env = try dotenv.load(std.testing.allocator, ".env");
    defer env.deinit();

    const token = env.get("TMDB_READ_ACCESS_TOKEN") orelse return error.SkipZigTest;

    var client = Client.init(std.testing.allocator, .{
        .token = token,
        .language = "en-US",
    });
    defer client.deinit();

    var parsed = try client.genres().tv();
    defer parsed.deinit();

    try std.testing.expect(parsed.value.genres.len > 0);
}
