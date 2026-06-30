inch = 25.4;

// Dimensions
length = 9 * inch;
width  = 1.25 * inch;
height = 0.125 * inch;

// Bevel size
bevel = 0.06 * inch; // adjust as desired

// Pony bead dimensions
bead_diameter = 9;
bead_height   = 5.6;
bead_hole     = 4;
bead_spacing  = 10;   // center-to-center

// Jitter settings
y_jitter = 2.0;   // max side-to-side movement in mm
x_jitter = 1.0;   // max forward-to-backward movement in mm
seed = 12345;     // change this for a different random layout

module top_beveled_box(size=[10,10,10], r=1) {
    hull() {
        for (x = [r, size[0]-r])
        for (y = [r, size[1]-r]) {

            // Top corners (rounded)
            translate([x, y, size[2]-r])
                sphere(r=r, $fn=32);

            // Bottom corners (square)
            translate([x, y, 0])
                cylinder(h=0.01, r=r, $fn=32);
        }
    }
}

module pony_bead() {
    difference() {
        cylinder(
            h = bead_height,
            d = bead_diameter,
            $fn = 64
        );

        translate([0,0,-0.1])
            cylinder(
                h = bead_height + 0.2,
                d = bead_hole,
                $fn = 48
            );
    }
}

union() {
    top_beveled_box([length, width, height], bevel);

    // Row of beads centered on the strip
    num_beads = floor((length - bead_diameter) / bead_spacing) + 1;
    used_length = (num_beads - 1) * bead_spacing;
    start_x = (length - used_length) / 2;
    
    y_offsets = rands(-y_jitter, y_jitter, num_beads, seed);
    x_offsets = rands(-x_jitter, x_jitter, num_beads, seed);

    for (i = [0 : num_beads - 1]) {
        translate([
            start_x + i * bead_spacing + x_offsets[i], 
            width / 2 + y_offsets[i], 
            height
        ]) {
            pony_bead();
        }
    }
}