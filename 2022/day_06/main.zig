const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const assert = std.debug.assert;

const file_name = "./input/main_input.txt";
const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

fn containsDuplicates(str: []const u8) bool {
    var i: usize = 0;
    while (i < str.len-1) : (i += 1) {
        var j: usize = i + 1;
        while (j < str.len) : (j += 1) {
            if (str[i] == str[j]) return true;
        }
    }
    return false;
}

pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    var lines = mem.split(u8, file_contents, "\n");

    while(lines.next()) |line| {
        if(line.len != 0){
            var i: usize = 0;

            const part1 = while (true) : (i += 1) {
                if (!containsDuplicates(line[i..][0..4]))
                    break i + 4;
            } else unreachable;

            const part2 = while (true) : (i += 1) {
                if (!containsDuplicates(line[i..][0..14]))
                    break i + 14;
            } else unreachable;

            std.debug.print("part1: {}\npart2: {}\n", .{part1, part2});
        }
    }

    // std.debug.print("problem 1 solution = {}\n", .{ i });
    // std.debug.print("problem 2 solution = {}, {}\n", .{ total_lines, total_lines - uncontained_count });
}
