const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const tokenizeAny = mem.tokenizeAny;
const parseInt = std.fmt.parseInt;

const file_name = "./input/main_input.txt";

const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

pub fn main() !void {
    var p1: i64 = 0;
    var p2: i64 = 0;
    var lines = tokenizeAny(u8, file_contents, "\r\n");
    while (lines.next()) |line| {
        var red: i64 = 0;
        var green: i64 = 0;
        var blue: i64 = 0;
        var toks = tokenizeAny(u8, line[5..], ": ,;");
        const id = try parseInt(i64, toks.next().?, 10);
        while (toks.next()) |num_s| {
            const num = try parseInt(i64, num_s, 10);
            const color = toks.next().?;
            if (std.mem.eql(u8, color, "red")) {
                red = @max(red, num);
            } else if (std.mem.eql(u8, color, "green")) {
                green = @max(green, num);
            } else if (std.mem.eql(u8, color, "blue")) {
                blue = @max(blue, num);
            }
        }
        if (red <= 12 and green <= 13 and blue <= 14) {
            p1 += id;
        }
        p2 += red * blue * green;
    }
    std.debug.print("part1: {}, part2: {}\n", .{ p1, p2 });
}
