module itx_board(color = "#33aa11") {
    color(color)
        linear_extrude(height = 1.6)
            difference() {
                square(170);
                2d_itx_screwholes(2.5);
            }
}

module itx_standoffs(height, color = "#b3a436") {
    color(color)
        linear_extrude(height = height)
            2d_itx_screwholes(2.5, 6);
}

// Creates a union of circles at the Mini-ITX screwhole coordinates
module 2d_itx_screwholes(screwhole_diameter, sides = 0) {
    union() {
        // H
        translate([6.35, 4.9]) circle(d = screwhole_diameter, $fn = sides);
        
        // C
        translate([6.35, 159.84]) circle(d = screwhole_diameter, $fn = sides);
        
        // F
        translate([163.65, 136.98]) circle(d = screwhole_diameter, $fn = sides);
        
        // J
        translate([163.65, 4.9]) circle(d = screwhole_diameter, $fn = sides);
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