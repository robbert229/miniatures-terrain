// Organic movement tray for 20mm round bases
// Two offset rows, like a brick/hex pattern

base_diameter = 20.8;
clearance = 0.6;

bottom_cols = 3;
top_cols = 2;

floor_thickness = 1.6;
wall_thickness = 2.0;
wall_height = 3.0;

magnet_holes = true;
magnet_diameter = 5.2;
magnet_depth = 1.2;

$fn = 72;

pocket_d = base_diameter + clearance;
pocket_r = pocket_d / 2;

x_pitch = pocket_d;
y_pitch = pocket_r * sqrt(3);

tray();

module tray() {
    difference() {
        // Organic outer body
        linear_extrude(floor_thickness + wall_height)
            offset(r = wall_thickness)
                pocket_layout();

        // Base pockets
        translate([0, 0, floor_thickness])
            linear_extrude(wall_height + 0.2)
                pocket_layout();

        // Magnet recesses from underside
        if (magnet_holes) {
            translate([0, 0, -0.01])
                linear_extrude(magnet_depth + 0.02)
                    magnet_layout();
        }
    }
}

module pocket_layout() {
    // Bottom row: 3 circles
    for (i = [0 : bottom_cols - 1]) {
        translate([i * x_pitch, 0])
            circle(r = pocket_r);
    }

    // Top row: 2 circles, offset half a base
    for (i = [0 : top_cols - 1]) {
        translate([(i + 0.5) * x_pitch, y_pitch])
            circle(r = pocket_r);
    }
}

module magnet_layout() {
    // Bottom row magnets
    for (i = [0 : bottom_cols - 1]) {
        translate([i * x_pitch, 0])
            circle(d = magnet_diameter);
    }

    // Top row magnets
    for (i = [0 : top_cols - 1]) {
        translate([(i + 0.5) * x_pitch, y_pitch])
            circle(d = magnet_diameter);
    }
}