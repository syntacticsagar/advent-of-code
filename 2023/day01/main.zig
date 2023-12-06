const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;

const file_name = "./input/main_input.txt";

const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    const numbers = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    var lines = mem.split(u8, file_contents, "\n");
    var sum_1: usize = 0;
    var sum_2: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var first_digit: ?u8 = null;
        var first_idx: ?usize = null;
        var last_digit: ?u8 = null;
        var last_idx: ?usize = null;
        for (line, 0..) |char, i| {
            if (char >= '0' and char <= '9') {
                if (first_digit == null) {
                    first_digit = char - '0';
                    first_idx = i;
                }
                last_digit = char - '0';
                last_idx = i;
            }
        }
        sum_1 += (first_digit.? * 10 + last_digit.?);

        for (numbers, 1..) |number, i| {
            if (mem.indexOf(u8, line, number)) |idx| {
                if (idx < first_idx.?) {
                    first_idx = idx;
                    first_digit = @intCast(i);
                }
                const last = mem.lastIndexOf(u8, line, number).?;
                if (last > last_idx.?) {
                    last_idx = last;
                    last_digit = @intCast(i);
                }
            }
        }
        std.debug.print("{}{}\n", .{ first_digit.?, last_digit.? });
        sum_2 += (first_digit.? * 10 + last_digit.?);
    }
    std.debug.print("part 1: {} part 2: {}\n", .{ sum_1, sum_2 });
}
