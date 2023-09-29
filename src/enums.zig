const raylib = @import("raylib");
pub const BlockShape = enum(u8) { I = 1, J, L, O, S, Z, T };
pub const Rotation = enum { NORTH, EAST, SOUTH, WEST };

pub fn blockShapeToColor(shape: BlockShape) raylib.Color {
    switch (shape) {
        .I => return raylib.BLUE,
        .J => return raylib.DARKBLUE,
        .L => return raylib.ORANGE,
        .O => return raylib.YELLOW,
        .S => return raylib.GREEN,
        .Z => return raylib.RED,
        .T => return raylib.MAGENTA,
    }
}
