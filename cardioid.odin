/*
 * A simple POC to learn how to program in ODIN.
 * Pretty nice!
 *
 * Author: Prof. Dr. David Buzatto
 */
package main ;

import "core:fmt";
import "core:math";
import rl "vendor:raylib";

Cardioid :: struct {
    pos: rl.Vector2,
    radius: f32,
    points: i32
};

card: Cardioid;
multiplier: i32;

main :: proc() {

    rl.SetConfigFlags( {.MSAA_4X_HINT} );
    rl.InitWindow( 800, 800, "ODIN Test - Cardioid" );
    defer rl.CloseWindow();

    init_game();

    rl.SetTargetFPS( 60 );

    for !rl.WindowShouldClose() {
        update_game();
        draw_game();
    }

}

init_game :: proc() {
    card = Cardioid{
        pos = rl.Vector2{
            f32( rl.GetScreenWidth() ) / 2,
            f32( rl.GetScreenHeight() ) / 2
        },
        radius = 300,
        points = 60
    };
    multiplier = 2;
}

update_game :: proc() {
    
    delta: f32 = rl.GetFrameTime();

    if rl.IsKeyUp( .ENTER ) {

        if rl.IsKeyPressed( .UP ) {
            multiplier += 1;
        } else if rl.IsKeyPressed( .DOWN ) {
            multiplier -= 1;
        }
    
        if rl.IsKeyPressed( .RIGHT ) {
            card.points += 1;
        } else if rl.IsKeyPressed( .LEFT ) {
            card.points -= 1;
        }

    } else if rl.IsKeyDown( .ENTER ) {

        if rl.IsKeyDown( .UP ) {
            multiplier += 1;
        } else if rl.IsKeyDown( .DOWN ) {
            multiplier -= 1;
        }
    
        if rl.IsKeyDown( .RIGHT ) {
            card.points += 1;
        } else if rl.IsKeyDown( .LEFT ) {
            card.points -= 1;
        }

    }

    if multiplier < 2 {
        multiplier = 2;
    }

    if card.points < 1 {
        card.points = 1;
    }
    

}

draw_game :: proc() {

    rl.BeginDrawing();
    defer rl.EndDrawing();

    rl.ClearBackground( rl.RAYWHITE );

    draw_cardioid( &card );

}

draw_cardioid :: proc( card: ^Cardioid ) {

    angInc: f32 = 360.0 / f32( card.points );
    angle: f32 = 180.0;

    for i in 0..<card.points {
        x: i32 = i32( card.pos.x + math.cos_f32( math.to_radians_f32( angle + angInc * f32( i ) ) ) * card.radius );
        y: i32 = i32( card.pos.y + math.sin_f32( math.to_radians_f32( angle + angInc * f32( i ) ) ) * card.radius );
        rl.DrawCircle( x, y, 3, rl.BLACK );
    }

    for i in 0..<card.points {
        x1: i32 = i32( card.pos.x + math.cos_f32( math.to_radians_f32( angle + angInc * f32( i ) ) ) * card.radius );
        y1: i32 = i32( card.pos.y + math.sin_f32( math.to_radians_f32( angle + angInc * f32( i ) ) ) * card.radius );
        x2: i32 = i32( card.pos.x + math.cos_f32( math.to_radians_f32( angle + angInc * f32( i * multiplier ) ) ) * card.radius );
        y2: i32 = i32( card.pos.y + math.sin_f32( math.to_radians_f32( angle + angInc * f32( i * multiplier ) ) ) * card.radius );
        rl.DrawLine( x1, y1, x2, y2, rl.BLACK );
    }

    rl.DrawText( rl.TextFormat( "points: %d", card.points ), 20, 20, 20, rl.BLACK );
    rl.DrawText( rl.TextFormat( "multiplier: %d", multiplier ), 20, 40, 20, rl.BLACK );

}
