module rounded_square(size, radius = 1, bl = true, br = true, tl = true,  tr = true, center = false) {
    corner_size = [radius, radius];
    cutout_size = corner_size + [1, 1];

    union() {
        difference() {
            square(size, center = false);
            union() {
                if (bl) {
                    translate([-1, -1]) 
                        square(corner_size + [1, 1]);
                }

                if (br) {
                    translate([size.x - radius, -1]) 
                        square(corner_size + [1, 1]);
                }

                if (tl) {
                    translate([size.x - radius, size.y - radius]) 
                        square(corner_size + [1, 1]);
                }

                if (tr) {
                    translate([-1, size.y - radius]) 
                        square(corner_size + [1, 1]);
                }
            }
        }

        if (bl) {
            translate([radius, radius]) 
                circle(r = radius);
        }

        if (br) {
            translate([size.x - radius, radius]) 
                circle(r = radius);
        }

        if (tl) {
            translate([size.x - radius, size.y - radius]) 
                circle(r = radius);
        }

        if (tr) {
            translate([radius, size.y - radius]) 
                circle(r = radius);
        }
    }
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

    alternate_x_offset = (c_area.x / 2) - (circles_width(c_num.x - 1) / 2);
    
    translate(perforated_offset) {
        union() {
            max_y = c_num.y - 1;

            for (y = [0 : max_y]) {
                alternator = (y + 1) % 2;
                max_x = c_num.x - 1 - alternator;
                x_offset = alternator * alternate_x_offset;

                for (x = [0 : max_x]) {
                    circle_offset = [
                        x_offset + x * (c_diameter + c_padding), 
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