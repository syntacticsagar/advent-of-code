const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const assert = std.debug.assert;

const file_name = "./input/sample_input.txt";
const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    var lines = mem.split(u8, file_contents, "\n");
    var first_line = lines.next() orelse unreachable;
    var prev_line_length: usize = first_line.len;
    var stacks_input: bool = true;
    var moves_input: bool = false;
    var stacks_count: usize = prev_line_length / 3;
    var stacks = std.ArrayList(std.ArrayList(u8)).init(gpa);

    var i: u16 = 0;
    while(i < stacks_count){
        var stack = try std.ArrayList(u8).init(gpa) catch unreachable;
        stacks.append(stack);
        i += 1;
    }

    while(lines.next()) |line| {
        if(line.len == 0){
            stacks_input = !stacks_input;
            moves_input = !moves_input;

            for(stacks.items) |stack| {
                for(stack.items) |item| {
                    std.debug.print("{s}.", .{ item });
                }
                std.debug.print("\n", .{});
            }
        }
        if(stacks_input){
            i = 0;
            while(i < stacks_count) {
                var slice_start = i * 3;
                var slice = mem.tokenize(u8, line[slice_start..slice_start + 3], " []");
                if(slice.len != 0){
                    stacks[i].insert(slice);
                }
            }
            // var tokens = mem.split(u8, line, " ");
            // while(tokens.next()) |token| {
            //     if(token.len == 0){
            //         std.debug.print("{}", .{ i });
            //     } else {
            //         std.debug.print("{s}", .{ token });
            //     }
            //     i += 1;
            // }
            // i = 0;
            // std.debug.print("\n", .{});
        }
    }

    // std.debug.print("problem 1 solution = {}\n", .{ priorities_total });
    // std.debug.print("problem 2 solution = {}, {}\n", .{ total_lines, total_lines - uncontained_count });
}
