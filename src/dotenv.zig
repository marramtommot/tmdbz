const std = @import("std");

const Allocator = std.mem.Allocator;

pub const Dotenv = struct {
    allocator: Allocator,
    map: std.process.EnvMap,

    pub fn init(allocator: Allocator, filename: ?[]const u8) !Dotenv {
        var env = Dotenv{
            .allocator = allocator,
            .map = try std.process.getEnvMap(allocator),
        };
        errdefer env.deinit();

        if (filename) |path| {
            try env.loadFile(path);
        }

        return env;
    }

    pub fn deinit(self: *Dotenv) void {
        self.map.deinit();
    }

    pub fn get(self: Dotenv, key: []const u8) ?[]const u8 {
        return self.map.get(key);
    }

    pub fn put(self: *Dotenv, key: []const u8, value: []const u8) !void {
        try self.map.put(key, value);
    }

    pub fn loadFile(self: *Dotenv, path: []const u8) !void {
        const file = std.fs.cwd().openFile(path, .{}) catch |err| switch (err) {
            error.FileNotFound => return,
            else => return err,
        };
        defer file.close();

        const contents = try file.readToEndAlloc(self.allocator, 1024 * 64);
        defer self.allocator.free(contents);

        var lines = std.mem.tokenizeScalar(u8, contents, '\n');
        while (lines.next()) |raw_line| {
            const trimmed = std.mem.trim(u8, raw_line, " \t\r");
            if (trimmed.len == 0 or trimmed[0] == '#') continue;

            const eq_index = std.mem.indexOfScalar(u8, trimmed, '=') orelse continue;
            const key = std.mem.trim(u8, trimmed[0..eq_index], " \t");
            if (key.len == 0) continue;

            var value = std.mem.trim(u8, trimmed[eq_index + 1 ..], " \t");
            value = stripQuotes(value);

            try self.map.put(key, value);
        }
    }
};

pub fn load(allocator: Allocator, filename: ?[]const u8) !Dotenv {
    return Dotenv.init(allocator, filename);
}

fn stripQuotes(value: []const u8) []const u8 {
    if (value.len >= 2) {
        const first = value[0];
        const last = value[value.len - 1];
        if ((first == '"' and last == '"') or (first == '\'' and last == '\'')) {
            return value[1 .. value.len - 1];
        }
    }

    return value;
}

test "load env file with spaces and quotes" {
    var tmp = std.testing.tmpDir(.{});
    defer tmp.cleanup();

    const env_contents =
        \\VALUE1=1
        \\ VALUE2 = "2"
        \\# comment
        \\VALUE3='3'
        \\INVALID
    ;

    try tmp.dir.writeFile(.{
        .sub_path = ".env.test",
        .data = env_contents,
    });

    var original_cwd = try std.fs.cwd().openDir(".", .{});
    defer original_cwd.close();
    try tmp.dir.setAsCwd();
    defer original_cwd.setAsCwd() catch {};

    var env = try Dotenv.init(std.testing.allocator, ".env.test");
    defer env.deinit();

    try std.testing.expectEqualStrings("1", env.get("VALUE1").?);
    try std.testing.expectEqualStrings("2", env.get("VALUE2").?);
    try std.testing.expectEqualStrings("3", env.get("VALUE3").?);
    try std.testing.expectEqual(null, env.get("INVALID"));
}
