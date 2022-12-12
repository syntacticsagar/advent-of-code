const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const assert = std.debug.assert;

const file_name = "./input/sample_input.txt";
const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();
const NumStacks =  5;

const ColStack = struct {
    stacks: [NumStacks]std.ArrayListUnmanaged(u8),

    pub fn init() ColStack {
        return .{
            .stacks = [_]std.ArrayListUnmanaged(u8){ .{} } ** NumStacks,
        };
    }
    
    pub fn clone(self: *ColStack) !ColStack {
        var result = ColStack.init();
        errdefer result.deinit();
        for (self.stacks) |*stack, i| {
            result.stacks[i] = try stack.clone(gpa);
        }
        return result;
    }

    pub fn deinit(self: *ColStack) void {
        for (self.stacks) |*stack| {
            stack.deinit(gpa);
        }
    }

    pub fn inspect(self: ColStack) void {
        for (self.stacks) |*stack| {
            for(stack.items) |item| {
                std.debug.print("{d} ", .{item});
            }
            std.debug.print("\n", .{ });
        }
    }
};


pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    var lines = mem.split(u8, file_contents, "\n");
    var col_stack = ColStack.init();
    var line_count: usize = 0;
    var part1: usize = 4 * (NumStacks - 1);
    while(lines.next()) |line| {
        std.debug.print("{} {}\n", .{ line_count, line_count != 0 });
        var k: usize = 0;
        while(k < line.len):  (k += 1){
            col_stack.stacks[k].append(line[k]);
        }

        if((line.len != 0) and (line_count != 0 and line_count != NumStacks - 1)){
            var i: usize = 1;
            while(i < line.len - 1): (i += 1) {
                var j: usize = 0;
                var visible: bool = true;
                while(j < i): (j += 1) {
                    //visibility from left
                    if(line[i] <= line[j]){
                        visible = false;
                        break;
                    }
                }
                if(visible) {
                    std.debug.print("visible left: {d}   {} {}\n", .{ line[i] - '0' , line_count, i });
                    part1 += 1;
                    continue;
                } else {
                    std.debug.print("not visible left: {d}   {} {}\n", .{ line[i] - '0' , line_count, i });
                }

                visible = true;
                j = i + 1;
                while(j < line.len): (j += 1) {
                    //visibility from right
                    if(line[i] <= line[j]){
                        visible = false;
                        break;
                    }
                }
                if(visible) {
                    std.debug.print("visible right: {d}   {} {}\n", .{ line[i] - '0' , line_count, i });
                    part1 += 1;
                    continue;
                } else {
                    std.debug.print("not visible right: {d}   {} {}\n", .{ line[i] - '0' , line_count, i });
                }
            }
        }
        line_count += 1;
    }

    std.debug.print("problem 1 solution = {}\n", .{ part1 });
    // std.debug.print("problem 2 solution = {}, {}\n", .{ total_lines, total_lines - uncontained_count });
}
