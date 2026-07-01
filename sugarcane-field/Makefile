SCAD = main.scad
OPENSCAD = openscad

SEEDS = 1 2 3 4 5 6
OUTPUTS = $(addprefix build/terrain_seed_,$(addsuffix .stl,$(SEEDS)))

.PHONY: all clean

all: $(OUTPUTS)

build:
	mkdir -p build

build/terrain_seed_%.stl: $(SCAD) | build
	$(OPENSCAD) \
		-D "seed=$*" \
		-o $@ \
		$<

clean:
	rm -rf build
