const std = @import("std");

pub fn main() !void {
    const stdout = std.fs.File.stdout();
    try stdout.writeAll("tmdbz is a Zig library. Run `zig build test` to validate it.\n");
}
