# Teoría y documentación sobre la antena Eggbeater

## Qué es
La *eggbeater* ("batidora") es una **turnstile de lazos**: dos lazos de 1 λ cruzados a 90° y alimentados con un desfase de 90°. Así radia en **polarización circular** en el cenit y se acerca a lineal horizontal en el horizonte. Es omnidireccional en azimut y no necesita rotor. Por eso es la antena fija clásica para satélites LEO (ISS, cubesats, FM y SSB) y para estaciones SatNOGS.

## Principio de funcionamiento
- **Lazos:** cada uno tiene ~1 λ de perímetro. Un lazo de onda completa resuena con **~100 Ω**.
  - ON6WG/F5VIF recomiendan alargar el perímetro un 4 % en VHF y un 10 % en UHF.
  - En este diseño los rectángulos quedan en 1.073 λ (2 m) y 1.094 λ (70 cm).
- **Adaptación:** los dos lazos en paralelo dan **~50 Ω**, así que no hace falta adaptador.
- **Línea de fase:** es una línea de **λ/4 de 93 Ω** (RG-62, VF 0.86) entre los puntos de alimentación. Da los 90° de desfase y apenas altera la impedancia, porque su Z0 ≈ √(100·93).
- **Reflector:** debajo de los lazos, es lo que da forma al diagrama en elevación.
  - A **0.5 λ** (K5OE, EA5WA) refuerza los ángulos bajos, pero deja un bache a 50–70°.
  - A **1/8 λ con plano de 8 radiales** (ON6WG) favorece el cenit.
  - A **0.4 λ** (este diseño) se consigue el mejor margen de enlace para LEO entre 10° y 90°.
- **Polarización:** el sentido (RHCP o LHCP) solo depende de cómo se cruce la línea de fase. Lo habitual para satélites es RHCP.
  - Tras el paso por el cenit o en satélites que dan tumbos, la polarización recibida puede invertirse o volverse lineal. Una eggbeater lo tolera mejor que una antena directiva.

## Diseños de referencia consultados

| Diseño | Banda | Lazos | Reflector | Línea de fase | Resultado |
|---|---|---|---|---|---|
| **EA5WA Eggbeater V2** | 145 MHz | 680 × 440 mm, pletina de Al de 10 mm, lado inferior con varillas M6 | 2 varillas de Al Ø4 de 1 m, ~1 m por debajo | RG-62, 419 mm | ROE 1.1, RL 26 dB, mejor que una QFH por debajo de 20° |
| **K5OE Eggbeater II** (según ZR6AIC) | 2 m | 51 × 63 cm, hilo #8 AWG | 100.5 cm, a 101 cm por debajo | RG-62, 41.5 cm | "Oye bien de horizonte a horizonte" |
| **K5OE Eggbeater II** | 70 cm | 17 × 21 cm, Cu 2.5 mm | 33.5 cm, a 33 cm por debajo | RG-62, 13.5 cm | |
| **ON6WG / F5VIF** | 145 / 435 | Circulares, perímetro 1005/f (ft) | 8 radiales de λ/4, a λ/8 por debajo | L = 246·VF/f (ft) | Máximo a 30–55° de elevación |
| **M0AWS** | 70 cm | Circulares, 73.5 cm de perímetro, Ø5 mm | 8 radiales de 34.15 cm, a 5 cm | | ROE < 1.5 en toda la banda |
| **Comunidad Libre Space (SatNOGS)** | 137 / 145 / 435 | K5OE | | RG-62 | Guía de taladro impresa en 3D |
| **RZ01** | 70 cm | Piezas en PETG (Thingiverse 4737130) | | | Lazos redondos mejor que rectangulares durante el ajuste; LNA en mástil |

## Qué ha cambiado respecto a la V2 de EA5WA
1. **Frecuencias:** centrado en las sub-bandas de satélite (145.9 y 436.5 MHz) en vez de 145.0.
2. **Reflector:** a **0.4 λ** (822 mm en 2 m), en lugar de 1 m, y con varillas de 986 mm. Así se gana ≈1 dB entre 15° y 35° de elevación.
3. **Versión de 70 cm:** es la misma geometría escalada. La adaptación y la línea de fase se han reoptimizado.
4. **Piezas impresas:** sustituyen al manguito de PVC taladrado. El desnivel entre lazos queda fijado (12 y 8 mm) y los bornes están rotulados. La tapa protege las conexiones y el collarín del reflector hace de guía de taladro.

## Limitaciones del modelo
- **Suelo:** se simula en espacio libre. Con suelo real, a unos 5–10 m de altura, aparecen lóbulos y nulos en los ángulos más bajos (< 10°).
- **Conductores:** la pletina se modela como un hilo de radio equivalente (¼ de la suma de ancho y grosor). Las esquinas se suponen vivas y el buje se modela como una separación de un solo segmento.
- **Ajuste final:** todo esto se corrige en la práctica ajustando el tamaño de los lazos y la línea de fase con el analizador (ver PRUEBAS).

## Fuentes
- EA5WA, [Antena Eggbeater V2](https://www.ea5wa.com/antenas/antena-eggbeater-v2)
- ON6WG / F5VIF, [Eggbeater VHF/UHF, parte 1 (PDF)](https://qsl.net/k/kd7tww/Antennas/Antenne%20Eggbeater-Engl-Part1-Full.pdf)
- ZR6AIC, [Building my Eggbeater II Omni LEO Antennas](https://zr6aic.blogspot.com/2013/03/building-my-eggbeater-ii-omni-leo.html)
- M0AWS, [70cm Band Eggbeater Satellite Antenna](https://m0aws.co.uk/?p=2106)
- Libre Space Community, [Home made Eggbeater antenna](https://community.libre.space/t/home-made-eggbeater-antenna/2652)
- RZ01, [Building a LEO SAT ground station: 70cm Eggbeater](https://rz01.org/70cm-eggbeater-antenna/)
- Thingiverse, [70 cm Eggbeater (thing:4737130)](https://www.thingiverse.com/thing:4737130) y [2 m Eggbeater DK1MI (thing:5993759)](https://www.thingiverse.com/thing:5993759)
