const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const assert = std.debug.assert;
const tokenizeAny = mem.tokenizeAny;
const parseInt = std.fmt.parseInt;
const ArrayList = std.ArrayList;
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const file_name = "./input/main_input.txt";

const data = @embedFile(file_name);

pub fn main() !void {
    var lines = tokenizeAny(u8, data, "\r\n");
    var p1: u64 = 1;
    var p2: u64 = 0;

    var times = tokenizeAny(u8, lines.next() orelse unreachable, "Time: ");
    var distances = tokenizeAny(u8, lines.next() orelse unreachable, "Distance: ");
    var bossTime: u64 = 0;
    var bossDist: u64 = 0;
    while (times.next()) |timeStr| {
        const time = try parseInt(u16, timeStr, 10);
        const distStr = distances.next() orelse unreachable;
        const distance = try parseInt(u16, distStr, 10);

        bossTime = bossTime * std.math.pow(u64, 10, timeStr.len) + time;
        bossDist = bossDist * std.math.pow(u64, 10, distStr.len) + distance;
        var beat: u16 = 0;
        for (1..time) |t| {
            if (t * (time - t) > distance) {
                beat += 1;
            }
        }
        std.debug.print("time: {} distance: {} beat: {}\n", .{ time, distance, beat });
        p1 = p1 * beat;
    }
    std.debug.print("\nbt: {} bd: {}\n", .{ bossTime, bossDist });
    for (1..bossTime) |t| {
        if (t * (bossTime - t) > bossDist) {
            // std.debug.print("boss beat: {}", .{t});
            p2 += 1;
        }
    }
    std.debug.print("\np1: {} p2: {}\n", .{ p1, p2 });
}
