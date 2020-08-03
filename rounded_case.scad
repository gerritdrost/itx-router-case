use <lib/itx.scad>;
use <lib/2d_geometries.scad>;
use <lib/case_fans.scad>;

module rounded_block(dimensions, corner_radius) {
    linear_extrude(height = dimensions.z)
        rounded_square(
            size = [dimensions.x, dimensions.y], 
            radius = corner_radius
        );
}

module enclosure(case_dimensions, base_thickness, side_thickness, corner_radius) {
    difference() {
        rounded_block(
            dimensions = case_dimensions,
            corner_radius = corner_radius
        );

        translate([
            side_thickness, 
            side_thickness, 
            base_thickness
        ]) {
            rounded_block(
                dimensions = [
                    case_dimensions.x - (side_thickness * 2), 
                    case_dimensions.y - (side_thickness * 2), 
                    case_dimensions.z
                ],
                corner_radius = corner_radius - side_thickness
            );
        }
    }
}

module walls(
    case_dimensions,
    base_thickness,
    side_thickness,
    vertical_margin,
    corner_radius,
    fan_area_margin,
    hole_area_margin,
    hole_padding,
    hole_diameter,
    hole_sides
) {
    lr_area = [
        case_dimensions.y - (corner_radius * 2), 
        case_dimensions.z - base_thickness - (vertical_margin * 2)
    ];

    lr_offset = [
        corner_radius,
        base_thickness + vertical_margin
    ];
    
    fb_area = [
        case_dimensions.x - (corner_radius * 2), 
        case_dimensions.z - base_thickness - (vertical_margin * 2)
    ];

    fb_offset = [
        corner_radius,
        base_thickness + vertical_margin
    ];

    union() {
        translate([-1,0,0])
            rotate([90, 0, 90])
                linear_extrude(height = side_thickness + 2)
                    translate(lr_offset)
                        left_wall(
                            usable_area = lr_area,
                            hole_area_margin = hole_area_margin,
                            hole_padding = hole_padding,
                            hole_diameter = hole_diameter,
                            hole_sides = hole_sides
                        );
        


        translate([case_dimensions.x - side_thickness - 1,0,0])
            rotate([90, 0, 90])
                linear_extrude(height = side_thickness + 2)
                    translate(lr_offset)
                        right_wall(
                            usable_area = lr_area,
                            fan_area_margin = fan_area_margin,
                            hole_area_margin = hole_area_margin,
                            hole_padding = hole_padding,
                            hole_diameter = hole_diameter,
                            hole_sides = hole_sides
                        );

        translate([0, case_dimensions.y + 1, 0])
            rotate([90, 0, 0])
                linear_extrude(height = side_thickness + 2)
                    translate(fb_offset)
                        rear_wall(
                            usable_area = fb_area,
                            hole_area_margin = hole_area_margin,
                            hole_padding = hole_padding,
                            hole_diameter = hole_diameter,
                            hole_sides = hole_sides
                        );

        translate([0, 1 + side_thickness, 0])
            rotate([90, 0, 0])
                linear_extrude(height = side_thickness + 2)
                    translate(fb_offset)
                        front_wall(
                            usable_area = fb_area,
                            hole_area_margin = hole_area_margin,
                            hole_padding = hole_padding,
                            hole_diameter = hole_diameter,
                            hole_sides = hole_sides
                        );
    }
}

module left_wall(
    usable_area,
    hole_area_margin,
    hole_padding,
    hole_diameter,
    hole_sides
) {
    translate(hole_area_margin)
        2d_circle_grid(
            dimensions = [
                usable_area.x - (hole_area_margin.x * 2), 
                usable_area.y - (hole_area_margin.y * 2)
            ],
            c_padding = hole_padding,
            c_diameter = hole_diameter,
            circle_sides = hole_sides
        );
}

module front_wall(
    usable_area,
    hole_area_margin,
    hole_padding,
    hole_diameter,
    hole_sides
) {
    translate(hole_area_margin)
        2d_circle_grid(
            dimensions = [
                usable_area.x - (hole_area_margin.x * 2), 
                usable_area.y - (hole_area_margin.y * 2)
            ],
            c_padding = hole_padding,
            c_diameter = hole_diameter,
            circle_sides = hole_sides
        );
}

module rear_wall(
    usable_area,
    hole_area_margin,
    hole_padding,
    hole_diameter,
    hole_sides
) {
    translate(hole_area_margin)
        2d_circle_grid(
            dimensions = [
                usable_area.x - (hole_area_margin.x * 2), 
                usable_area.y - (hole_area_margin.y * 2)
            ],
            c_padding = hole_padding,
            c_diameter = hole_diameter,
            circle_sides = hole_sides
        );
}

module right_wall(
    usable_area,
    fan_area_margin,
    hole_area_margin,
    hole_padding,
    hole_diameter,
    hole_sides
) {
    fan_area = [40, 40];

    fan_area_offset = [
        usable_area.x - (fan_area.x + fan_area_margin.x),
        (usable_area.y / 2) - (fan_area.y / 2)
    ];

    hole_area = [
        usable_area.x - (hole_area_margin.x * 2) - fan_area.x - (fan_area_margin.x * 2),
        usable_area.y - (hole_area_margin.y * 2)
    ];


    union() {
        translate(hole_area_margin)
            2d_circle_grid(
                dimensions = [hole_area.x, hole_area.y],
                c_padding = hole_padding,
                c_diameter = hole_diameter,
                circle_sides = hole_sides
            );

        translate(fan_area_offset)
            2d_40mm_fan_template();
    }
}

// Outer dimensions of the case
case_dimensions = [210, 190, 60];

// Thickness of the base plate
base_thickness = 2;

// Thickness of the side plates
side_thickness = 2;

// Area to leave untouched at the top/bottom of all walls
vertical_margin = 4;

hole_padding = 3;
hole_diameter = 5;
hole_sides = 0;
hole_area_margin = [5, 5];

fan_area_margin = [5, 5];

color = "#666666";

corner_radius = 8;

color(color)
    difference () {
        enclosure(
            case_dimensions = case_dimensions, 
            base_thickness = base_thickness, 
            side_thickness = side_thickness, 
            corner_radius = corner_radius
        );

        walls(
            case_dimensions = case_dimensions,
            base_thickness = base_thickness, 
            side_thickness = side_thickness, 
            vertical_margin = vertical_margin,
            corner_radius = corner_radius,
            fan_area_margin = fan_area_margin,
            hole_area_margin = hole_area_margin,
            hole_padding = hole_padding,
            hole_diameter = hole_diameter,
            hole_sides = hole_sides
        );
    }
