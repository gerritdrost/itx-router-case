use <2d_geometries.scad>

module 2d_40mm_fan_template() {
    union () {
        difference() {
            square([40, 40]);
            union () {
                translate([-1, -1]) rounded_square([9, 9], 2, bl = false, br = false, tr = false);
                translate([-1, 32]) rounded_square([9, 9], 2, bl = false, tl = false, tr = false);
                translate([32, -1]) rounded_square([9, 9], 2, bl = false, br = false, tl = false);
                translate([32, 32]) rounded_square([9, 9], 2, br = false, tl = false, tr = false);
            }
        }
        translate([4, 4]) circle(d = 3.5);
        translate([4, 36]) circle(d = 3.5);
        translate([36, 4]) circle(d = 3.5);
        translate([36, 36]) circle(d = 3.5);
    }
}