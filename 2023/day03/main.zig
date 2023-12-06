const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const tokenizeAny = mem.tokenizeAny;
const parseInt = std.fmt.parseInt;
const Map = std.AutoHashMap;

const file_name = "./input/main_input.txt";

const data = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

pub fn main() !void {
    var gear_map = Map(usize, usize).init(gpa);
    var p1: usize = 0;
    var p2: usize = 0;
    const pitch = std.mem.indexOf(u8, data, "\n").? + 1;
    var val: ?i64 = null;
    var val_start: ?usize = null;
    for (data, 0..) |char, i| {
        if (std.ascii.isDigit(char)) {
            if (val_start == null) val_start = i;
            val = (if (val) |v| v * 10 else 0) + (char - '0');
        } else if (val_start) |start| {
            const symbol: ?usize = find_symbol: for (start - 1..i + 1) |j| {
                const above = if (j >= pitch) j - pitch else j;
                const along = j;
                const below = if (j + pitch < data.len) j + pitch else j;
                for ([_]usize{ above, along, below }) |k| {
                    if (data[k] != '.' and data[k] != '\n' and data[k] != '\r' and !std.ascii.isDigit(data[k])) {
                        break :find_symbol k;
                    }
                }
            } else null;

            if (symbol) |s| {
                const newval = parseInt(usize, data[start..i], 10) catch unreachable;
                p1 += newval;
                if (data[s] == '*') {
                    const gop = try gear_map.getOrPut(s);
                    if (gop.found_existing) {
                        p2 += gop.value_ptr.* * newval;
                        _ = gear_map.remove(s);
                    } else {
                        gop.value_ptr.* = newval;
                    }
                }
            }

            val_start = null;
            val = null;
        }
    }
    std.debug.print("p1: {}, p2: {}\n", .{ p1, p2 });
}
