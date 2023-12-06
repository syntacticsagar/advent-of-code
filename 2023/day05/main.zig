const std = @import("std");

// useful stdlib functions
const mem = std.mem;
const assert = std.debug.assert;
const tokenizeAny = mem.tokenizeAny;
const parseInt = std.fmt.parseInt;
const ArrayList = std.ArrayList;
var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const file_name = "./input/main_input.txt";

const Mapping = struct {
    destination: u64,
    source: u64,
    range: u64,
    pub fn inRange(self: Mapping, val: u64) bool {
        return val >= self.source and val <= self.source + self.range - 1;
    }

    pub fn getRange(self: Mapping, val: u64) u64 {
        return self.destination + (val - self.source);
    }
};

const data = @embedFile(file_name);

pub fn main() !void {
    var lines = tokenizeAny(u8, data, "\r\n");
    var p1: ?u64 = null;
    var p2: ?u64 = null;

    var seeds = tokenizeAny(u8, lines.next() orelse unreachable, "seeds: ");

    var seedToSoilMap = ArrayList(Mapping).init(gpa);
    var soilToFertMap = ArrayList(Mapping).init(gpa);
    var fertToWaterMap = ArrayList(Mapping).init(gpa);
    var waterToLightMap = ArrayList(Mapping).init(gpa);
    var lightToTempMap = ArrayList(Mapping).init(gpa);
    var tempToHumidityMap = ArrayList(Mapping).init(gpa);
    var humidityToLocationMap = ArrayList(Mapping).init(gpa);
    defer seedToSoilMap.deinit();
    defer soilToFertMap.deinit();
    defer fertToWaterMap.deinit();
    defer waterToLightMap.deinit();
    defer lightToTempMap.deinit();
    defer tempToHumidityMap.deinit();
    defer humidityToLocationMap.deinit();

    var state: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        if (std.mem.eql(u8, line, "seed-to-soil map:")) {
            state = 1;
        } else if (std.mem.eql(u8, line, "soil-to-fertilizer map:")) {
            state = 2;
        } else if (std.mem.eql(u8, line, "fertilizer-to-water map:")) {
            state = 3;
        } else if (std.mem.eql(u8, line, "water-to-light map:")) {
            state = 4;
        } else if (std.mem.eql(u8, line, "light-to-temperature map:")) {
            state = 5;
        } else if (std.mem.eql(u8, line, "temperature-to-humidity map:")) {
            state = 6;
        } else if (std.mem.eql(u8, line, "humidity-to-location map:")) {
            state = 7;
        } else {
            var map = tokenizeAny(u8, line, " ");
            const mapping = Mapping{ .destination = try parseInt(u64, map.next() orelse unreachable, 10), .source = try parseInt(u64, map.next() orelse unreachable, 10), .range = try parseInt(u64, map.next() orelse unreachable, 10) };

            try switch (state) {
                1 => seedToSoilMap.append(mapping),
                2 => soilToFertMap.append(mapping),
                3 => fertToWaterMap.append(mapping),
                4 => waterToLightMap.append(mapping),
                5 => lightToTempMap.append(mapping),
                6 => tempToHumidityMap.append(mapping),
                7 => humidityToLocationMap.append(mapping),
                else => unreachable,
            };
        }
    }
    while (seeds.next()) |seed| {
        const seedVal = try parseInt(u64, seed, 10);
        var acc: u64 = seedVal;
        for ([_]ArrayList(Mapping){ seedToSoilMap, soilToFertMap, fertToWaterMap, waterToLightMap, lightToTempMap, tempToHumidityMap, humidityToLocationMap }) |map| {
            acc = find_range_val: for (map.items) |item| {
                if (item.inRange(acc)) {
                    const rangeVal: u64 = item.getRange(acc);
                    break :find_range_val rangeVal;
                }
            } else acc;
        }
        if (p1 == null) {
            p1 = acc;
        } else if (acc < p1.?) {
            p1 = acc;
        }
    }

    seeds.reset();
    while (seeds.next()) |seed| {
        const seedValStart = try parseInt(u64, seed, 10);
        const range = try parseInt(u64, seeds.next() orelse unreachable, 10);

        for (seedValStart..seedValStart + range) |seedVal| {
            var acc: u64 = seedVal;
            for ([_]ArrayList(Mapping){ seedToSoilMap, soilToFertMap, fertToWaterMap, waterToLightMap, lightToTempMap, tempToHumidityMap, humidityToLocationMap }) |map| {
                acc = find_range_val: for (map.items) |item| {
                    if (item.inRange(acc)) {
                        const rangeVal: u64 = item.getRange(acc);
                        break :find_range_val rangeVal;
                    }
                } else acc;
            }
            if (p2 == null) {
                std.debug.print("seedVal {} acc {}\n", .{ seedVal, acc });
                p2 = acc;
            } else if (acc < p2.?) {
                std.debug.print("seedVal {} acc {}\n", .{ seedVal, acc });
                p2 = acc;
            }
        }
    }

    std.debug.print("\np1: {} p2: {}\n", .{ p1.?, p2.? });
}
