seed = 1; // change this for a different random layout

inch = 25.4;

// Dimensions
length = 9 * inch;
width  = 1.25 * inch;
height = 0.125 * inch;

// Bevel size
bevel = 0.06 * inch; // adjust as desired

// Jitter settings
y_jitter = 2.0;      // max side-to-side movement in mm
x_jitter = 1.0;      // max forward-to-backward movement in mm
z_jitter = 1.5;      // max vertical movement in mm
omit_jitter = 0.1; // the chance that a bead will be missing

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

// Pony bead dimensions
bead_diameter = 9;
bead_height   = 5.6;
bead_hole     = 4;
bead_spacing  = 12; // center-to-center

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

slope_height = 2.0;   // how high the mound rises
slope_radius = 7.0;   // how far mound extends from bead center

slope_height_jitter = 0.5; // max vertical variance.
slope_radius_jitter = 1.0; // max radial variance.

module bead_mound(height, radius, sx, sy, rot) {
    rotate([0,0,rot])
        scale([sx, sy, 1])
            cylinder(
                h = height,
                r1 = radius,
                r2 = bead_diameter / 2,
                $fn = 64
            );
}

union() {
    top_beveled_box([length, width, height], bevel);

    // Row of beads centered on the strip
    num_beads = floor((length - bead_diameter) / bead_spacing);
    used_length = (num_beads - 1) * bead_spacing;
    start_x = (length - used_length) / 2;
    
    y_offsets = rands(-y_jitter, y_jitter, num_beads, seed);
    x_offsets = rands(-x_jitter, x_jitter, num_beads, seed);
    z_offsets = rands(-z_jitter, 0, num_beads, seed);
    
    omit_bead = rands(0, 1, num_beads, seed + 9);

    slope_heights = rands(
        slope_height - slope_height_jitter,
        slope_height + slope_height_jitter,
        num_beads,
        seed + 2
    );

    slope_radii = rands(
        slope_radius - slope_radius_jitter,
        slope_radius + slope_radius_jitter,
        num_beads,
        seed + 3
    );
    
    mound_scale_x = rands(0.85, 1.15, num_beads, seed + 4);
    mound_scale_y = rands(0.85, 1.15, num_beads, seed + 5);
    mound_rot     = rands(0, 360, num_beads, seed + 6);

    for (i = [0 : num_beads - 1]) {
        if (omit_bead[i] > omit_jitter) {
            x = start_x + i * bead_spacing + x_offsets[i];
            y = width / 2 + y_offsets[i];

            h = slope_heights[i];
            r = slope_radii[i];

            translate([x, y, height])
                bead_mound(h, r, mound_scale_x[i], mound_scale_y[i], mound_rot[i]);

            translate([x, y, height + z_offsets[i]])
                pony_bead();
        }
    }
}
