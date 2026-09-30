# Construcción paso a paso

Las medidas salen de `sim/resultados.json`. Si vuelves a simular, se actualizan las piezas, pero **no** este texto: revisa las cifras.

## 1. Cortar y doblar los lazos

### 2 m: "U" de pletina + lado inferior de varilla roscada (como EA5WA)
- **Doblado de la pletina:** dóblala por su canto fino (la cara de 10 mm queda perpendicular al plano del lazo). Marcas desde un extremo:

| Tramo | Longitud |
|---|---|
| Pestaña inferior (se dobla 90° hacia dentro; taladro Ø6.5 a 12 mm del extremo) | 25 mm |
| Lateral | 669 mm |
| Lado superior (taladro Ø4.5 en el punto que cae bajo el tornillo del tope) | 433 mm |
| Lateral | 669 mm |
| Pestaña inferior | 25 mm |
| **Total por lazo** | **1821 mm** (sale de una barra de 2 m) |

- **Lado inferior:** son 2 varillas roscadas M6 de 215 mm por lazo. Van del buje a la esquina y se unen a la pestaña con tuerca y contratuerca.

### 70 cm: lazo de una sola varilla de 4 mm
Marcas desde un extremo: 59 | 228 | 148 | 228 | 59 mm (**723 mm** en total). Los dos extremos entran en los canales del buje.

> Mide el ancho y el alto **entre ejes** del conductor, no por fuera. Unos pocos mm de diferencia se corrigen luego con el ajuste de la ROE.

## 2. Preparar el mástil
- **Tubo de PVC** (Ø32 para 2 m, Ø25 para 70 cm).
- **Longitud sobre el buje:** por encima de la base del buje, el tubo mide **695 mm** en 2 m y **242 mm** en 70 cm. Encima encaja el `tope`.
- **Collarín del reflector:** su base va a **798 mm** (2 m) o **265 mm** (70 cm) por debajo de la base del buje.
- **Taladros:** usa el propio collarín como guía para taladrar las dos varillas del reflector a través del tubo. Taladra también el paso del coaxial frente al agujero de 45° del buje.
- **Longitud total:** deja al menos 30 cm de tubo bajo el reflector para amarrarlo al mástil de la estación.
- **Material:** la zona de la antena debe ser siempre de plástico. No uses tubo metálico hasta más abajo del reflector.

## 3. Montaje
1. **Buje (primera pasada):** mete el buje en el tubo con el rótulo **A+** mirando a donde quieras orientar el lazo A. Atorníllalo al tubo con el autorroscante radial.
2. **2 m, lado inferior:** enrosca cada varilla M6 en su brazo. Dentro de la ventana van tuerca, **terminal de ojal del coaxial** y contratuerca. Por fuera, otra tuerca contra el brazo.
3. **70 cm, extremos del lazo:** introduce los extremos de la varilla en los canales. Cada borne lleva un tornillo M3 con arandela que pisa a la vez la varilla y el terminal.
4. **Tope:** mete los lados superiores de los lazos en las dos ranuras del tope (A la de abajo, B la de arriba) y fija los tornillos. Encaja el tope en el tubo.
5. **2 m, pestañas:** une las pestañas de la pletina con las varillas M6 de las esquinas.
6. **Reflector:** pasa las dos varillas por el collarín y el tubo, céntralas y apriétalas con los prisioneros M3.

## 4. Coaxial y línea de fase (RHCP)
Vista desde arriba: B+ está 90° **en sentido antihorario** desde A+. Así van rotulados en el buje.

```
             B+ (+Y)
              |
   A- (-X) ---+--- A+ (+X)   <- vivo del coaxial de bajada en A+, malla en A-
              |
             B- (-Y)
Línea de fase RG-62:  vivo  A+ -> B+     malla  A- -> B-
```

- **Longitudes de la línea de fase:**
  - 2 m: **363 mm** de cable con cubierta, más colas de 20 mm en cada extremo (403 mm en total).
  - 70 cm: **116 mm** + 2 × 10 mm.
- **Cambiar la polarización:** para **LHCP**, cruza solo el extremo B (vivo a B−, malla a B+).
- **Sin RG-62:** en la simulación, RG-59 o RG-6 (75 Ω) también adaptan, con ROE ≤ 1.05, pero la línea tiene que ser más larga: unos 1.1 λ/4 × VF del cable. **No uses 50 Ω** (RG-58): la ROE sube a 1.9.
- **Coaxial de bajada:** baja por dentro del tubo. Justo bajo el reflector, pon un **choque de RF**: 5 o 6 espiras de Ø10 cm del mismo coaxial en 2 m, 4 espiras de Ø5 cm en 70 cm, o 5–7 ferritas de mezcla 43 / 61.
- **Estanqueidad:** sella las conexiones con cinta autovulcanizante. Después baja la `tapa` por el tubo hasta cubrir el buje.

## 5. Montaje en el mástil y en la estación
- **Altura:** cuanto más alta y despejada esté, mejor, porque el horizonte es lo que más cuenta en satélite. Aléjala al menos 1 m de otras antenas.
- **Dos bandas:** usa dos antenas (2 m y 70 cm) en mástiles separados, o la de 70 cm al menos 1 m por encima de la de 2 m.
  - Ambas pueden llegar a un solo coaxial con el diplexor 2 m/70 cm (repositorio `diplexor-2m70cm`). Para recepción, con **LNA**, van mejor dos bajadas independientes.
- **Preamplificador (LNA):** en 70 cm es casi imprescindible. Ponlo en el mástil, junto a la antena, y usa un secuenciador si también transmites.
- **Potencia admisible:** el RG-62 de la línea de fase aguanta con holgura 50–100 W en 2 m y en 70 cm.
