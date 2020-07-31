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

module left_plate(case_dimensions, thickness, color = "#ffff00") {
    dimensions = [case_dimensions.y, case_dimensions.z];

    color(color) 
        rotate([90, 0, 90])
            linear_extrude(height = thickness)
                2d_perforated_square(dimensions, [5, 5], 2, 4, 5);
}

module 2d_40mm_fan_template() {
    union () {
        difference() {
            square([40, 40]);
            union () {
                translate([-1, -1]) square([9, 9]);
                translate([-1, 32]) square([9, 9]);
                translate([32, -1]) square([9, 9]);
                translate([32, 32]) square([9, 9]);
            }
        }
        translate([4, 4]) circle(d = 3.5);
        translate([4, 36]) circle(d = 3.5);
        translate([36, 4]) circle(d = 3.5);
        translate([36, 36]) circle(d = 3.5);
    }
}

module right_plate(case_dimensions, thickness, color = "#ff0000") {
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

    echo("fan", fan_offset);

    color(color) 
        translate([case_dimensions.x - thickness, 0])
            rotate([90, 0, 90])
            linear_extrude(height = thickness)
                    union () {
                        difference() {
                            square(dimensions);

                            translate(perforation_margin) {
                                2d_circle_grid(perforation_area, 2, 4, 5);
                            }

                            translate(fan_offset) {
                                2d_40mm_fan_template();
                            }
                        }
                    }
}

module rear_plate(case_dimensions, thickness, color = "#0000ff") {
    dimensions = [case_dimensions.x - (thickness * 2), case_dimensions.z];

    color(color)
        translate([thickness, case_dimensions.y, 0])
            rotate([90, 0, 0])
                linear_extrude(height = thickness)
                    2d_perforated_square(dimensions, [5, 5], 2, 4, 5);
}

module front_plate(case_dimensions, thickness, color = "#00ffff") {
    dimensions = [case_dimensions.x - (side_thickness * 2), case_dimensions.z];

    color(color)
        translate([side_thickness, side_thickness, 0])
            rotate([90, 0, 0])
                linear_extrude(height = thickness)
                    square(dimensions);
}

module 2d_circle_grid(dimensions, c_padding, c_diameter, circle_sides = 0) {
    c_radius = c_diameter / 2;

    function fit_circles(width) = floor((width - c_diameter) / (c_diameter + c_padding) + 1);
    function circles_width(n) = n * c_diameter + (n - 1) * c_padding;

    c_num = [
        fit_circles(dimensions.x), 
        fit_circles(dimensions.y)
    ];

    c_area = [
        circles_width(c_num.x), 
        circles_width(c_num.y)
    ];

    perforated_offset = [
        c_radius + (dimensions.x / 2) - (c_area.x / 2), 
        c_radius + (dimensions.y / 2) - (c_area.y / 2)
    ];
    
    translate(perforated_offset) {
        union() {
            for (y = [0 : c_num.y - 1]) {
                for (x = [0 : c_num.x - 1]) {
                    circle_offset = [
                        x * (c_diameter + c_padding), 
                        y * (c_diameter + c_padding)
                    ];

                    translate(circle_offset)
                        circle(d = c_diameter, $fn = circle_sides);
                }
            }
        }
    }
}

module 2d_perforated_square(dimensions, margins, c_padding, c_diameter, circle_sides = 0) {
    margin_boundaries = [
        dimensions.x - 2 * margins.x, 
        dimensions.y - 2 * margins.y
    ];
    
    difference() {
        square(dimensions);
        translate(margins)
            2d_circle_grid(margin_boundaries, c_padding, c_diameter, circle_sides);
    }
}

// Outer dimensions of the case
case_dimensions = [210, 190, 60];

// Thickness of the base plate
base_thickness = 4;

// Thickness of the side plates
side_thickness = 2;

color = "#666666";

// Draw all components
left_plate(case_dimensions, side_thickness, color);
right_plate(case_dimensions, side_thickness/*, color*/);
rear_plate(case_dimensions, side_thickness, color);
front_plate(case_dimensions, side_thickness, color);
base_plate(case_dimensions, base_thickness, side_thickness, draw_mb = true);