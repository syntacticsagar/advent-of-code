const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const assert = std.debug.assert;

const file_name = "./input/main_input.txt";
const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    var lines = mem.split(u8, file_contents, "\n");
    var uncontained_count: u16 = 0;
    var total_lines: u16 = 0;

    while(lines.next()) |line| {
        if(line.len != 0){
            total_lines += 1;
            var sections = mem.split(u8, line, ",");
            var section_1 = sections.first();
            var section_2 = sections.next() orelse unreachable;

            var limits_1 = mem.split(u8, section_1, "-");
            var limits_2 = mem.split(u8, section_2, "-");
            
            var low_1: u16 = try parseInt(u16, limits_1.next() orelse unreachable, 10);
            var high_1: u16 = try parseInt(u16, limits_1.next() orelse unreachable, 10);

            var low_2: u16 = try parseInt(u16, limits_2.next() orelse unreachable, 10);
            var high_2: u16 = try parseInt(u16, limits_2.next() orelse unreachable, 10);

            // std.debug.print("{any}-{any}, {any}-{any}\n", .{low_1, high_1, low_2, high_2});
            if((low_2 > high_1 or high_2 < low_1)) {
                uncontained_count += 1;
            }
        }
    }

    // std.debug.print("problem 1 solution = {}\n", .{ priorities_total });
    std.debug.print("problem 1 solution = {}, {}\n", .{ total_lines, total_lines - uncontained_count });
}
