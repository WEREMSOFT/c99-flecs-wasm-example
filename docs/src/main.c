#include <stdio.h>
#include <time.h>
#include "flecs.h"

ecs_world_t *world;

#if defined(PLATFORM_WEB)
#include <emscripten/emscripten.h>
void game_update() {
    ecs_progress(world, 0);
}
#endif

int sum(int x, int y){
    return x + y;
}

typedef struct Position {
    float x;
    float y;
} Position;

typedef float Speed;

void Move(ecs_iter_t *rows) {
    ECS_COLUMN(rows, Position, p, 1);
    ECS_COLUMN(rows, Speed, s, 2);

    printf("updating Move function form FLECS!!!! -> %f\n", rows->delta_time);

    for (int i = 0; i < rows->count; i ++) {
        p[i].x += s[i] * rows->delta_time;
        p[i].y += s[i] * rows->delta_time;
    }
}

int main(int argc, char *argv[]){
    #ifdef OS_Windows_NT
    printf("Windows dettected\n");
    #elif defined OS_Linux
    printf("LINUS dettected\n");
    #elif defined OS_Darwin
    printf("MacOS dettected\n");
    #elif defined PLATFORM_WEB
    printf("WebBrowser dettected\n");
    #endif

    world = ecs_init_w_args(argc, argv);

    ECS_COMPONENT(world, Position);
    ECS_COMPONENT(world, Speed);
    ECS_SYSTEM(world, Move, EcsOnUpdate, Position, Speed);
    ECS_ENTITY(world, MyEntity, Position, Speed);
    
    ecs_set(world, MyEntity, Position, {0, 0});
    ecs_set(world, MyEntity, Speed, {1});
    
    #ifdef PLATFORM_WEB
        emscripten_set_main_loop(game_update, 0, 1);
    #else
        while (ecs_progress(world, 0));
    #endif

    return ecs_fini(world);

    return 0;
}