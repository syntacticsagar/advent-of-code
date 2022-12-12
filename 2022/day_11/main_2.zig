const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.StaticBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("input/main_input.txt");

const Op = enum {
    mul,
    add,
    square, // no arg
};

const Monkey = struct {
    items: std.ArrayListUnmanaged(u64),
    op: Op,
    op_arg: u64,
    test_val: u64,
    true_monkey: usize,
    false_monkey: usize,
    inspected_items: u64 = 0,
};

pub fn main() !void {
    var modulus: u64 = 1;
    var items_list = List(Monkey).init(gpa);
    var lines = tokenize(u8, data, "\n\r");
    while (lines.next()) |line| {
        assert(std.mem.startsWith(u8, line, "Monkey "));

        const items_str = lines.next().?;
        var items_it = tokenize(u8, items_str, " Startingitems:,");
        var items = List(u64).init(gpa);
        while (items_it.next()) |item_str| {
            try items.append(try parseInt(u64, item_str, 10));
        }

        const op_str = lines.next().?;
        const base_op = expect(op_str, "  Operation: new = old ").?;
        var op: Op = undefined;
        var op_arg: u64 = undefined;
        switch (base_op[0]) {
            '+' => {
                op = .add;
                op_arg = try parseInt(u64, base_op[2..], 10);
            },
            '*' => {
                if (std.mem.eql(u8, base_op[2..], "old")) {
                    op = .square;
                } else {
                    op = .mul;
                    op_arg = try parseInt(u64, base_op[2..], 10);
                }
            },
            else => unreachable,
        }
        const test_val = try parseInt(u64, expect(lines.next().?, "  Test: divisible by ").?, 10);
        const true_monkey = try parseInt(usize, expect(lines.next().?, "    If true: throw to monkey ").?, 10);
        const false_monkey = try parseInt(usize, expect(lines.next().?, "    If false: throw to monkey ").?, 10);
        try items_list.append(.{
            .items = items.moveToUnmanaged(),
            .op = op,
            .op_arg = op_arg,
            .test_val = test_val,
            .true_monkey = true_monkey,
            .false_monkey = false_monkey,
        });
        modulus *= test_val;
    }

    const monkeys1 = items_list.items;
    const monkeys2 = try gpa.dupe(Monkey, monkeys1);
    for (monkeys2) |*monkey| {
        const clone = try monkey.items.clone(gpa);
        monkey.items = clone;
    }

    const part1 = try monkeyBusiness(monkeys1, 20, 0);
    const part2 = try monkeyBusiness(monkeys2, 10000, modulus);

    print("part1: {}\npart2: {}\n", .{part1, part2});
}

fn monkeyBusiness(monkeys: []Monkey, rounds: usize, modulus: u64) !u64 {
    var round: usize = 0;
    while (round < rounds) : (round += 1) {
        for (monkeys) |*monkey| {
            for (monkey.items.items) |*item| {
                switch (monkey.op) {
                    .add => item.* += monkey.op_arg,
                    .mul => item.* *= monkey.op_arg,
                    .square => item.* *= item.*,
                }
                if (modulus == 0) {
                    item.* /= 3;
                } else {
                    item.* = item.* % modulus;
                }
                const target_monkey = if (item.* % monkey.test_val == 0) monkey.true_monkey else monkey.false_monkey;
                try monkeys[target_monkey].items.append(gpa, item.*);
            }
            monkey.inspected_items += monkey.items.items.len;
            monkey.items.items.len = 0;
        }
    }

    sort(Monkey, monkeys, {}, comptime sortField(Monkey, "inspected_items", desc(u64)));
    return monkeys[0].inspected_items * monkeys[1].inspected_items;
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min2 = std.math.min;
const min3 = std.math.min3;
const max2 = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;

const abs = util.abs;
const expect = util.expect;
const sortField = util.sortField;
const sliceGroup = util.sliceGroup;
const Grid = util.Grid;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
