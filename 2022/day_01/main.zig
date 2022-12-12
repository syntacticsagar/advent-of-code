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

    var lines = mem.split(u8, file_contents, "\n");
    var elf_total_calories: i64 = 0;
    var elves_list = std.ArrayList(i64).init(gpa);
    defer elves_list.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            if (elf_total_calories != 0) {
                try elves_list.append(elf_total_calories);
                elf_total_calories = 0;
            }
        } else {
            const calories = try parseInt(i64, line, 10);
            elf_total_calories += calories;
        }
    }

    var max_cals: [3]i64 = .{ 0, 0, 0 };
    for (elves_list.items) |curr_elf_calories| {
        if (curr_elf_calories > max_cals[0]) {
            max_cals[2] = max_cals[1];
            max_cals[1] = max_cals[0];
            max_cals[0] = curr_elf_calories;
        } else if (curr_elf_calories > max_cals[1]) {
            max_cals[2] = max_cals[1];
            max_cals[1] = curr_elf_calories;
        } else if (curr_elf_calories > max_cals[2]) {
            max_cals[2] = curr_elf_calories;
        }
    }
    std.debug.print("problem 1 solution = {}\n", .{max_cals[0]});
    std.debug.print("problem 2 solution = {}\n", .{max_cals[0] + max_cals[1] + max_cals[2]});
}
