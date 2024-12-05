const std = @import("std");

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gp.allocator();
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    const file_content = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));

    const State = enum {
        searching,
        num1,
        num2,
    };

    var state: State = .searching;
    var patternMatch: u8 = 0;
    const pattern = "mul(";
    var num1: u32 = 0;
    var num2: u32 = 0;

    var sum: u32 = 0;
    for (file_content) |char| {
        switch (state) {
            .searching => {
                if (pattern[patternMatch] == char) {
                    patternMatch += 1;
                } else patternMatch = 0;

                if (patternMatch == 4) {
                    patternMatch = 0;
                    state = .num1;
                }
            },
            .num1 => {
                if (std.ascii.isDigit(char)) {
                    num1 *= 10;
                    num1 += try std.fmt.parseInt(u32, &[_]u8{char}, 10);
                    patternMatch += 1;
                } else if (char == ',' and 0 < patternMatch and patternMatch < 4) {
                    state = .num2;
                    patternMatch = 0;
                } else {
                    patternMatch = 0;
                    num1 = 0;
                    state = .searching;
                }

                if (patternMatch > 3) {
                    patternMatch = 0;
                    num1 = 0;
                    state = .searching;
                }
            },
            .num2 => {
                if (std.ascii.isDigit(char)) {
                    num2 *= 10;
                    num2 += try std.fmt.parseInt(u32, &[_]u8{char}, 10);
                    patternMatch += 1;
                } else if (char == ')' and 0 < patternMatch and patternMatch < 4) {
                    state = .searching;
                    patternMatch = 0;
                    sum += num1 * num2;
                    num1 = 0;
                    num2 = 0;
                } else {
                    patternMatch = 0;
                    num1 = 0;
                    num2 = 0;
                    state = .searching;
                }

                if (patternMatch > 3) {
                    patternMatch = 0;
                    num1 = 0;
                    num2 = 0;
                    state = .searching;
                }
            },
        }
    }
    std.debug.print("Sum is: {d}\n", .{sum});
}
