# Contributing

Bienvenido a los guardianes del home lab! Si quieres mejorar algún script o añadir uno nuevo, abre un PR.

## Scripts existentes

- `guardian-cpu` — Curva de potencia térmica
- `guardian-termico` — Limites de reloj por temperatura GPU
- `guardian-fondo` — Pausa wallpaper en pantalla completa
- `guardian-perfil` — Mantiene el perfil de energía elegido
- `guardian-llm` — Descarga modelo llama.cpp cuando nadie lo usa
- `fan-guardia` — Fuerza ventiladores máx ante sobrecalentamiento

## Añadir un nuevo guardian

1. Crea un script `.sh` con la lógica del guardián
2. Crea el archivo correspondiente en `.config/systemd/user/`
3. Añade a este README

---

*Generado con OpenCode (modelo local)*
