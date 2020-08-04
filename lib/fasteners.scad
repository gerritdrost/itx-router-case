module m3_standoff(standoff_height, screw_length) {
    union() {
        difference() {
            translate([0, 0, 0])
                linear_extrude(height = standoff_height)
                    circle(d = 5.25, $fn = 6);

            translate([0, 0, -1])
                linear_extrude(height = standoff_height + 2)
                    circle(d = 3, $fn = 24);
        }

        translate([0, 0, -screw_length])
            linear_extrude(height = screw_length + 1)
                circle(d = 3, $fn = 24);
    }
}