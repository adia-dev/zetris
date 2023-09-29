pub const ROWS: i32 = 15;
pub const COLS: i32 = 15;

pub const SHAPE_WIDTH: i32 = 4;
pub const SHAPE_HEIGHT: i32 = 2;

pub const CELL_SIZE: i32 = 32;

pub const SHAPES_DATA = [7][SHAPE_HEIGHT][SHAPE_WIDTH]u8{
    [SHAPE_HEIGHT][SHAPE_WIDTH]u8{
        [_]u8{ 0, 0, 0, 0 },
        [_]u8{ 1, 1, 1, 1 },
    },
    [SHAPE_HEIGHT][SHAPE_WIDTH]u8{
        [_]u8{ 1, 0, 0, 0 },
        [_]u8{ 1, 1, 1, 0 },
    },
    [SHAPE_HEIGHT][SHAPE_WIDTH]u8{
        [_]u8{ 0, 0, 1, 0 },
        [_]u8{ 1, 1, 1, 0 },
    },
    [SHAPE_HEIGHT][SHAPE_WIDTH]u8{
        [_]u8{ 1, 1, 0, 0 },
        [_]u8{ 1, 1, 0, 0 },
    },
    [SHAPE_HEIGHT][SHAPE_WIDTH]u8{
        [_]u8{ 0, 1, 1, 0 },
        [_]u8{ 1, 1, 0, 0 },
    },
    [SHAPE_HEIGHT][SHAPE_WIDTH]u8{
        [_]u8{ 1, 1, 0, 0 },
        [_]u8{ 0, 1, 1, 0 },
    },
    [SHAPE_HEIGHT][SHAPE_WIDTH]u8{
        [_]u8{ 0, 1, 0, 0 },
        [_]u8{ 1, 1, 1, 0 },
    },
};

pub const SHAPES_DIMENSIONS = [7][2]u8{
    [2]u8{ 4, 1 },
    [2]u8{ 3, 2 },
    [2]u8{ 3, 2 },
    [2]u8{ 2, 2 },
    [2]u8{ 3, 2 },
    [2]u8{ 3, 2 },
    [2]u8{ 3, 2 },
};
