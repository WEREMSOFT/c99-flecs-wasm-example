EMCC := emcc
EMAR := emar
EMRANLIB := emranlib

FLECS_D := flecs/
EM_BLD_D := build/
EM_SRC_D := src/
EM_INCL_D := include/
EM_OBJ_D := obj/
FLECS_GIT_REPO := https://github.com/SanderMertens/flecs
EM_SOURCES := $(shell find $(FLECS_D)$(EM_SRC_D) -name '*.c')
EM_OBJS = $(subst .c,.o,$(patsubst $(FLECS_D)$(EM_SRC_D)%,$(FLECS_D)$(EM_OBJ_D)%,$(EM_SOURCES)))
EMC_FLAGS := -I$(FLECS_D)include -c -Wall -fPIC -DPRIVATE -DFLECS_STATIC -DFLECS_IMPL

PHONYS = flecs_ems_static clean_flex

flecs_ems_static: flecs $(FLECS_D)$(EM_BLD_D)libflecs_static.bc
	
flecs:
	git clone $(FLECS_GIT_REPO) && mkdir $(FLECS_D)build && mkdir $(FLECS_D)obj;\
	cd flecs/build/;\
	cmake ..;\
	make
	

$(FLECS_D)$(EM_BLD_D)libflecs_static.bc: $(EM_OBJS)
	$(EMAR) rcs $@ $^
	$(EMRANLIB) -D $@
	cp $(FLECS_D)$(EM_BLD_D)libflecs_static.bc libs/static
	cp $(FLECS_D)$(EM_BLD_D)libflecs_static.a libs/static

$(FLECS_D)$(EM_OBJ_D)%.o: $(FLECS_D)$(EM_SRC_D)%.c
	@echo building $@ from $^
	@$(EMCC) $(EMC_FLAGS) $^ -o $@
	@echo done

clean_flex:
	rm -fR $(FLECS_D)
	rm libs/static/libflecs_static.bc