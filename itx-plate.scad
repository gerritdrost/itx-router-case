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

module base_plate(
    case_dimensions, 
    base_thickness, 
    side_thickness,
    draw_mb = false, 
    color = "#999999"
) {
    // Dimensions of the plate
    both_sides = side_thickness * 2;
    dimensions = [case_dimensions.x - both_sides, case_dimensions.y - both_sides];

    mb_offset = [8, (dimensions.y / 2) - (170 / 2)];

    // Diameter of the self-tapping holes the standoffs will be screwed into
    // Todo: consider making them bigger and using nuts?
    standoff_hole_diameter = 2.15;
    standoff_height = 6;

    translate([side_thickness, side_thickness]) {
        color(color) 
            linear_extrude(height = base_thickness)
                difference() {
                    square(dimensions, center = false);

                    translate(mb_offset)
                        2d_itx_screwholes(standoff_hole_diameter);
                }

        if (draw_mb) {
            translate([mb_offset.x, mb_offset.y, base_thickness + standoff_height])
                itx_board();

            translate([mb_offset.x, mb_offset.y, base_thickness]) 
                itx_standoffs(standoff_height);
        }
    }
}

module left_plate(case_dimensions, thickness, color = "#ffff00") {
    dimensions = [case_dimensions.y, case_dimensions.z];

    color(color) 
        rotate([90, 0, 90])
            linear_extrude(height = thickness)
                square(dimensions);
}

module right_plate(case_dimensions, thickness, color = "#ff0000") {
    dimensions = [case_dimensions.y, case_dimensions.z];

    color(color) 
        translate([case_dimensions.x - thickness, 0])
        rotate([90, 0, 90])
            linear_extrude(height = thickness)
                square(dimensions);
}

module rear_plate(case_dimensions, thickness, color = "#0000ff") {
    dimensions = [case_dimensions.x - (side_thickness * 2), case_dimensions.z];

    color(color)
        translate([side_thickness, case_dimensions.y, 0])
            rotate([90, 0, 0])
                linear_extrude(height = thickness)
                    square(dimensions);
}

module front_plate(case_dimensions, thickness, color = "#00ffff") {
    dimensions = [case_dimensions.x - (side_thickness * 2), case_dimensions.z];

    color(color)
        translate([side_thickness, side_thickness, 0])
            rotate([90, 0, 0])
                linear_extrude(height = thickness)
                    square(dimensions);
}

// Outer dimensions of the case
case_dimensions = [210, 190, 80];

// Thickness of the base plate
base_thickness = 3;

// Thickness of the side plates
side_thickness = 2;

// Draw all components
left_plate(case_dimensions, side_thickness);
right_plate(case_dimensions, side_thickness);
rear_plate(case_dimensions, side_thickness);
//front_plate(case_dimensions, side_thickness);
base_plate(case_dimensions, base_thickness, side_thickness, draw_mb = true);
