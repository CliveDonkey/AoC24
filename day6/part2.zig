const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));

    //convert to coordinates:
    var lines = std.mem.splitScalar(u8, file_content, '\n');

    var coordinate = std.ArrayList([]u8).init(allocator);
    while (lines.next()) |line| {
        if (line.len < 1) continue;
        var newLine = try allocator.alloc(u8, line.len);
        newLine[0] = 69;
        std.mem.copyForwards(u8, newLine, line);
        try coordinate.append(newLine);
    }
    const x_max = coordinate.items[0].len;
    const y_max = coordinate.items.len;

    var guard_x: usize = undefined;
    var guard_y: usize = undefined;

    //find player-pos at start
    for (coordinate.items, 0..coordinate.items.len) |x_line, y| {
        for (x_line, 0..x_line.len) |x_pos, x| {
            if (x_pos == '^') {
                guard_x = x;
                guard_y = y;
            }
        }
    }

    const Guard_direction = enum {
        up,
        right,
        down,
        left,
    };

    var count: u32 = 0;
    var dir: Guard_direction = .up;
    while (0 < guard_x and guard_x < x_max and 0 < guard_y and guard_y < y_max - 1) : (switch (dir) {
        .up => guard_y -= 1,
        .down => guard_y += 1,
        .left => guard_x -= 1,
        .right => guard_x += 1,
    }) {
        if (coordinate.items[guard_y][guard_x] != 'x') {
            coordinate.items[guard_y][guard_x] = 'x';
            count += 1;
        }

        //nextPos:
        switch (dir) {
            .up => {
                if (coordinate.items[guard_y - 1][guard_x] == '#') dir = .right;
            },
            .down => {
                if (coordinate.items[guard_y + 1][guard_x] == '#') dir = .left;
            },
            .left => {
                if (coordinate.items[guard_y][guard_x - 1] == '#') dir = .up;
            },
            .right => {
                if (coordinate.items[guard_y][guard_x + 1] == '#') dir = .down;
            },
        }
    } else {
        coordinate.items[guard_y][guard_x] = 'x';
        count += 1;
    }
    std.debug.print("Count: {d}\n", .{count});
}
