SCAD = main.scad
OPENSCAD = openscad

TRAYS = 2-1 2-2 3-2 3-3 4-3 4-4
OUTPUTS = $(addprefix build/tray_,$(addsuffix .stl,$(TRAYS)))

comma := ,

.PHONY: all clean

all: $(OUTPUTS)

build:
	mkdir -p build

define tray_rule
build/tray_$(1).stl: $$(SCAD) | build
	$$(OPENSCAD) -D 'rows=[$(subst -,$(comma),$(1))]' -o $$@ $$<
endef

$(foreach tray,$(TRAYS),$(eval $(call tray_rule,$(tray))))

clean:
	rm -rf build
