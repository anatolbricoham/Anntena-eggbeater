# Ajuste y pruebas

## Material
NanoVNA o analizador de antena, carga de 50 Ω, un receptor (SDR o transceptor) y, si puede ser, un walkie con antena vertical.

## 1. Comprobaciones antes de medir
- **Aislamiento en continua:** entre el vivo y la malla del conector de bajada debe haber **continuidad** (baja resistencia en DC), porque cada lazo es una espira cerrada a través de su borne.
- **Separación entre lazos:** comprueba que los lazos A y B no se tocan ni en el tope ni en el buje.
- **Línea de fase:** vivo de A+ a B+ y malla de A− a B− para RHCP.

## 2. ROE / S11
1. **Montaje de la medida:** coloca la antena en su sitio definitivo, o al menos a 3 m del suelo y lejos de objetos metálicos. Mide al final de la bajada, con el choque instalado.
2. **Barrido:** 2 m de 140 a 150 MHz, 70 cm de 420 a 450 MHz.
3. **Criterio:** ROE < 1.5 en toda la sub-banda de satélite (145.8–146.0 / 435–438). Lo esperable es 1.1–1.3.
4. **Si el mínimo sale desplazado:**
   - **Bajo en frecuencia:** los lazos son grandes. Acorta los laterales o los brazos M6 (en 2 m el perímetro cambia ~0.7 %/MHz, ≈4 mm por lateral; en 70 cm ~0.23 %/MHz, ≈0.4 mm por lateral).
   - **Alto en frecuencia:** alarga, o separa un poco más las pestañas.
   - **Mínimo con mucha reactancia:** revisa la longitud de la línea de fase (±10 mm en 2 m, ±3 mm en 70 cm).

## 3. Polarización circular
- **Con walkie de antena vertical:** gira el walkie de vertical a horizontal apuntando a la eggbeater desde varios metros de altura (o desde abajo con la eggbeater en alto). La señal debe variar menos de 3 dB.
- **Sentido de giro (RHCP/LHCP):** si tienes una helicoidal o una Yagi cruzada con polarización conocida, compara la recepción. Invertir B+ y B− debe hacer caer la señal más de 10 dB en el cenit.

## 4. Prueba real con satélites
1. **Pases:** predícelos con Gpredict, SatPC32 u Orbitron. Satélites de prueba: ISS (145.800 FM), SO-50, AO-91 y cubesats de telemetría en 435–438 MHz.
2. **Qué anotar:** relación señal/ruido y elevación a la que se engancha y se pierde la señal.
3. **Qué esperar:** con LNA en el mástil, señal útil desde ~5–10° de elevación en pases buenos.
4. **SatNOGS:** si tienes una estación, sube las observaciones y compara con otras estaciones del mismo pase.
