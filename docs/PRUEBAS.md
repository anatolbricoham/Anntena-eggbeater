# Ajuste y pruebas

## 1. Antes de medir
- **Continuidad:** entre el vivo y la malla del conector debe haber **continuidad en DC**, porque cada lazo es una espira cerrada.
- **Aislamiento:** los lazos A y B no se tocan entre sí y los reflectores no tocan los lazos.
- **Cableado de la fase:** A+→B+ y A−→B− para RHCP.

## 2. ROE
1. **Montaje:** antena en su sitio, o a más de 3 m del suelo y lejos de metal. Mide al final de la bajada, con el choque puesto.
2. **Barrido:** 2 m de 135 a 155 MHz, 70 cm de 410 a 470 MHz.
3. **Esperado (simulación):** ROE ≤ 1.1 en 145.8–146.0 y 435–438 MHz, y < 1.5 en una banda muy ancha.
4. **Si el mínimo sale muy desplazado:**
   - Primero revisa las medidas (entre ejes), las esquinas y las colas de la línea de fase.
   - Después ajusta los laterales, igual en los dos lazos. En 2 m el perímetro cambia ~0.7 %/MHz, unos 4 mm por lateral; en 70 cm ~0.23 %/MHz, unos 0.5 mm por lateral.

## 3. Polarización
- **Con un walkie con antena vertical,** a distancia: gíralo de vertical a horizontal. La variación debe ser menor de 3 dB.
- **Sentido:** cruzar la línea de fase en B (LHCP) debe hacer caer la señal en el cenit de un satélite o de una fuente RHCP conocida.

## 4. Con satélites
1. **Pases:** predícelos con Gpredict, SatPC32 u Orbitron. Prueba con la ISS (145.800 FM), SO-50 (436.795), AO-91 y las balizas de cubesats en 435–438 MHz.
2. **Qué anotar:** la elevación a la que se engancha y se pierde la señal, y la S/N.
3. **Qué esperar:** con LNA, señal desde 5–10° en pases buenos. Por el diagrama de K5OE, la señal debe mantenerse bastante constante durante todo el pase.
