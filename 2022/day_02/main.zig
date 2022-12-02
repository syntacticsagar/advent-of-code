const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const Int = std.math.big.Int;


const file_name = "./input/main_input.txt";
const file_contents = @embedFile(file_name);
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

// scored for player_1
fn rps_score(move_1:[]const u8, move_2:[]const u8) u8 {
    const moves_1 = enum(u8) { X, Y, Z  };
    const moves_2 = enum(u8) { A, B, C  };

    const move_1_enum = std.meta.stringToEnum(moves_1, move_1) orelse unreachable;
    const move_2_enum = std.meta.stringToEnum(moves_2, move_2) orelse unreachable;
    const move_1_score = @enumToInt(move_1_enum);
    const move_2_score = @enumToInt(move_2_enum);

    var result = (move_1_score + 1);
    if(@mod(move_1_score + 1, 3) == move_2_score) {
        result += 0;
    } else if(move_1_score == move_2_score) {
        result += 3;
    } else {
        result +=  6;
    }

    return result;
}

fn modified_rps_score(opponent_move:[]const u8, strategy:[]const u8) i8 {
    const strategies = enum(i8) { X = 0, Y = 3, Z = 6 };
    const opponent_moves = enum(i8) { A, B, C  };

    const opponent_move_enum = std.meta.stringToEnum(opponent_moves, opponent_move) orelse unreachable;
    const turn_strategy = std.meta.stringToEnum(strategies, strategy) orelse unreachable;
    
    const opponent_move_score = @enumToInt(opponent_move_enum);
    var result = @enumToInt(turn_strategy);
    if(turn_strategy == strategies.X){
        result += @mod(opponent_move_score - 1, 3) + 1;
    } else if(turn_strategy == strategies.Y) {
        result += opponent_move_score + 1;
    } else {
        result += @mod(opponent_move_score + 1, 3) + 1;
    }

    return result;
}

pub fn main() !void {
    // std.debug.print("file contents = {s}\n", .{ file_contents });

    var lines = mem.split(u8, file_contents, "\n");
    var total_score_1: u64 = 0;
    var total_score_2:i64 = 0;

    while(lines.next()) |line| {
        if(line.len != 0){
            var moves = mem.tokenize(u8, line, " ");
            const opponent_move = moves.next() orelse unreachable;
            const my_move = moves.next() orelse unreachable;
            total_score_1 += rps_score(my_move, opponent_move);
            total_score_2 += modified_rps_score(opponent_move, my_move);
            // std.debug.print("{}\n", .{ modified_rps_score(opponent_move, my_move) });
        }
    }

    std.debug.print("problem 1 solution = {}\n", .{ total_score_1 });
    std.debug.print("problem 2 solution = {}\n", .{ total_score_2 });
    // std.debug.print("problem 2 solution = {}\n", .{ max_cals[0] + max_cals[1] + max_cals[2] });
}
