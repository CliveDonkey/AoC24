const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    const lineNumber = 1000;
    defer file.close();

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    var numbers = std.mem.splitAny(u8, file_content, "\n ");

    var list1: [lineNumber]u32 = undefined;
    var list2: [lineNumber]u32 = undefined;

    var count: usize = 0;
    var whatList = false;

    while (numbers.next()) |number| {
        if (number.len == 0) continue;
        if (whatList) {
            list2[count / 2] = try std.fmt.parseInt(u32, number, 10);
        } else {
            list1[count / 2] = try std.fmt.parseInt(u32, number, 10);
        }

        count += 1;
        whatList = !whatList;
    }

    //we now have our numbers as ints, lets sort:
    std.mem.sort(u32, &list1, {}, std.sort.asc(u32));
    std.mem.sort(u32, &list2, {}, std.sort.asc(u32));

    //searching for numbers in first list and adding to sum
    var sum: u32 = 0;

    for (list1) |element1| {
        const indencies = std.sort.equalRange(u32, &list2, element1, compInt);
        std.debug.print("{d}\t{any}\n", .{ element1, indencies });

        //checking for returnvalues where element1 not found, in that case, do nothing
        if (indencies[0] >= list2.len) continue;
        std.debug.print("{d}\t{d}\n", .{ list2[indencies[0]], element1 });
        if (list2[indencies[0]] != element1) continue;
        std.debug.print("\tI ran!\n", .{});

        const length1: u32 = @truncate(indencies[1]);
        const length2: u32 = @truncate(indencies[0]);
        std.debug.print("{d}\n", .{length1 - length2 + 1});
        sum += element1 * (length1 - length2);
    }

    std.debug.print("Result: {d}\n", .{sum});
}

fn compInt(a: u32, b: u32) std.math.Order {
    if (a == b) return std.math.Order.eq;
    if (a > b) return std.math.Order.gt;
    return std.math.Order.lt;
}
