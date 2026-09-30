.PHONY: all sim clean
all:     ## STL + renders + graficas
	bash scripts/build.sh
sim:     ## Verificacion NEC2 del diseno original de K5OE (requiere nec2c)
	python3 sim/k5oe.py && bash scripts/build.sh
clean:
	rm -rf stl
