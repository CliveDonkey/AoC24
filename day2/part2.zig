const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    var reports = std.mem.splitAny(u8, file_content, "\n");

    var safeCount: u32 = 0;
    while (reports.next()) |report| {
        if (report.len < 1) continue;

        var strNums = std.mem.splitAny(u8, report, " ");

        var nums = std.ArrayList(u32).init(allocator);
        while (strNums.next()) |strNum| {
            try nums.append(try std.fmt.parseInt(u32, strNum, 10));
        }
        if (nums.items.len < 1) return;

        if (isSafe(nums.items)) {
            safeCount += 1;
        } else {
            for (0..nums.items.len) |i| {
                const removed = nums.orderedRemove(i);
                std.debug.print("{any}\n", .{nums.items});
                if (isSafe(nums.items)) {
                    try nums.insert(i, removed);
                    safeCount += 1;
                    std.debug.print("Success\n", .{});
                    break;
                }
                try nums.insert(i, removed);
                if (i == nums.items.len - 1) std.debug.print("Failed\n", .{});
            }
        }
    }
    std.debug.print("Number of safe reports: {d}\n", .{safeCount});
}

fn isSafe(nums: []const u32) bool {
    var safe = true;
    var prevNum = nums[0];
    if (nums[0] == nums[1]) return false;
    const isAscending = nums[0] < nums[1];

    for (nums[1..]) |num| {
        if (isAscending and prevNum < num and num < prevNum + 4) {
            prevNum = num;
            continue;
        }
        if (!isAscending and num + 4 > prevNum and prevNum > num) {
            prevNum = num;
            continue;
        }

        prevNum = num;
        safe = false;
        break;
    }

    return safe;
}
