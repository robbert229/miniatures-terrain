// Parametric organic movement tray for round bases
// Example: rows = [3, 2] gives two offset rows like:
//   O O
//  O O O
//
// Units: mm

base_diameter = 20.0;

// Desired empty space between adjacent pockets
gap = 3.0; // Try 1.5–3.0 mm

// FDM-friendly clearance.
// pocket diameter = base_diameter + clearance
clearance = 0.7;

// Row layout from bottom to top
rows = [2, 1];

// Tray dimensions
floor_thickness = 1.8;
wall_height     = 3.2;
wall_thickness  = 2.2;

// Hex/brick spacing.
// 1.00 means pockets touch at nominal diameter.
// Increase slightly for more material between pockets.
x_spacing_factor = 1.00;
y_spacing_factor = 0.866; // sqrt(3) / 2

// Optional magnet holes under each base
magnet_holes    = true;
magnet_diameter = 5.2;
magnet_depth    = 1.2;

// Render smoothness
$fn = 96;

pocket_d = base_diameter + clearance;
pocket_r = pocket_d / 2;

// Horizontal center-to-center distance
x_pitch = pocket_d + gap;

// Vertical spacing for a hex layout.
// This maintains the same gap in all directions.
y_pitch = (pocket_d + gap) * sqrt(3) / 2;
tray();

module tray() {
    difference() {
        linear_extrude(height = floor_thickness + wall_height)
            hull()
                outer_layout();

        translate([0, 0, floor_thickness])
            linear_extrude(height = wall_height + 0.2)
                pocket_layout();

        if (magnet_holes) {
            translate([0, 0, -0.01])
                linear_extrude(height = magnet_depth + 0.02)
                    magnet_layout();
        }
    }
}

module pocket_layout() {
    for (row = [0 : len(rows) - 1]) {
        for (col = [0 : rows[row] - 1]) {
            translate(slot_pos(row, col))
                circle(r = pocket_r);
        }
    }
}

module outer_layout() {
    for (row = [0 : len(rows) - 1]) {
        for (col = [0 : rows[row] - 1]) {
            translate(slot_pos(row, col))
                circle(r = pocket_r + wall_thickness);
        }
    }
}

module magnet_layout() {
    for (row = [0 : len(rows) - 1]) {
        for (col = [0 : rows[row] - 1]) {
            translate(slot_pos(row, col))
                circle(d = magnet_diameter);
        }
    }
}

// Always offset every other row by half a pitch
function slot_pos(row, col) =
    [
        col * x_pitch + ((row % 2) * x_pitch / 2),
        row * y_pitch
    ];