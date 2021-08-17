const std = @import("std");

pub fn main() !void {
    const Type = u32;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = &gpa.allocator;
    var weights = std.ArrayList(Type).init(alloc);
    defer weights.deinit();

    const reader = std.io.getStdIn().reader();
    const max_size = @bitSizeOf(Type);

    // read lines, parse and sum numbers
    var sum: Type = 0;
    while(try reader.readUntilDelimiterOrEofAlloc(alloc, '\n', max_size)) |line| {
        if(std.fmt.parseUnsigned(Type, line, 0)) |num| {
            try weights.append(num);
            sum += num;
        } else |err| std.log.err("Invalid number: {any} ({any})", .{line, err});
        alloc.free(line);
    }

    // get random number
    const rng = &std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    }).random;
    const random = rng.uintLessThan(Type, sum);

    // get last item <= random
    var accumulator: Type = 0;
    for(weights.items) |num, index| {
        accumulator += num;
        if(accumulator > random) {
            try std.io.getStdOut().writer().print("{d}\n", .{index});
            return;
        }
    }

}
