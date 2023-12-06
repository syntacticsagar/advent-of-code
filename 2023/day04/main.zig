const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const tokenizeAny = mem.tokenizeAny;
const parseInt = std.fmt.parseInt;
const Map = std.AutoHashMap;
const BoundedArray = std.BoundedArray;

const file_name = "./input/main_input.txt";

const data = @embedFile(file_name);
const scores = [_]u32{ 0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096 };

pub fn main() !void {
    var lines = tokenizeAny(u8, data, "\r\n");
    var p1: u64 = 0;
    var p2: u64 = 0;
    var curr_line: u64 = 0;
    var scratch_card_count = try BoundedArray(u64, 201).init(201);
    for (0..200) |i| {
        scratch_card_count.set(i, 1);
    }
    while (lines.next()) |line| {
        // std.debug.print("\n{}--->", .{curr_line});
        if (line.len == 0) continue;

        const colon_idx = mem.indexOf(u8, line, ":");
        const separator_idx = mem.indexOf(u8, line, "|");

        if (colon_idx) |start| {
            if (separator_idx) |pipe_idx| {
                var winning_nums = tokenizeAny(u8, line[start + 2 .. pipe_idx - 1], " ");
                var scratch_nums = tokenizeAny(u8, line[pipe_idx + 2 ..], " ");

                var win_count: u64 = 0;
                while (winning_nums.next()) |win_num| {
                    scratch_nums.reset();
                    while (scratch_nums.next()) |scratch_num| {
                        if (mem.eql(u8, scratch_num, win_num)) {
                            win_count += 1;
                        }
                    }
                }
                // std.debug.print(" {}:", .{win_count});
                if (win_count > 0) {
                    for (0..win_count) |i| {
                        // std.debug.print(";;{};;", .{i});
                        const curr_card_count = scratch_card_count.get(curr_line);
                        const subsequent_card_count = scratch_card_count.get(curr_line + 1 + i);
                        scratch_card_count.set(curr_line + 1 + i, curr_card_count + subsequent_card_count);
                    }
                }
                p1 += scores[win_count];
            }
        }
        curr_line += 1;
    }
    for (0..curr_line) |i| {
        std.debug.print("{} -> {}\n", .{ i + 1, scratch_card_count.get(i) });
        p2 += scratch_card_count.get(i);
    }
    std.debug.print("p1: {} p2: {}\n", .{ p1, p2 });
}
