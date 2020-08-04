use <fasteners.scad>

function itx_screwhole_positions() = [
    [6.35, 4.9], 
    [6.35, 159.84],
    [163.65, 136.98],
    [163.65, 4.9]
];

module itx_board(color = "#33aa11") {
    color(color)
        linear_extrude(height = 1.6)
            difference() {
                square(170);
                2d_itx_screwholes(3);
            }
}

module m3_itx_standoffs(standoff_height, screw_length, color = "#b3a436") {
    color(color) {
        for (screwhole_position = itx_screwhole_positions()) {
            translate(screwhole_position) m3_standoff(standoff_height, screw_length);
        }
    }
}

// Creates a union of circles at the Mini-ITX screwhole coordinates
module 2d_itx_screwholes(screwhole_diameter, sides = 0) {
    for (screwhole_position = itx_screwhole_positions()) {
        translate(screwhole_position) 
            circle(d = screwhole_diameter, $fn = sides);
    }
}

module 2d_itx_backplate(border, screwhole_diameter) {    
    difference() {
        square(
            size = 170 + (border * 2), 
            center = false
        );
        
        translate([border, border])
            2d_itx_screwholes(screwhole_diameter);
    }
}