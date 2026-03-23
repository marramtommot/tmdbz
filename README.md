# tmdbz

A Zig client for the TMDb v3 API, focused on a typed read-only surface.

The library exposes TMDb endpoint families as grouped APIs on a shared `Client`, for example:

- `client.search()`
- `client.movie()`
- `client.tv()`
- `client.people()`
- `client.discover()`

The current focus is the read-only catalog. Authenticated/stateful TMDb surfaces such as `account`, `lists`, ratings, and guest sessions are not a priority for now.

## Status

Implemented today:

- search: `movie`, `tv`, `person`, `collection`, `company`, `keyword`, `multi`
- discover
- find
- trending
- watch providers
- movie details, lists, and common subresources
- TV details, lists, and common subresources
- people details and common read-only subresources
- collections, companies, keywords, genres
- configuration, certifications, changes, networks, reviews
- `append_to_response` builders for the detail endpoints that officially support it

## Requirements

- Zig `0.15.2`
- a TMDb v3 read access token

## Install

Fetch the package:

```sh
zig fetch --save git+https://github.com/marramtommot/tmdbz#master
```

Then wire the module in `build.zig` and import it as `tmdbz`:

```zig
const tmdbz_dep = b.dependency("tmdbz", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("tmdbz", tmdbz_dep.module("tmdbz"));
```

## Usage

```zig
const std = @import("std");
const tmdbz = @import("tmdbz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var client = tmdbz.Client.init(allocator, .{
        .token = "<TMDB_READ_ACCESS_TOKEN>",
        .language = "en-US",
    });
    defer client.deinit();

    const maybe_movie_id = try client.search().movieId("The Matrix", 1999);
    if (maybe_movie_id == null) return;

    var details = try client.movie().details(maybe_movie_id.?);
    defer details.deinit();

    std.debug.print("{s}\n", .{details.value.title.?});
}
```

### `append_to_response`

```zig
var request = client.movie().detailsRequest(603);
defer request.deinit();

_ = try request.append(.images);
_ = try request.append(.videos);

var parsed = try request.send();
defer parsed.deinit();
```

Use `appendRaw(...)` only for dynamic or non-enum values, for example:

```zig
_ = try request.appendRaw("season/3");
```

The same builder pattern is available for:

- movie details
- person details
- TV series details
- TV season details
- TV episode details

## Tests

Run the full test suite:

```sh
zig build test
```

Some integration tests are enabled only when `TMDB_READ_ACCESS_TOKEN` is available in the environment:

```sh
TMDB_READ_ACCESS_TOKEN=...
```

## Design Notes

- one shared HTTP client and request pipeline
- allocator-aware API, no hidden global state
- typed responses for the main read-only endpoints
- grouped endpoint families instead of a flat method list
- backward-compatible exports in `src/root.zig`
- static metadata such as configuration, certifications, and genre lists is cached in-memory on the client; if those endpoints look temporarily out of sync with TMDb, cached static data is the likely reason

## Non-Goals For Now

- account/session management
- ratings and other user-state mutations
- list management
- maximizing one-to-one parity with every TMDb endpoint before stabilizing the current read-only surface
