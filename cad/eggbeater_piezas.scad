// =====================================================================
//  Eggbeater para satelites: piezas imprimibles (2 m y 70 cm)
//  Basada en la Eggbeater V2 de EA5WA (lazos de pletina, mastil de PVC)
//  y en la Eggbeater II de K5OE. Dimensiones electricas: sim/resultados.json
//
//  openscad -D 'BAND="2m"' -D 'PART="buje"' -o buje.stl eggbeater_piezas.scad
//    BAND = "2m" | "70cm"
//    PART = "buje" | "tapa" | "tope" | "reflector" | "montaje"
//  Unidades: mm. Imprimir en ASA o PETG (exterior), 4 perimetros, 40 % relleno.
// =====================================================================
BAND = "2m";
PART = "montaje";
include <gen/dimensiones.scad>   // LOOP_W/H, DZ, REFL_L, REFL_D por banda (desde la simulacion)

$fn = 72;
IS2 = BAND == "2m";

// ---------------- parametros mecanicos por banda ----------------
MAST_D  = IS2 ? 32 : 25;     // tubo de PVC del mastil de la antena (EA5WA: 32 mm)
CLR     = 0.5;               // holgura sobre el tubo
WALL    = IS2 ? 5 : 4;
// conductor de los lazos
//  2 m  : "U" de pletina de aluminio 10x2 (laterales + lado superior) y lado inferior
//         formado por dos varillas roscadas M6 que salen del buje (como la V2 de EA5WA)
//  70 cm: lazo entero de varilla de aluminio/laton de 4 mm
COND_W  = IS2 ? 10 : 4;      // pletina (tope superior) / varilla
COND_T  = IS2 ? 2 : 4;
HUB_ROD = IS2 ? 6.5 : 4.4;   // canal del conductor en el buje (M6 / varilla 4 mm)
SCREW   = IS2 ? 4 : 3;       // tornillo de borne (M4 / M3)
NUT_AF  = IS2 ? 7 : 5.5;  NUT_H = IS2 ? 3.2 : 2.4;
REFL_ROD = 4;                // varilla del reflector
DZ      = IS2 ? DZ_2M : DZ_70;          // desnivel entre lazos (simulado)
LW      = IS2 ? LOOP_W_2M : LOOP_W_70;
LH      = IS2 ? LOOP_H_2M : LOOP_H_70;
RL      = IS2 ? REFL_L_2M : REFL_L_70;
RD      = IS2 ? REFL_D_2M : REFL_D_70;

MR  = MAST_D / 2 + CLR;                // radio interior de los manguitos
R_T = MAST_D / 2 + WALL + (IS2 ? 8 : 6);   // radio de los bornes (tornillos)
R_A = R_T + (IS2 ? 14 : 10);           // longitud de los brazos
ARM_W = IS2 ? 20 : COND_W + 8;          // ancho de brazo
ARM_H = IS2 ? 16 : COND_T + 8;
SKIRT = IS2 ? 26 : 14;                 // faldon inferior del buje (rigidez sobre el tubo)
Z_A = SKIRT + ARM_H / 2 + 2;           // nivel del lazo A (eje del conductor)
Z_B = Z_A + DZ;                        // nivel del lazo B
HUB_H = Z_B + ARM_H / 2 + 2;

module slot_cut(len) {   // canal para el conductor, a lo largo de +X, centrado en z=0
    if (IS2) translate([0, -(COND_W + 0.6) / 2, -(COND_T + 0.4) / 2]) cube([len, COND_W + 0.6, COND_T + 0.4]);
    else rotate([0, 90, 0]) cylinder(d = COND_W + 0.4, h = len, $fn = 32);
}
module screw_cut(h, nut = true) {  // tornillo vertical con tuerca cautiva abajo
    translate([0, 0, -h]) cylinder(d = SCREW + 0.4, h = 2 * h, $fn = 24);
    if (nut) translate([0, 0, -h]) cylinder(d = NUT_AF / cos(30) + 0.3, h = NUT_H + 0.4, $fn = 6);
}

// ------------------------------------------------ BUJE DE ALIMENTACION
ARM_DROP = IS2 ? 14 : ARM_H / 2;       // el brazo baja mas en 2 m (suelo bajo la ventana de la tuerca)
module arm(level) {
    translate([0, -ARM_W / 2, level - ARM_DROP]) cube([R_A, ARM_W, ARM_DROP + ARM_H / 2]);
}
module buje() {
    difference() {
        union() {
            cylinder(r = MR + WALL, h = HUB_H);
            for (a = [0, 180]) rotate(a) arm(Z_A);           // lazo A (eje X)
            for (a = [90, 270]) rotate(a) arm(Z_B);          // lazo B (eje Y)
        }
        translate([0, 0, -1]) cylinder(r = MR, h = HUB_H + 2);
        for (lv = [[0, Z_A], [90, Z_B]]) for (a = [lv[0], lv[0] + 180]) rotate(a) {
            // canal del conductor (M6 en 2 m, varilla de 4 mm en 70 cm)
            translate([MR + 1.5, 0, lv[1]]) rotate([0, 90, 0]) cylinder(d = HUB_ROD, h = R_A, $fn = 32);
            if (IS2) {
                // ventana: tuerca + terminal del coaxial + contratuerca sobre la varilla M6
                translate([R_T - 8, -6.5, lv[1] - 6.2]) cube([16, 13, ARM_H]);   // deja paredes laterales
            } else {
                // ventana superior + tornillo M3 con arandela que pisa varilla y terminal
                translate([R_T - 5, -ARM_W / 2 - 1, lv[1] + COND_T / 2 - 0.4]) cube([10, ARM_W + 2, ARM_H]);
                translate([R_T, COND_W / 2 + SCREW / 2 + 0.5, lv[1]]) screw_cut(ARM_H);
            }
        }
        // salida del coaxial hacia el interior del mastil (a 45 grados, entre brazos)
        rotate(45) translate([0, 0, Z_A]) rotate([0, 90, 0]) cylinder(d = 8, h = MR + WALL + 1);
        // fijacion al mastil (tornillo radial M4 + tuerca)
        rotate(225) translate([MR + WALL / 2, 0, HUB_H / 2]) rotate([0, 90, 0]) cylinder(d = 4.4, h = WALL + 2, center = true);
        // rotulos de los bornes grabados en la cara superior (vista desde arriba):
        // A+ (+X) recibe el vivo del coaxial; B+ esta 90 grados antihorario (+Y)  -> RHCP
        for (t = [[0, "A+"], [180, "A-"], [90, "B+"], [270, "B-"]])
            rotate(t[0] + 22) translate([MR + WALL / 2, 0, HUB_H - 0.6]) rotate(-90)
                linear_extrude(1) text(t[1], size = IS2 ? 3 : 2.4, halign = "center", valign = "center",
                                       font = "Liberation Sans:style=Bold");
    }
}

// ------------------------------------------------ TAPA DEL BUJE (protege los bornes)
TAPA_R = R_T + (IS2 ? 10 : 8);
TAPA_H = HUB_H + 6;
module tapa() {
    difference() {
        cylinder(r = TAPA_R + 2, h = TAPA_H);
        translate([0, 0, -1]) cylinder(r = TAPA_R, h = TAPA_H - 1);      // hueco (abierta por abajo: drenaje)
        translate([0, 0, -1]) cylinder(r = MR, h = TAPA_H + 2);            // paso del mastil
        // ranuras para los brazos (la tapa baja desde arriba por el mastil)
        for (a = [0, 180]) rotate(a)
            translate([0, -ARM_W / 2 - 0.4, -1]) cube([TAPA_R + 5, ARM_W + 0.8, Z_A + ARM_H / 2 + 1.4]);
        for (a = [90, 270]) rotate(a)
            translate([0, -ARM_W / 2 - 0.4, -1]) cube([TAPA_R + 5, ARM_W + 0.8, Z_B + ARM_H / 2 + 1.4]);
    }
    // collarin interior que apoya sobre el buje
    difference() {
        translate([0, 0, HUB_H + 0.4]) cylinder(r = MR + WALL, h = TAPA_H - HUB_H - 0.4);
        translate([0, 0, -1]) cylinder(r = MR, h = TAPA_H + 2);
    }
}

// ------------------------------------------------ TOPE SUPERIOR (cruce de los lados altos)
TOP_SOCK = IS2 ? 30 : 22;           // profundidad del casquillo sobre el mastil
TOP_BLK = max(2 * (MR + WALL), COND_W + 16);
module tope() {
    zA = TOP_SOCK + 2 + ARM_H / 2;  zB = zA + DZ;
    h = zB + ARM_H / 2 + 2;
    difference() {
        union() {
            cylinder(r = MR + WALL, h = TOP_SOCK + 2);
            translate([-TOP_BLK / 2, -TOP_BLK / 2, TOP_SOCK]) cube([TOP_BLK, TOP_BLK, h - TOP_SOCK]);
        }
        translate([0, 0, -1]) cylinder(r = MR, h = TOP_SOCK + 1);
        translate([-TOP_BLK, 0, zA]) slot_cut(2 * TOP_BLK);                          // lazo A (X)
        rotate(90) translate([-TOP_BLK, 0, zB]) slot_cut(2 * TOP_BLK);               // lazo B (Y)
        translate([TOP_BLK / 2 - 5, IS2 ? 0 : COND_W / 2 + SCREW / 2 + 0.5, zA]) screw_cut(h);
        translate([IS2 ? 0 : -(COND_W / 2 + SCREW / 2 + 0.5), TOP_BLK / 2 - 5, zB]) screw_cut(h, false);
        translate([0, 0, TOP_SOCK - 8]) rotate([0, 90, 45]) cylinder(d = 3.5, h = 2 * MR + 20, center = true);  // desague / pasador
    }
}

// ------------------------------------------------ SOPORTE DEL REFLECTOR (y guia de taladro)
REF_H = 34;
module reflector() {
    difference() {
        cylinder(r = MR + WALL + 3, h = REF_H);
        translate([0, 0, -1]) cylinder(r = MR, h = REF_H + 2);
        // dos varillas cruzadas a distinta altura (tambien sirven de guia para taladrar el tubo)
        translate([0, 0, 12]) rotate([0, 90, 0]) cylinder(d = REFL_ROD + 0.3, h = 4 * MR, center = true, $fn = 32);
        translate([0, 0, 22]) rotate([90, 0, 0]) cylinder(d = REFL_ROD + 0.3, h = 4 * MR, center = true, $fn = 32);
        // prisioneros M3 (autorroscantes) sobre cada varilla
        for (a = [0, 180]) rotate(a) translate([MR + WALL / 2 + 1.5, 0, 12]) cylinder(d = 2.6, h = 30, $fn = 16);
        for (a = [90, 270]) rotate(a) translate([MR + WALL / 2 + 1.5, 0, 22]) cylinder(d = 2.6, h = 30, $fn = 16);
        // tornillo de fijacion al mastil
        rotate(45) translate([MR + WALL, 0, REF_H / 2]) rotate([0, 90, 0]) cylinder(d = 4.4, h = 12, center = true);
    }
}

// ------------------------------------------------ VISTA DE MONTAJE (no imprimir)
module conductor(p0, p1) { hull() { translate(p0) sphere(d = COND_W, $fn = 12); translate(p1) sphere(d = COND_W, $fn = 12); } }
module montaje() {
    zA = Z_A; zB = Z_B; w = LW / 2; hh = LH;
    color("white", 0.6) translate([0, 0, -RD - 60]) cylinder(d = MAST_D, h = RD + LH + 120);
    color("SteelBlue") buje();
    color("SteelBlue", 0.5) translate([0, 0, 0.2]) tapa();
    color("SteelBlue") translate([0, 0, LH + zA - (TOP_SOCK + 2 + ARM_H / 2)]) tope();
    color("SteelBlue") translate([0, 0, zA - RD - 12]) reflector();
    color("silver") {   // lazos
        for (s = [-1, 1]) conductor([s * (MR + 3), 0, zA], [s * w, 0, zA]);
        conductor([w, 0, zA], [w, 0, zA + hh]); conductor([-w, 0, zA], [-w, 0, zA + hh]);
        conductor([-w, 0, zA + hh], [w, 0, zA + hh]);
        for (s = [-1, 1]) conductor([0, s * (MR + 3), zB], [0, s * w, zB]);
        conductor([0, w, zB], [0, w, zB + hh]); conductor([0, -w, zB], [0, -w, zB + hh]);
        conductor([0, -w, zB + hh], [0, w, zB + hh]);
    }
    color("gray") {     // reflector
        translate([0, 0, zA - RD]) rotate([0, 90, 0]) cylinder(d = REFL_ROD, h = RL, center = true);
        translate([0, 0, zA - RD + 10]) rotate([90, 0, 0]) cylinder(d = REFL_ROD, h = RL, center = true);
    }
}

if (PART == "buje") buje();
else if (PART == "tapa") translate([0, 0, TAPA_H]) rotate([180, 0, 0]) tapa();
else if (PART == "tope") tope();
else if (PART == "reflector") reflector();
else montaje();
MAST_TOP = LH + Z_A - 2 - ARM_H / 2;   // desde la base del buje hasta el extremo del tubo
echo(str("BAND ", BAND, ": buje D", 2 * (MR + WALL), " alto ", HUB_H, "; bornes a +-", R_T,
         " mm; tubo sobre la base del buje: ", MAST_TOP, " mm; varilla reflector A a ", RD, " mm bajo el lazo A",
         " (base del soporte a ", RD + 12 - Z_A, " mm bajo la base del buje)"));
