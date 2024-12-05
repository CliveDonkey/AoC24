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

        if (nums.items[0] == nums.items[1]) continue;

        var isSafe = true;
        var prevNum = nums.items[0];
        const isAscending = nums.items[0] < nums.items[1];

        for (nums.items[1..]) |num| {
            if (isAscending and prevNum < num and num < prevNum + 4) {
                prevNum = num;
                continue;
            }
            if (!isAscending and num + 4 > prevNum and prevNum > num) {
                prevNum = num;
                continue;
            }

            prevNum = num;
            isSafe = false;
            break;
        }
        if (isSafe) safeCount += 1;
    }
    std.debug.print("Number of safe reports: {d}\n", .{safeCount});
}
