const std = @import("std");

const orderRule = struct { pre: u8, post: u8 };

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    var lines = std.mem.splitScalar(u8, file_content, '\n');

    var rules = std.ArrayList(orderRule).init(allocator);

    {
        var line = lines.next();
        while (line.?.len != 0) : (line = lines.next()) {
            const rule = orderRule{
                .pre = try std.fmt.parseInt(u8, line.?[0..2], 10),
                .post = try std.fmt.parseInt(u8, line.?[3..5], 10),
            };
            try rules.append(rule);
        }
    }

    var updates = std.ArrayList([]u8).init(allocator);

    while (lines.next()) |line| {
        var nums = std.ArrayList(u8).init(allocator);
        var strNums = std.mem.splitScalar(u8, line, ',');
        while (strNums.next()) |strNum| {
            if (strNum.len < 1) continue;
            try nums.append(try std.fmt.parseInt(u8, strNum[0..2], 10));
        }
        try updates.append(nums.items);
    }

    var sum: u32 = 0;
    for (updates.items) |update| {
        if (update.len < 1) continue;
        var valid = true;
        for (rules.items) |rule| {
            const preIndex = std.mem.indexOf(u8, update, &[_]u8{rule.pre});
            const postIndex = std.mem.indexOf(u8, update, &[_]u8{rule.post});

            if (postIndex == null or preIndex == null) continue;
            if (postIndex.? < preIndex.?) valid = false;
        }
        if (valid) sum += update[(update.len - 1) / 2];
    }
    std.debug.print("Sum is: {d}\n", .{sum});
}
