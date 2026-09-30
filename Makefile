.PHONY: all sim clean
all:     ## STL + renders + graficas (desde sim/resultados.json)
	bash scripts/build.sh
sim:     ## Simulacion NEC2 y ajuste para satelites (~2 min, requiere nec2c)
	python3 sim/optimize.py && bash scripts/build.sh
clean:
	rm -rf stl cad/gen
