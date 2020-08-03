use <features/itx.scad>;
use <features/2d_geometries.scad>;
use <features/case_fans.scad>;

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

module left_wall_holes(
    case_dimensions,
    base_thickness,
    side_thickness,
    corner_radius,
    hole_area_margin,
    hole_padding,
    hole_diameter,
    hole_sides
) {
    dimensions = [
        case_dimensions.y - (corner_radius * 2) - (hole_area_margin.x * 2), 
        case_dimensions.z - base_thickness - (hole_area_margin.y * 2)
    ];

    2d_offset = [
        corner_radius + hole_area_margin.x,
        base_thickness + hole_area_margin.y
    ];

    translate([-1,0,0])
        rotate([90, 0, 90])
            linear_extrude(height = side_thickness + 2, convexity = 2)
                translate(2d_offset)
                    2d_circle_grid(
                        dimensions = [dimensions.x, dimensions.y],
                        c_padding = hole_padding,
                        c_diameter = hole_diameter,
                        circle_sides = hole_sides
                    );
}

module right_wall_holes(
    case_dimensions,
    base_thickness,
    side_thickness,
    corner_radius,
    hole_area_margin,
    hole_padding,
    hole_diameter,
    hole_sides
) {
    dimensions = [
        case_dimensions.y - (corner_radius * 2) - (hole_area_margin.x * 2), 
        case_dimensions.z - base_thickness - (hole_area_margin.y * 2)
    ];

    2d_offset = [
        corner_radius + hole_area_margin.x,
        base_thickness + hole_area_margin.y
    ];

    translate([case_dimensions.x - side_thickness - 1,0,0])
        rotate([90, 0, 90])
            linear_extrude(height = side_thickness + 2, convexity = 2)
                translate(2d_offset)
                    2d_circle_grid(
                        dimensions = [dimensions.x, dimensions.y],
                        c_padding = hole_padding,
                        c_diameter = hole_diameter,
                        circle_sides = hole_sides
                    );
}

// Outer dimensions of the case
case_dimensions = [210, 190, 60];

// Thickness of the base plate
base_thickness = 2;

// Thickness of the side plates
side_thickness = 2;

hole_padding = 3;
hole_diameter = 5;
hole_sides = 0;

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

        left_wall_holes(
            case_dimensions = case_dimensions,
            base_thickness = base_thickness, 
            side_thickness = side_thickness, 
            corner_radius = corner_radius,
            hole_area_margin = [5, 5],
            hole_padding = hole_padding,
            hole_diameter = hole_diameter,
            hole_sides = hole_sides
        );

        right_wall_holes(
            case_dimensions = case_dimensions,
            base_thickness = base_thickness, 
            side_thickness = side_thickness, 
            corner_radius = corner_radius,
            hole_area_margin = [5, 5],
            hole_padding = hole_padding,
            hole_diameter = hole_diameter,
            hole_sides = hole_sides
        );
    }
