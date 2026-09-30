# La Eggbeater II de K5OE

## Diseño
Jerry Brown, K5OE, publicó la *Eggbeater II Omni LEO Antenna* como antena fija, sin rotor, para satélites de órbita baja:
- **Lazos:** dos rectangulares de ~1.1 λ de perímetro, en proporción 45:55 entre lado horizontal y vertical, cruzados a 90° sobre un tubo de PVC.
- **Alimentación:** **en la parte superior**, en un tapón del tubo. Los lados inferiores atraviesan el mástil.
- **Impedancia:** cada lazo de onda completa presenta ~100 Ω; en paralelo dan ~50 Ω. No hace falta adaptador.
- **Línea de fase:** un tramo de **RG-62 (93 Ω)** de ~λ/4 eléctrico entre los dos lazos. Da los 90° de desfase y, con ello, la polarización circular.
- **Reflector:** dos varillas cruzadas de ~½ λ, a ~½ λ por debajo. Refuerzan la radiación hacia el horizonte (0–30°), donde el satélite está más lejos y pasa más tiempo.

Fórmulas de los lazos (f en MHz), recogidas por parker-research a partir de K5OE: **lado horizontal = 7464.8 / f cm** y **lado vertical = 9123.6 / f cm**. Dan 51.2 × 62.5 cm a 145.9 MHz y 17.1 × 20.9 cm a 436.5 MHz, de acuerdo con las medidas publicadas.

## Medidas originales y de dónde salen
No se pudo acceder a la página original de K5OE (wb5rmg.somenet.net) porque redirige en bucle. Las medidas proceden de reconstrucciones que citan su artículo y coinciden entre sí:

| Dato | 2 m | 70 cm | Fuente |
|---|---|---|---|
| Lazos | 51 × 63 cm | 17 × 21 cm (17.1 × 20.9) | ZR6AIC; ZS Link; parker-research |
| Reflectores | 100.5 cm a 101 cm | 33.5 cm a 33 cm | ZR6AIC; ZS Link |
| Línea de fase RG-62 | 41.5 cm | 13.5 cm (cortar 18.5 y pelar 2.5 + 2.5) | ZR6AIC; ZS Link |
| Hilo | #8 AWG | #8 AWG / 3 mm | ZR6AIC; ZS Link |
| Estructura | Tapón con 4 tornillos de latón en la punta del tubo; tubo de PVC | Igual | ZS Link; Libre Space |

## Verificación NEC2
En `sim/k5oe.py` se modela la geometría de K5OE sin tocarla:
- lazos alimentados arriba, con el lazo B 6 mm más bajo;
- hilo de 3.26 mm y reflectores de 1/4";
- la línea de fase como línea de transmisión de 93 Ω con VF 0.84, más 2.5 cm de colas por extremo.

Resultados:
- **Adaptación:** 46 Ω a 145.9 MHz y 51 Ω a 436.5 MHz. ROE ≤ 1.08 en las sub-bandas de satélite.
- **Ancho de banda (ROE < 1.5):** 136–151 MHz y 419–463 MHz. Es muy tolerante a errores de construcción.
- **Diagrama:** máximo de RHCP entre 5° y 25° de elevación (≈ 0 dBic) y unos −2.5/−3 dBic en el cenit. La LHCP queda más de 13 dB por debajo en el cenit.

**Nota sobre 70 cm.** Algunos constructores dicen que su versión de 70 cm resonaba alto (~465 MHz) y recomiendan hacerla un 7 % mayor y recortar. La simulación de las medidas originales **no** muestra ese desplazamiento. Lo más probable es que se deba a esquinas redondeadas, hilos más gruesos o colas largas. Mide y ajusta antes de recortar (ver PRUEBAS).

## Fuentes
- K5OE, *Eggbeater II Omni LEO Antenna*: http://wb5rmg.somenet.net/k5oe/Eggbeater_2.html (original, no accesible desde aquí)
- ZR6AIC, [Building my Eggbeater II Omni LEO Antennas](https://zr6aic.blogspot.com/2013/03/building-my-eggbeater-ii-omni-leo.html)
- ZS Link Network, [The Eggbeater II satellite antenna](https://grhubnetwork.blogspot.com/2022/05/the-eggbeater-ii-satellite-antenna.html)
- parker-research, [Eggbeater-Antenna-PCB (fórmulas K5OE)](https://github.com/parker-research/Eggbeater-Antenna-PCB)
- Libre Space Community, [Home made Eggbeater antenna](https://community.libre.space/t/home-made-eggbeater-antenna/2652)
- Pete Brunelli, [The Well Tuned Eggbeater](https://petebrunelli.com/2022/09/16/the-well-tuned-eggbeater/)
