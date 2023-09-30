const std = @import("std");
const raylib = @import("raylib");
const enums = @import("enums.zig");
const constants = @import("constants.zig");

const Self = @This();

x: i32 = 0,
y: i32 = 0,
rotation: usize = 0,
block_shape: enums.BlockShape,
rand: std.rand.DefaultPrng = undefined,

pub fn init(self: *Self, seed: u64) void {
    self.*.rand = std.rand.DefaultPrng.init(seed);
}

pub fn render(self: *Self) void {
    var shape = constants.SHAPES_DATA[@intFromEnum(self.block_shape) - 1];

    for (0..constants.SHAPE_HEIGHT) |i| {
        for (0..constants.SHAPE_WIDTH) |j| {
            if (shape[i][j] == 1) {
                var i32_i: i32 = @intCast(i);
                var i32_j: i32 = @intCast(j);
                var color = enums.blockShapeToColor(self.block_shape);

                raylib.DrawRectangle((self.x + i32_j) * constants.CELL_SIZE, (self.y + i32_i) * constants.CELL_SIZE, constants.CELL_SIZE, constants.CELL_SIZE, color);
            }
        }
    }
}

pub fn update(self: *Self, map: *[constants.ROWS][constants.COLS]u8) void {
    self.*.y += 1;

    if (self.checkCollisions(map) == true) {
        self.*.y -= 1;
        self.apply(map);
    }
}

pub fn move(self: *Self, x: i32, y: i32, map: *[constants.ROWS][constants.COLS]u8) void {
    var shape_id = @intFromEnum(self.block_shape);
    var dimensions = constants.SHAPES_DIMENSIONS[shape_id - 1];
    var inverted = self.rotation % 2 == 1;

    var width = if (inverted) dimensions[1] else dimensions[0];
    var height = if (inverted) dimensions[0] else dimensions[1];

    self.*.x = @max(@min(self.x + x, constants.COLS - width), 0);
    self.*.y = @max(@min(self.y + y, constants.ROWS - height), 0);

    if (self.checkCollisions(map)) {
        self.*.x -= x;
        self.*.y -= y;
    }
}

pub fn drop(self: *Self, map: *[constants.ROWS][constants.COLS]u8) void {
    while (!self.checkCollisions(map)) : (self.*.y += 1) {}
    self.*.y -= 1;
    self.apply(map);
}

pub fn checkCollisions(self: *Self, map: *[constants.ROWS][constants.COLS]u8) bool {
    var shape_index = @intFromEnum(self.block_shape) - 1;
    var shape = constants.SHAPES_DATA[shape_index];

    for (0..constants.SHAPE_HEIGHT) |i| {
        for (0..constants.SHAPE_WIDTH) |j| {
            var usize_x: usize = @intCast(self.x);
            var usize_y: usize = @intCast(self.y);

            var x = if (self.rotation % 2 == 1) usize_y + i else usize_x + j;
            var y = if (self.rotation % 2 == 1) usize_x + j else usize_y + i;

            if (shape[i][j] == 1 and ((x >= constants.COLS or y >= constants.ROWS) or (map[y][x] > 0))) {
                return true;
            }
        }
    }

    return false;
}

pub fn apply(self: *Self, map: *[constants.ROWS][constants.COLS]u8) void {
    var shape_index = @intFromEnum(self.block_shape);
    var shape = constants.SHAPES_DATA[shape_index - 1];

    for (0..constants.SHAPE_HEIGHT) |i| {
        for (0..constants.SHAPE_WIDTH) |j| {
            var usize_x: usize = @intCast(self.x);
            var usize_y: usize = @intCast(self.y);

            if (shape[i][j] == 1) {
                map[usize_y + i][usize_x + j] = shape_index;
            }
        }
    }

    self.checkLines(map);
    self.spawn();
}

pub fn checkLines(self: *Self, map: *[constants.ROWS][constants.COLS]u8) void {
    _ = self;
    for (0..constants.ROWS) |i| {
        var is_full = true;
        for (0..constants.COLS) |j| {
            if (map[i][j] == 0) {
                is_full = false;
                break;
            }
        }
        if (is_full) {
            removeLine(i, map);
        }
    }
}

pub fn removeLine(row: usize, map: *[constants.ROWS][constants.COLS]u8) void {
    for (0..constants.COLS) |i| {
        map[row][i] = 0;
    }

    std.debug.print("row: {d}\n", .{row});

    if (row == 0)
        return;

    var i = row;
    while (i > 0) {
        for (0..constants.COLS) |j| {
            map[i][j] = map[i - 1][j];
        }
        i -= 1;
    }
}

pub fn spawn(self: *Self) void {
    self.*.x = 4;
    self.*.y = 0;

    var random_block_shape = self.rand.random().enumValueWithIndex(enums.BlockShape, u8);
    self.*.block_shape = random_block_shape;
}
