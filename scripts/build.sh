#!/usr/bin/env bash
# Regenera piezas STL, renders y graficas a partir de sim/resultados.json.
# (La simulacion NEC, mas lenta, se lanza con `make sim`.)
set -euo pipefail
cd "$(dirname "$0")/.."
OPENSCAD=${OPENSCAD:-openscad}
python3 scripts/gen_cad_inc.py
mkdir -p stl docs/img
for b in 2m 70cm; do
  for p in buje tapa tope reflector; do
    $OPENSCAD -q -D "BAND=\"$b\"" -D "PART=\"$p\"" -o stl/${p}_${b}.stl cad/eggbeater_piezas.scad
  done
  $OPENSCAD -D "BAND=\"$b\"" -D 'PART="buje"' -o /tmp/_egg.stl cad/eggbeater_piezas.scad 2>&1 | grep ECHO | sed 's/ECHO: //'
  xvfb-run -a $OPENSCAD -q -D "BAND=\"$b\"" -D 'PART="montaje"' --imgsize=1000,1400 --viewall --autocenter \
      --colorscheme=Tomorrow --camera=0,0,0,70,0,35,0 -o docs/img/montaje_$b.png cad/eggbeater_piezas.scad
  for p in buje tapa tope reflector; do
    xvfb-run -a $OPENSCAD -q -D "BAND=\"$b\"" -D "PART=\"$p\"" --imgsize=700,560 --viewall --autocenter \
        --colorscheme=Tomorrow --camera=0,0,0,50,0,30,0 -o /tmp/_p_$p.png cad/eggbeater_piezas.scad
  done
  python3 - "$b" <<'PY'
import sys
from PIL import Image
b = sys.argv[1]
ims = [Image.open(f'/tmp/_p_{p}.png') for p in ('buje', 'tapa', 'tope', 'reflector')]
c = Image.new('RGB', (1400, 1120), 'white')
for i, im in enumerate(ims): c.paste(im, ((i % 2) * 700, (i // 2) * 560))
c.save(f'docs/img/piezas_{b}.png')
PY
done
python3 sim/plot.py
echo "Build OK"
