const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));

    //convert to coordinates:
    var lines = std.mem.splitScalar(u8, file_content, '\n');

    var coordinate = std.ArrayList([]const u8).init(allocator);
    while (lines.next()) |line| {
        try coordinate.append(line);
    }
    const x_max = coordinate.items[0].len;
    const y_max = coordinate.items.len;

    var sum: u32 = 0;
    for (0..y_max) |cord_y| {
        if (coordinate.items[cord_y].len < 1) continue;
        for (0..x_max) |cord_x| {
            if (coordinate.items[cord_y][cord_x] != 'X') continue;
            sum += check_coord(cord_y, cord_x, coordinate.items);
        }
    }
    std.debug.print("sum: {d}\n", .{sum});
}

fn check_coord(y: usize, x: usize, coordinate: [][]const u8) u32 {
    const match = "XMAS";
    var matches: u32 = 0;
    var doesMatch = false;

    //Horizontal before
    doesMatch = true;
    if (x > 2) {
        for (1..4) |off| {
            if (match[off] != coordinate[y][x - off]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }
    //horizontal after
    doesMatch = true;
    if (x < coordinate[0].len - 3) {
        for (1..4) |off| {
            if (match[off] != coordinate[y][x + off]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }

    //vertical before:
    doesMatch = true;
    if (y > 2) {
        for (1..4) |off| {
            if (match[off] != coordinate[y - off][x]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }
    //vertical after:
    doesMatch = true;
    if (y < coordinate.len - 4) {
        for (1..4) |off| {
            if (match[off] != coordinate[y + off][x]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }

    //diagonal\ before:
    doesMatch = true;
    if (y > 2 and x > 2) {
        for (1..4) |off| {
            if (match[off] != coordinate[y - off][x - off]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }
    //diagonal\ after:
    doesMatch = true;
    if (y < coordinate.len - 4 and x < coordinate[0].len - 3) {
        for (1..4) |off| {
            if (match[off] != coordinate[y + off][x + off]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }
    //diagonal/ before:
    doesMatch = true;
    if (y > 2 and x < coordinate[0].len - 3) {
        for (1..4) |off| {
            if (match[off] != coordinate[y - off][x + off]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }
    //diagonal/ after:
    doesMatch = true;
    if (y < coordinate.len - 4 and x > 2) {
        for (1..4) |off| {
            if (match[off] != coordinate[y + off][x - off]) {
                doesMatch = false;
                break;
            }
        }
        if (doesMatch) matches += 1;
    }

    return matches;
}
