const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const assert = std.debug.assert;

const file_name = "./input/sample_input.txt";
const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

fn path_key(buf: [] u8, list: []const []const u8, separator: [] const u8) [] const u8{
    const joined_path = mem.join(gpa, separator, list);
    return std.fmt.bufPrint(&buf, "{s}", .{ joined_path });
}

pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    var lines = mem.split(u8, file_contents, "\n");
    // var directories_map = std.StringHashMap.init(gpa);
    // errdefer directories_map.deinit();
    
    const separator = "_";
    const modes = enum(u8) { Command, Dir, File };
    var paths = std.ArrayList([] const u8).init(gpa);
    // var level_total: usize = 0;
    var current_path = "";
    while(lines.next()) |line| {
        if(line.len != 0){
            const mode = switch(line[0]){
                '$' => modes.Command,
                'd' => modes.Dir,
                '0'...'9' => modes.File,
                else => unreachable
            };
            std.debug.print("modes = {}, {s}\n", .{ mode, line[2..4] });

            switch(mode) {
                modes.Command => if(mem.eql(u8, line[2..4], "cd")){
                    std.debug.print("cd mode\n", .{});
                    if(mem.eql(u8, line[5..],"..")) {
                        std.debug.print("moving one level up {s}\n", .{ line[5..] });
                        _ = paths.pop();
                    } else {
                        std.debug.print("adding {s} to path\n", .{ line[5..] });
                        try paths.append(line[5..]);
                    }
                },
                modes.File => {
                    var file_parts = mem.split(u8, line, " ");
                    var file_size = parseInt(usize, file_parts.next() orelse "0", 10);
                    std.debug.print("{s}/", .{ path_key(current_path, paths.items, separator) });
                    std.debug.print("file size = {any}\n", .{ file_size });
                },
                else => continue,
            }
        }
    }

    // std.debug.print("problem 1 solution = {}\n", .{ i });
    // std.debug.print("problem 2 solution = {}, {}\n", .{ total_lines, total_lines - uncontained_count });
}
