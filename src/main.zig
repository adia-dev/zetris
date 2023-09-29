const raylib = @import("raylib");
const enums = @import("enums.zig");
const constants = @import("constants.zig");
const Zetromino = @import("zetromino.zig");

pub fn main() void {
    raylib.SetConfigFlags(raylib.ConfigFlags{ .FLAG_WINDOW_RESIZABLE = true });
    raylib.InitWindow(constants.ROWS * constants.CELL_SIZE, constants.COLS * constants.CELL_SIZE, "Zetris");
    raylib.SetTargetFPS(60);

    defer raylib.CloseWindow();

    var timer: f32 = 0.0;
    var delay_ms: f32 = 500.0;

    var z_tromino = Zetromino{ .x = 4, .y = 0, .block_shape = .S };
    z_tromino.init(42);

    var map: [constants.COLS][constants.ROWS]u8 = undefined;

    for (0..constants.COLS) |i| {
        for (0..constants.COLS) |j| {
            map[i][j] = 0;
        }
    }

    map[13][1] = 1;
    map[14][1] = 1;
    map[14][2] = 1;
    map[14][3] = 1;

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        defer raylib.EndDrawing();

        var delta_time_ms = raylib.GetFrameTime() * 1_000;
        timer += delta_time_ms;

        if (timer >= delay_ms) {
            z_tromino.update(&map);

            timer = 0.0;
            delay_ms *= 0.99;
        }

        if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_UP)) z_tromino.rotation = (z_tromino.rotation + 1) % 4;

        if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_RIGHT)) z_tromino.move(1, 0, &map);
        if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_LEFT)) z_tromino.move(-1, 0, &map);
        if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_DOWN)) z_tromino.move(0, 1, &map);

        if (raylib.IsKeyDown(raylib.KeyboardKey.KEY_SPACE)) z_tromino.drop(&map);

        raylib.ClearBackground(raylib.BLACK);

        for (0..constants.COLS) |i| {
            for (0..constants.ROWS) |j| {
                var i32_i: i32 = @intCast(i);
                var i32_j: i32 = @intCast(j);

                raylib.DrawRectangleLines(i32_j * constants.CELL_SIZE, i32_i * constants.CELL_SIZE, constants.CELL_SIZE, constants.CELL_SIZE, raylib.Color{ .r = 255, .g = 255, .b = 255, .a = 100 });

                if (map[i][j] != 0) {
                    raylib.DrawRectangle(i32_j * constants.CELL_SIZE, i32_i * constants.CELL_SIZE, constants.CELL_SIZE, constants.CELL_SIZE, enums.blockShapeToColor(@enumFromInt(map[i][j])));
                }
            }
        }

        z_tromino.render();

        raylib.DrawFPS(10, 10);
    }
}
