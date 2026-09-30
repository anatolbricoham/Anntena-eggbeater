// =====================================================================
//  Eggbeater II de K5OE: piezas imprimibles (2 m y 70 cm)
//  Geometria ORIGINAL de K5OE: lazos rectangulares alimentados ARRIBA en el tapon
//  del mastil, lados inferiores atravesando el mastil, 2 reflectores cruzados debajo.
//
//  openscad -D 'BAND="2m"' -D 'PART="tapon"' -o tapon.stl eggbeater_k5oe.scad
//    BAND = "2m" | "70cm"
//    PART = "tapon" | "guia_lazos" | "guia_reflector" | "plantilla" (solo 70 cm) | "montaje"
//  Unidades: mm. Imprimir en ASA o PETG, 4 perimetros, 40 % de relleno.
// =====================================================================
BAND = "2m";
PART = "montaje";
$fn = 72;
IS2 = BAND == "2m";

// ---------------- medidas de K5OE (no cambiar) ----------------
LOOP_W = IS2 ? 510 : 171;       // ancho del lazo (entre ejes del hilo)
LOOP_H = IS2 ? 630 : 209;       // alto del lazo
REFL_L = IS2 ? 1005 : 335;      // longitud de cada reflector
REFL_D = IS2 ? 1010 : 330;      // distancia bajo los lados inferiores de los lazos
PHASE  = IS2 ? 415 : 135;       // RG-62 con malla (se cortan 50 mm mas: 25 mm pelados por extremo)

// ---------------- mecanica (ajustable) ----------------
MAST_D = IS2 ? 32 : 25;         // tubo de PVC (K5OE: PVC de 1")
CLR    = 0.4;
WIRE   = 3.3;                   // hilo de cobre #8 AWG (3.26 mm) o varilla de 3 mm
ROD    = 6.5;                   // reflectores: varilla de aluminio de 1/4" (6.35 mm)
DZ     = 6;                     // desnivel entre lazo A y lazo B (el B va 6 mm mas bajo)
BOLT   = IS2 ? 6 : 5;           // tornillo de laton de los bornes (M6 / M5)

MR = MAST_D / 2 + CLR;

// ------------------------------------------------ TAPON DE ALIMENTACION
CH_D   = IS2 ? 36 : 32;         // camara interior (tuercas, terminales, linea de fase)
CAP_W  = 4;
SOCK   = IS2 ? 30 : 25;         // encaje sobre el tubo
CH_H   = 30;
CAP_OD = max(CH_D, 2 * MR) + 2 * CAP_W;
Z_BA   = SOCK + CH_H - 8;       // nivel de los bornes del lazo A
Z_BB   = Z_BA - DZ;             // nivel de los bornes del lazo B
CAP_H  = SOCK + CH_H + 3;
BORNES = [[0, Z_BA], [90, Z_BB], [180, Z_BA], [270, Z_BB]];
module tapon() {
    difference() {
        union() {
            cylinder(d = CAP_OD, h = CAP_H);
            for (t = BORNES)   // asiento plano para la cabeza de cada tornillo
                rotate(t[0]) translate([CAP_OD / 2 - 1.5, -8, t[1] - 8]) cube([3.5, 16, 16]);
        }
        translate([0, 0, -1]) cylinder(r = MR, h = SOCK + 1);                   // encaje del tubo
        translate([0, 0, SOCK - 0.01]) cylinder(d = CH_D, h = CH_H);             // camara
        for (t = BORNES)
            rotate(t[0]) translate([0, 0, t[1]]) rotate([0, 90, 0]) cylinder(d = BOLT + 0.4, h = CAP_OD, $fn = 32);
        // rotulos en el lateral (vista desde arriba: B+ 90 grados antihorario desde A+ -> RHCP)
        for (t = [[0, "A+"], [180, "A-"], [90, "B+"], [270, "B-"]])
            rotate(t[0] + 28) translate([CAP_OD / 2 - 0.6, 0, CAP_H - 5]) rotate([90, 0, 90])
                linear_extrude(1) text(t[1], size = 4, halign = "center", valign = "center",
                                       font = "Liberation Sans:style=Bold");
        rotate(45) translate([MR, 0, SOCK / 2]) rotate([0, 90, 0]) cylinder(d = 4.4, h = 20, center = true);
    }
}

// ------------------------------------------------ COLLARINES (guia de taladro + sujecion)
module collarin(hole, sep, h) {
    difference() {
        cylinder(r = MR + 7, h = h);
        translate([0, 0, -1]) cylinder(r = MR, h = h + 2);
        // dos pasos cruzados: el de arriba (lazo A / reflector 1) en el eje X
        translate([0, 0, h / 2 + sep / 2]) rotate([0, 90, 0]) cylinder(d = hole, h = 4 * MR + 30, center = true, $fn = 32);
        translate([0, 0, h / 2 - sep / 2]) rotate([90, 0, 0]) cylinder(d = hole, h = 4 * MR + 30, center = true, $fn = 32);
        // prisioneros M3 autorroscantes
        for (a = [0, 180]) rotate(a) translate([MR + 3.5, 0, h / 2 + sep / 2]) cylinder(d = 2.6, h = h, $fn = 16);
        for (a = [90, 270]) rotate(a) translate([MR + 3.5, 0, -1]) cylinder(d = 2.6, h = h / 2 - sep / 2 + 1, $fn = 16);
        rotate(45) translate([MR + 3.5, 0, h / 2]) rotate([0, 90, 0]) cylinder(d = 4.4, h = 20, center = true);
    }
}
module guia_lazos()     collarin(WIRE + 0.3, DZ, 26);
module guia_reflector() collarin(ROD + 0.3, 10, 34);

// ------------------------------------------------ PLANTILLA DE DOBLADO (70 cm)
module plantilla() {
    m = 10; t = 4; W = LOOP_W; H = LOOP_H;
    difference() {
        translate([-W / 2 - m, -m, 0]) cube([W + 2 * m, H + 2 * m, t]);
        for (s = [[[-W / 2, 0], [W / 2, 0]], [[W / 2, 0], [W / 2, H]], [[-W / 2, 0], [-W / 2, H]],
                  [[-W / 2, H], [-6, H]], [[6, H], [W / 2, H]]])
            hull() for (p = s) translate([p[0], p[1], t - WIRE / 2 + 0.3]) sphere(d = WIRE + 0.4, $fn = 16);
        translate([-W / 2 + 12, 22, -1]) cube([W - 24, H - 44, t + 2]);    // aligerado
        translate([0, 12, t - 0.6]) linear_extrude(1)
            text(str("K5OE 70cm ", W, "x", H), size = 5, halign = "center", font = "Liberation Sans:style=Bold");
    }
}

// ------------------------------------------------ VISTA DE MONTAJE
module w(a, b, d = WIRE) hull() { translate(a) sphere(d = d, $fn = 10); translate(b) sphere(d = d, $fn = 10); }
GL_H = 26; GR_H = 34;
module montaje() {
    zA = Z_BA; zB = Z_BB; x0 = CAP_OD / 2 + 2; ww = LOOP_W / 2;
    color("white", 0.6) translate([0, 0, zA - LOOP_H - REFL_D - 200]) cylinder(d = MAST_D, h = SOCK - (zA - LOOP_H - REFL_D - 200));
    color("SteelBlue") tapon();
    color("SteelBlue") translate([0, 0, zA - LOOP_H - GL_H / 2 - DZ / 2]) guia_lazos();
    color("SteelBlue") translate([0, 0, zA - LOOP_H - REFL_D - GR_H / 2 - 5]) guia_reflector();
    color("#b87333") {
        for (s = [-1, 1]) w([s * x0, 0, zA], [s * ww, 0, zA]);
        for (s = [-1, 1]) w([s * ww, 0, zA], [s * ww, 0, zA - LOOP_H]);
        w([-ww, 0, zA - LOOP_H], [ww, 0, zA - LOOP_H]);
        for (s = [-1, 1]) w([0, s * x0, zB], [0, s * ww, zB]);
        for (s = [-1, 1]) w([0, s * ww, zB], [0, s * ww, zB - LOOP_H]);
        w([0, -ww, zB - LOOP_H], [0, ww, zB - LOOP_H]);
    }
    color("gray") {
        w([-REFL_L / 2, 0, zA - LOOP_H - REFL_D], [REFL_L / 2, 0, zA - LOOP_H - REFL_D], ROD);
        w([0, -REFL_L / 2, zA - LOOP_H - REFL_D - 10], [0, REFL_L / 2, zA - LOOP_H - REFL_D - 10], ROD);
    }
}

if (PART == "tapon") translate([0, 0, CAP_H]) rotate([180, 0, 0]) tapon();   // imprimir boca abajo
else if (PART == "guia_lazos") guia_lazos();
else if (PART == "guia_reflector") guia_reflector();
else if (PART == "plantilla") plantilla();
else montaje();
echo(str("K5OE ", BAND, ": tapon D", CAP_OD, " x ", CAP_H, " mm; bornes a ", Z_BA, " mm del borde inferior del tapon;",
         " lazos: ", 2 * LOOP_H + 2 * LOOP_W, " mm de perimetro"));
