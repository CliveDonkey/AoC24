const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    var numbers = std.mem.splitAny(u8, file_content, "\n ");

    var list1: [1000]u32 = undefined;
    var list2: [1000]u32 = undefined;

    var count: usize = 0;
    var whatList = false;

    while (numbers.next()) |number| {
        if (number.len == 0) continue;
        if (whatList) {
            std.debug.print("{s}\n", .{number});
            list2[count / 2] = try std.fmt.parseInt(u32, number, 10);
        } else {
            std.debug.print("{s}\t", .{number});
            list1[count / 2] = try std.fmt.parseInt(u32, number, 10);
        }

        count += 1;
        whatList = !whatList;
    }

    //we now have our numbers as ints, lets sort:
    std.mem.sort(u32, &list1, {}, std.sort.asc(u32));
    std.mem.sort(u32, &list2, {}, std.sort.asc(u32));

    //chad avansert for-loop og ikke boomerloop:
    //her sammenlignes og summeres opp
    var sum: u32 = 0;
    if (list1.len != list2.len) return error.unequaLength;
    for (list1, list2) |element1, element2| {
        sum += if (element1 > element2) element1 - element2 else element2 - element1;
    }

    std.debug.print("Result: {d}\n", .{sum});
}
