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
            if (coordinate.items[cord_y][cord_x] != 'A') continue;
            sum += check_coord(cord_y, cord_x, coordinate.items);
        }
    }
    std.debug.print("sum: {d}\n", .{sum});
}

fn check_coord(y: usize, x: usize, coordinate: [][]const u8) u32 {
    var doesMatch1 = false;
    var doesMatch2 = false;

    //diagonal \ aka 1
    if (x > 0 and y > 0 and x < coordinate[0].len - 1 and y < coordinate.len - 2) { //safeguard against invalid dereference
        if ((coordinate[y - 1][x - 1] == 'M' and coordinate[y + 1][x + 1] == 'S') or (coordinate[y - 1][x - 1] == 'S' and coordinate[y + 1][x + 1] == 'M')) doesMatch1 = true;
    }

    //diagonal / aka 2
    if (x > 0 and y > 0 and x < coordinate[0].len - 1 and y < coordinate.len - 2) { //safeguard against invalid dereference
        if ((coordinate[y + 1][x - 1] == 'M' and coordinate[y - 1][x + 1] == 'S') or (coordinate[y + 1][x - 1] == 'S' and coordinate[y - 1][x + 1] == 'M')) doesMatch2 = true;
    }

    if (doesMatch1 and doesMatch2) return 1;
    return 0;
}
