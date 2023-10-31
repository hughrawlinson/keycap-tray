$fn = 100;
keyRows = 3;
keyColumns = 5;
keyGridGap = 2;

keyWidth = 18.5;
keyDepth = 18.5;

keyHoleTolerance = 0.3;

holderHeight = 4;
holderHoleDepth = 2;

useGridfinity = true;
gridfinityHeightUnits = 3;

wallSize = keyGridGap;
unitWidth = keyWidth + wallSize + keyHoleTolerance;
unitHeight = keyDepth + wallSize + keyHoleTolerance;

include<gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>


module key() {
  translate([0,0,holderHeight/2]) {
    difference() {
      cube([unitWidth+0.01,unitHeight+0.01,holderHeight],true);
      translate([0, 0, (holderHeight-holderHoleDepth)/2+0.01]) {
        cube([keyWidth+keyHoleTolerance, keyDepth+keyHoleTolerance, holderHoleDepth], true);
      }
    }
  }
}

module grid() {
  totalWidth = unitWidth * keyColumns;
  totalHeight = unitHeight * keyRows;
  translate([-(totalWidth*(0.5-(1/keyColumns/2))), -(totalHeight*(0.5-(1/keyRows/2))), 0]) {
    for (y = [0:keyRows-1]) {
      for (x = [0:keyColumns-1]) {
        translate([x * unitWidth, y * unitHeight, 0]) {
          key();
        }
      }
    }
  }
}

module gridRim() {
  difference() {
    translate([0, 0, holderHeight/2]) {
      cube([
        keyColumns*(keyWidth+keyHoleTolerance)+wallSize*(keyColumns+1),
        keyRows*(keyDepth+keyHoleTolerance)+wallSize*(keyRows+1),
        holderHeight
      ], true);
    }
    translate([0, 0, holderHeight/2+0.01]) {
      cube([
        keyColumns*(keyWidth+keyHoleTolerance+wallSize),
        keyRows*(keyDepth+keyHoleTolerance+wallSize),
        holderHeight+0.05
      ], true);
    }
  }
}

module stamp() {
  totalWidth = unitWidth * keyColumns;
  totalHeight = unitHeight * keyRows;
  stampBackingHeight = gridz * 7 - holderHoleDepth;
  translate([0,0,0]) {
    union() {
      translate([0,0,-(holderHeight - holderHoleDepth)]) {
        difference() {
          translate([0,0,holderHeight/2]) {
            cube([totalWidth-0.01, totalHeight-0.01, holderHeight-0.01], true);
          }
          grid();
        }
      }
      translate([0,0,stampBackingHeight/2+holderHoleDepth-0.1]) {
        cube([totalWidth*2, totalHeight*2, stampBackingHeight], true);
      }
    }
  }
}

gridx = ceil(unitWidth * keyColumns / 42);
gridy = ceil(unitWidth * keyRows / 42);;
gridz = gridfinityHeightUnits;
gridz_define = 0;
style_lip = 0;
enable_zsnap = false;
height_internal = 0;
divx = 1;
divy = 1;
scoop = 0;
style_tab = 5;
only_corners = 0;
style_hole = 3;
div_base_x = 0;
div_base_y = 0;

if (useGridfinity) {
  gridfinityInit(gridx, gridy, height(gridz, gridz_define, style_lip, enable_zsnap), height_internal) {
    cut_move(0, 0, gridx, gridy) {
      translate([0,0,-(gridz-1)*7+0.01]) {
        stamp();
      }
    }
  }
  gridfinityBase(gridx, gridy, l_grid, div_base_x, div_base_y, style_hole, only_corners=only_corners);
} else {
  union() {
    grid();
    gridRim();
  }
}
