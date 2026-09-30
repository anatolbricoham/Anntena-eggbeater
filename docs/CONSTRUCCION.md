# Construcción (según K5OE)

## 1. Preparar el mástil
- **Tubo:** de PVC, Ø32 para 2 m y Ø25 para 70 cm. Las medidas se toman **desde la punta del tubo**, que queda dentro del tapón:

| Taladro (en cruz, con el collarín como guía) | 2 m | 70 cm |
|---|---|---|
| Lado inferior del lazo A | 608 mm | 187 mm |
| Lado inferior del lazo B (6 mm más abajo, a 90°) | 614 mm | 193 mm |
| Reflector 1 | 1618 mm | 517 mm |
| Reflector 2 (10 mm más abajo, a 90°) | 1628 mm | 527 mm |

- **Cómo taladrar:** pon cada collarín en su sitio, fíjalo con su autorroscante y taladra el tubo a través de sus agujeros: Ø3.5 para el hilo y Ø6.5 para el reflector.
- **Longitud total:** deja 30 cm de tubo bajo el reflector para amarrar la antena al mástil. En la zona de la antena no debe haber metal.

## 2. Lazos: pasar el hilo por el tubo y doblar
Cada lazo sale de un solo hilo. Marcas desde un extremo, entre ejes. Los 5 mm de cada punta van dentro de la cabeza del tornillo del borne.

| Tramo | 2 m | 70 cm |
|---|---|---|
| Medio lado superior (de la cabeza del tornillo a la esquina, +5 mm dentro de la cabeza) | 232 mm | 64.5 mm |
| Lateral | 630 mm | 209 mm |
| Lado inferior (atraviesa el tubo) | 510 mm | 171 mm |
| Lateral | 630 mm | 209 mm |
| Medio lado superior | 232 mm | 64.5 mm |
| **Total** | **2234 mm** | **718 mm** |

1. **Pasar el hilo:** mete el hilo **recto** por los dos taladros del lazo A y céntralo.
2. **Esquinas inferiores:** dobla las dos a 90° hacia arriba.
3. **Esquinas superiores:** dóblalas hacia el centro. En 70 cm usa la `plantilla_70cm` como referencia.
4. **Lazo B:** repite con el B, 90° girado y 6 mm más abajo.
5. **Fijar:** aprieta los prisioneros del collarín para que los hilos no giren.

## 3. Tapón y bornes (como K5OE)
1. **Tornillos:** taladra la cabeza de cada tornillo de latón (Ø3.5, unos 5 mm de profundidad), mete el extremo del hilo y suéldalo. Esto se hace en el tapón o antes de montarlo.
2. **Coaxial de bajada:** sube el coaxial de 50 Ω por dentro del tubo hasta la cámara del tapón.
3. **Línea de fase RG-62:** en 2 m, córtala a 46.5 cm y pela 2.5 cm en cada extremo, para que queden 41.5 cm con malla. En 70 cm, 18.5 → 13.5 cm. Pon terminales de ojal en vivos y mallas.
4. **Conexiones dentro de la cámara:** tuerca, terminal y contratuerca en cada tornillo:

```
Vista desde arriba          B+ (tornillo en +Y, 6 mm más bajo)
                             |
          A- (−X) ----- [tapón] ----- A+ (+X)
                             |
                            B-
Coaxial de bajada:  vivo -> A+     malla -> A-
Línea de fase RG-62: vivo A+ -> B+   malla A- -> B-      => RHCP
(para LHCP: en el extremo B, vivo -> B- y malla -> B+)
```

5. **Cerrar:** empuja el tapón sobre el tubo (el sobrante de la línea de fase queda dentro del tubo) y fíjalo con el autorroscante de 4.2 mm. Sella los tornillos por fuera con silicona neutra o autovulcanizante.

## 4. Reflectores
Pasa las dos varillas por el collarín y el tubo, céntralas y fíjalas con los prisioneros. Quedan aisladas, igual que en el original.

## 5. Instalación
- **Choque de RF:** justo debajo del reflector. En 2 m, 5–6 espiras de coaxial de Ø10 cm; en 70 cm, 4 espiras de Ø5 cm. También valen ferritas de mezcla 43/61.
- **Emplazamiento:** lo más alto y despejado posible. Separa la antena de 2 m y la de 70 cm al menos 1 m.
- **Preamplificador:** para recepción, un LNA en el mástil (sobre todo en 70 cm).
