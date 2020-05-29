typedef struct Position {
    float x;
    float y;
} Position;

typedef float Speed;

void Move(ecs_rows_t *rows) {
    ECS_COLUMN(rows, Position, p, 1);
    ECS_COLUMN(rows, Speed, s, 2);
    
    for (int i = 0; i < rows->count; i ++) {
        p[i].x += s[i] * rows->delta_time;
        p[i].y += s[i] * rows->delta_time;
    }
}

int main(int argc, char *argv[]) {
    ecs_world_t *world = ecs_init_w_args(argc, argv);

    ECS_COMPONENT(world, Position);
    ECS_COMPONENT(world, Speed);
    ECS_SYSTEM(world, Move, EcsOnUpdate, Position, Speed);
    ECS_ENTITY(world, MyEntity, Position, Speed);
    
    ecs_set(world, MyEntity, Position, {0, 0});
    ecs_set(world, MyEntity, Speed, {1});
    
    while (ecs_progress(world, 0));

    return ecs_fini(world);
}






# Notes

I usually work having a split screen with a source file and a notes file where I copy and paste snippets and todos.

## Make commands

make test_[filename_without_extension]: Run the test for the specified file. **(1)**
make run_[filename]

**(1)**: executable files deleted after run: make will delete all intermediate files after run. This is the default behavior of make.

## TODO

* Make tests run on mac and windows.

## Dettect OS
This dettects the operative system I'm running on. Check makefile for more details.

```
    #ifdef OS_Windows_NT
    printf("Windows dettected\n");
    #elif defined OS_Linux
    printf("LINUS dettected\n");
    #elif defined OS_Darwin
    printf("MacOS dettected\n");
    #endif
```

# Programming Wisdom

The ultimate goal on writing code is to reduce the cognitive load that an average person needs to understand it. Split code on multiple files does not always contribute to this.

Cognitive load is usually reduced by:

* Descriptive names
* Low cyclomatic complexity
* Small tool footprint

You can measure cyclomatic complexity with tools like **cccc** but you probably don't want to go that far.

I usually work having a split screen with a source file and a notes file where I copy and paste snippets and todos.

Dont fear to create big files, I split the **Makefile** in several subfiles and include them but I was finding myself going back and forth to change libraries and compiler options. Split in multiple files don't always make your code more manejable.
