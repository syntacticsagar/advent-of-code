const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const Int = std.math.big.Int;


const file_name = "./input/main_input.txt";
const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

fn find_common_letter(s_1: []const u8, s_2: []const u8) u16 {
    var r_1: u8 = 0;
    var r_2: u8 = 0;
    var len = s_1.len;
    var match_found: bool = false;
    while(r_1 < len){
        while(r_2 < len){
            if(s_1[r_1] == s_2[r_2]){
                match_found = true;
                switch(s_2[r_2]){
                    'a'...'z' => return @intCast(u16, s_2[r_2] - 'a') + 1,
                    'A'...'Z' => return @intCast(u16, s_2[r_2] - 'A') + 27,
                    else => unreachable
                }
            }
            r_2 += 1;
        }
        r_2 = 0;
        r_1 += 1;
    }
    return 0;
}

fn find_common_letter_2(s_1: []const u8, s_2: []const u8,  s_3: []const u8) u16 {
    var r_1: u8 = 0;
    var r_2: u8 = 0;
    var r_3: u8 = 0;
    var match_found: bool = false;
    while(r_1 < s_1.len){
        while(r_2 < s_2.len){
            if(s_1[r_1] == s_2[r_2]){
                while(r_3 < s_3.len){
                    if(s_1[r_1] == s_3[r_3]){
                        match_found = true;
                        switch(s_2[r_2]){
                            'a'...'z' => return @intCast(u16, s_2[r_2] - 'a') + 1,
                            'A'...'Z' => return @intCast(u16, s_2[r_2] - 'A') + 27,
                            else => unreachable
                        }
                    }
                    r_3 += 1;
                }
            }
            r_3 = 0;
            r_2 += 1;
        }
        r_2 = 0;
        r_1 += 1;
    }
    return 0;
}

pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    var lines = mem.split(u8, file_contents, "\n");
    var priorities_total: u16 = 0;

    while(lines.next()) |line| {
        // if(line.len != 0){
        //     var compartment_size = (line.len/2);
        //     const compartment_1 = line[0..compartment_size];
        //     const compartment_2 = line[compartment_size..line.len];
        //     // std.debug.print("{s} {s}\n", .{ compartment_1, compartment_2 });

        //     priorities_total += find_common_letter(compartment_1, compartment_2);
        // }
        if(line.len != 0){
            var line_2 = lines.next() orelse unreachable;
            var line_3 = lines.next() orelse unreachable;

            priorities_total += find_common_letter_2(line, line_2, line_3);
        }
    }

    // std.debug.print("problem 1 solution = {}\n", .{ priorities_total });
    std.debug.print("problem 2 solution = {}\n", .{ priorities_total });
}
