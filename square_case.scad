use <features/itx.scad>;
use <features/2d_geometries.scad>;
use <features/case_fans.scad>;

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

    mb_offset = [
        5, 
        dimensions.y - 170 - 5
    ];

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

module left_plate(
    case_dimensions, 
    wall_thickness,
    hole_padding,
    hole_diameter,
    hole_sides = 0,
    color = "#ffff00"
) {
    dimensions = [case_dimensions.y, case_dimensions.z];

    color(color)
        rotate([90, 0, 90])
            linear_extrude(height = wall_thickness)
                2d_perforated_square(
                    dimensions = dimensions, 
                    margins = [5, 5],
                    c_padding = hole_padding, 
                    c_diameter = hole_diameter, 
                    circle_sides = hole_sides
                );
}

module right_plate(
    case_dimensions, 
    wall_thickness, 
    hole_padding,
    hole_diameter,
    hole_sides = 0,
    color = "#ff0000"
) {
    dimensions = [case_dimensions.y, case_dimensions.z];

    fan_margin = [10, 5];
    fan_size = 40;
    fan_area = [
        40 + (fan_margin.x * 2), 
        40 + (fan_margin.y * 2)
    ];

    perforation_margin = [5, 5];
    perforation_area = [
        dimensions.x - fan_area.x - (perforation_margin.x * 2), 
        dimensions.y - (perforation_margin.y * 2)
    ];

    fan_offset = fan_margin + [
        (perforation_margin.x * 2) + perforation_area.x,
        (dimensions.y / 2) - (fan_area.y / 2)
    ];

    color(color) 
        translate([case_dimensions.x - wall_thickness, 0])
            rotate([90, 0, 90])
            linear_extrude(height = wall_thickness)
                    union () {
                        difference() {
                            square(dimensions);

                            translate(perforation_margin) {
                                2d_circle_grid(
                                    dimensions = perforation_area, 
                                    c_padding = hole_padding, 
                                    c_diameter = hole_diameter, 
                                    circle_sides = hole_sides
                                );
                            }

                            translate(fan_offset) {
                                2d_40mm_fan_template();
                            }
                        }
                    }
}

module rear_plate(
    case_dimensions, 
    wall_thickness, 
    hole_padding,
    hole_diameter,
    hole_sides = 0,
    color = "#0000ff"
) {
    dimensions = [case_dimensions.x - (wall_thickness * 2), case_dimensions.z];

    color(color)
        translate([wall_thickness, case_dimensions.y, 0])
            rotate([90, 0, 0])
                linear_extrude(height = wall_thickness)
                    2d_perforated_square(
                        dimensions = dimensions, 
                        margins = [5, 5],
                        c_padding = hole_padding, 
                        c_diameter = hole_diameter, 
                        circle_sides = hole_sides
                    );
}

module front_plate(
    case_dimensions,
    wall_thickness,
    hole_padding,
    hole_diameter,
    hole_sides = 0,
    color = "#00ffff"
) {
    dimensions = [case_dimensions.x - (wall_thickness * 2), case_dimensions.z];

    color(color)
        translate([wall_thickness, wall_thickness, 0])
            rotate([90, 0, 0])
                linear_extrude(height = wall_thickness)
                2d_perforated_square(
                    dimensions = dimensions, 
                    margins = [5, 5],
                    c_padding = hole_padding, 
                    c_diameter = hole_diameter, 
                    circle_sides = hole_sides
                );
}

// Outer dimensions of the case
case_dimensions = [210, 190, 60];

// Thickness of the base plate
base_thickness = 4;

// Thickness of the side plates
side_thickness = 2;

hole_padding = 3;
hole_diameter = 5;
hole_sides = 0;

color = "#666666";

// Draw all components
left_plate(
    case_dimensions, 
    side_thickness, 
    hole_padding = hole_padding,
    hole_diameter = hole_diameter,
    hole_sides = hole_sides,
    color = color
);
right_plate(
    case_dimensions, 
    side_thickness, 
    hole_padding = hole_padding,
    hole_diameter = hole_diameter,
    hole_sides = hole_sides,
    color = "red"
);

rear_plate(
    case_dimensions, 
    side_thickness,
    hole_padding = hole_padding,
    hole_diameter = hole_diameter,
    hole_sides = hole_sides,
    color = color
);

front_plate(
    case_dimensions, 
    side_thickness,
    hole_padding = hole_padding,
    hole_diameter = hole_diameter,
    hole_sides = hole_sides, 
    color = color
);

base_plate(case_dimensions, base_thickness, side_thickness, draw_mb = true);