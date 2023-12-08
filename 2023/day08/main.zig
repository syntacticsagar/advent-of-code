const std = @import("std");
const tokenizeAny = std.mem.tokenizeAny;
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const ArrayList = std.ArrayList;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const data = @embedFile("input/main_input.txt");

pub fn main() !void {
    var lines = tokenizeAny(u8, data, "\r\n");

    var p1: u64 = 0;
    var p2: u64 = 0;
    const start: []const u8 = "AAA";
    const end: []const u8 = "ZZZ";

    var bossStart = ArrayList([]const u8).init(gpa);
    var bossEnd = ArrayList([]const u8).init(gpa);
    defer bossStart.deinit();
    defer bossEnd.deinit();

    const instructions = lines.next() orelse unreachable;
    var map = StrMap([2][]const u8).init(gpa);
    defer map.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var nodes = tokenizeAny(u8, line, "(=, )");
        const sourceNode = nodes.next() orelse unreachable;
        if (sourceNode[2] == 'A') {
            try bossStart.append(sourceNode);
        }
        const left = nodes.next() orelse unreachable;
        const right = nodes.next() orelse unreachable;
        try map.put(sourceNode, [2][]const u8{ left, right });
    }

    for (bossEnd.items) |node| {
        std.debug.print("{s}\n", .{node});
    }

    var nextNode = start;
    while (true) {
        const direction: u8 = if (instructions[@mod(p1, instructions.len)] == 'L') 0 else 1;
        nextNode = map.get(nextNode).?[direction];
        p1 += 1;
        if (std.mem.eql(u8, nextNode, end)) break;
    }
    std.debug.print("p1: {}, p2: {}\n", .{ p1, p2 });

    for (bossStart.items) |node| {
        p2 = 0;
        nextNode = node;
        std.debug.print("On node {s}\n", .{node});

        while (true) {
            const direction: u8 = if (instructions[@mod(p2, instructions.len)] == 'L') 0 else 1;
            nextNode = map.get(nextNode).?[direction];
            p2 += 1;
            if (nextNode[2] == 'Z') {
                std.debug.print("{s} -> {s} in {} steps\n", .{ node, nextNode, p2 });
                break;
            }
        }
    }
    std.debug.print("p1: {}, p2: {}\n", .{ p1, p2 });
}
