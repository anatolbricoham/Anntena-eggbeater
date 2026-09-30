#!/usr/bin/env bash
# Regenera STL, renders y graficas. La simulacion NEC se lanza con `make sim`.
set -euo pipefail
cd "$(dirname "$0")/.."
OPENSCAD=${OPENSCAD:-openscad}
SCAD=cad/eggbeater_k5oe.scad
mkdir -p stl docs/img
for b in 2m 70cm; do
  parts="tapon guia_lazos guia_reflector"; [ $b = 70cm ] && parts="$parts plantilla"
  for p in $parts; do
    $OPENSCAD -q -D "BAND=\"$b\"" -D "PART=\"$p\"" -o stl/${p}_${b}.stl $SCAD
    xvfb-run -a $OPENSCAD -q -D "BAND=\"$b\"" -D "PART=\"$p\"" --imgsize=700,560 --viewall --autocenter \
        --colorscheme=Tomorrow --camera=0,0,0,50,0,30,0 -o /tmp/_p_$p.png $SCAD
  done
  $OPENSCAD -D "BAND=\"$b\"" -D 'PART="tapon"' -o /tmp/_k.stl $SCAD 2>&1 | grep ECHO | sed 's/ECHO: //'
  xvfb-run -a $OPENSCAD -q -D "BAND=\"$b\"" -D 'PART="montaje"' --imgsize=1000,1500 --viewall --autocenter \
      --colorscheme=Tomorrow --camera=0,0,0,75,0,35,0 -o docs/img/montaje_$b.png $SCAD
  python3 - "$b" $parts <<'PY'
import sys
from PIL import Image
b, parts = sys.argv[1], sys.argv[2:]
ims = [Image.open(f'/tmp/_p_{p}.png') for p in parts]
c = Image.new('RGB', (1400, 560 * ((len(ims) + 1) // 2)), 'white')
for i, im in enumerate(ims): c.paste(im, ((i % 2) * 700, (i // 2) * 560))
c.save(f'docs/img/piezas_{b}.png')
PY
done
python3 sim/plot.py
echo "Build OK"
