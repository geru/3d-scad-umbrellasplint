include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>

/* Parametric umbrella splint generator -- Parametric and customizable

The splint can be used to repair a broken shade umbrella. You choose the dimensions and generate your own handle.

Umbrellas get quite hot. This will not work with pedestrian filaments like PLA or PETG. Must be printed with a high-temperature filament like ASA.

Relies on BOSL2 library.

Models uploaded at: https://www.printables.com/@hkern0
Source code maintained at: https://github.com/geru/3d-scad-umbrellasplint
Author website: https://hkern0.com

© 2025 by Hugh Kern - umbrellaSplint
See LICENSE.txt for licensing
*/

$fn=75;

splintLength = 75;
splintLength1 = splintLength / 3;
splintLength2 = splintLength - splintLength1;
splintDepth = 18.5;
splintWall_min = 2;
splintWall_extra = 10;
splintWall_max = splintWall_min + splintWall_extra;

endCircleDiameter = 10.5;
hullDistance = splintDepth - endCircleDiameter;
hullOffset = hullDistance / 2;
hullOffset_max = hullOffset + splintWall_extra;
splintWidth = endCircleDiameter + 2 * splintWall_min;

module splintShape( diameter, hulloffs1, len, hulloffs2=0, slices=10 ) {
  hull1 = hulloffs1;
  hull2 = hulloffs2 ? hulloffs2 : hulloffs1;

  hull() {
    translate([-hull1[0], 0, 0])
      cyl( l=len, d=diameter, shift=[hull1[1], 0], anchor=BOT );
    translate([hull2[0], 0, 0])
      cyl( l=len, d=diameter, shift=[hull2[1], 0], anchor=BOT );
  }
}

module uSplint_body() {
  translate([0,0,-splintLength1])
    splintShape(splintWidth, [hullOffset, 0], splintLength1, [hullOffset, splintWall_extra]);
  splintShape(splintWidth, [hullOffset, 0], splintLength2, [hullOffset+splintWall_extra, -splintWall_extra]);
}

module uSplint_cut() {
  translate([0,0,-splintLength1])
    splintShape(endCircleDiameter, [hullOffset, 0], splintLength, [hullOffset, 0]);
    rotate([90, 0, 0])
      cyl(h = splintWidth, d = 4.5, center=true);
}

difference() {
  uSplint_body();
  uSplint_cut();
}

