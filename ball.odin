/*
 * A simple POC to learn how to program in ODIN.
 * Pretty nice!
 *
 * Author: Prof. Dr. David Buzatto
 */
package main ;

import "core:fmt";
import rl "vendor:raylib";

GRAVITY :: 50;

Ball :: struct {
    pos: rl.Vector2,
    prevPos: rl.Vector2,
    vel: rl.Vector2,
    friction: f32,
    elasticity: f32,
    radius: f32,
    color: rl.Color,
    dragging: bool
};

ball: Ball;
pressOffset: rl.Vector2;

main :: proc() {

    rl.SetConfigFlags( {.MSAA_4X_HINT} );
    rl.InitWindow( 800, 450, "ODIN Test - Bouncing Ball" );
    defer rl.CloseWindow();

    init_game();

    rl.SetTargetFPS( 60 );

    for !rl.WindowShouldClose() {
        update_game();
        draw_game();
    }

}

init_game :: proc() {
    ball = Ball {
        pos = rl.Vector2{ 
			f32( rl.GetScreenWidth() / 2 ), 
			f32( rl.GetScreenHeight() / 2 )
		},
        vel = rl.Vector2{ 200, 200 },
        friction = 0.99,
        elasticity = 0.9,
        radius = 50,
        color = rl.BLUE,
        dragging = false
    };
}

update_game :: proc() {
    
    delta: f32 = rl.GetFrameTime();
    mousePos: rl.Vector2 = rl.GetMousePosition();

    if rl.IsMouseButtonPressed( .LEFT ) {
        if rl.CheckCollisionPointCircle( mousePos, ball.pos, ball.radius ) {
            ball.dragging = true;
            pressOffset.x = mousePos.x - ball.pos.x;
            pressOffset.y = mousePos.y - ball.pos.y;
        }
    } else if rl.IsMouseButtonReleased( .LEFT ) {
        ball.dragging = false;
    }

    if ball.dragging {

        ball.pos.x = mousePos.x - pressOffset.x;
        ball.pos.y = mousePos.y - pressOffset.y;

        ball.vel.x = ( ball.pos.x - ball.prevPos.x ) / delta;
        ball.vel.y = ( ball.pos.y - ball.prevPos.y ) / delta;

        ball.prevPos = ball.pos;

    } else {

        ball.pos.x += ball.vel.x * delta;
        ball.pos.y += ball.vel.y * delta;

        if ( ball.pos.x - ball.radius ) < 0 {
            ball.pos.x = ball.radius;
            ball.vel.x = - ball.vel.x * ball.elasticity;
        } else if ( ball.pos.x + ball.radius ) > f32( rl.GetScreenWidth() ) {
            ball.pos.x = f32( rl.GetScreenWidth() ) - ball.radius;
            ball.vel.x = - ball.vel.x * ball.elasticity;
        }

        if ( ball.pos.y - ball.radius ) < 0 {
            ball.pos.y = ball.radius;
            ball.vel.y = - ball.vel.y * ball.elasticity;
        } else if ( ball.pos.y + ball.radius ) > f32( rl.GetScreenHeight() ) {
            ball.pos.y = f32( rl.GetScreenHeight() ) - ball.radius;
            ball.vel.y = - ball.vel.y * ball.elasticity;
        }

        ball.vel.x *= ball.friction;
        ball.vel.y = ball.vel.y * ball.friction + GRAVITY;

    }

}

draw_game :: proc() {

    rl.BeginDrawing();
    defer rl.EndDrawing();

    rl.ClearBackground( rl.RAYWHITE );

    draw_ball( &ball );

}

draw_ball :: proc{ draw_ball_ball, draw_ball_radius };

draw_ball_ball :: proc( ball: ^Ball ) {
    rl.DrawCircle( i32( ball.pos.x ), i32( ball.pos.y ), ball.radius, ball.color );
}

draw_ball_radius :: proc( ball: ^Ball, radius: f32 ) {
    rl.DrawCircle( i32( ball.pos.x ), i32( ball.pos.y ), radius, ball.color );
}
