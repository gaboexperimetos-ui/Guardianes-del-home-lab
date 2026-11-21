# Guardianes del Home Lab — ASUS TUF Gaming A15 FA507RM

Scripts y unidades systemd para optimización térmica y energética en un portátil
gaming ASUS TUF, con guardas que evitan que la CPU/GPU se sobrecalienten o se
queden clavadas a máxima potencia sin que tú lo pidas.

## Sistema

- **PC**: ASUS TUF Gaming A15 FA507RM (CachyOS, Hyprland)
- **GPU**: RTX 3060 Laptop (6 GB VRAM) + iGPU Radeon 680M
- **CPU**: Ryzen 7 8845H / 9800HS
- **Controladora**: asusctl / asusd / supergfxctl / `asus-fan-control-ec`

## Guardianes

| Script | Función |
|---|---|
| `guardian-cpu` | Curva de potencia por temperatura: 30°C→100W, 65°C→255W; limita PPT si Tctl ≥ 82°C |
| `guardian-termico` | Limita reloj GPU según temperatura (escalones con histéresis 78–94°C) |
| `guardian-fondo` | Pausa wallpaper animado en pantalla completa (ahorra CPU y GPU) |
| `guardian-perfil` | Revierte al perfil de energía que elegiste cuando un servicio de root lo cambia |
| `guardian-llm` | Descarga el modelo de llama.cpp cuando nadie lo usa (evita un core al 100%) |
| `fan-guardia` | Fuerza ventiladores al máximo si sube la temperatura con fans en nivel bajo |

### Scripts de apoyo

| Script | Función |
|---|---|
| `fan-nivel` | Control manual de ventiladores por niveles (0 auto, 1–5 PWM, 5 = EC 255/255) |
| `perfil` | Selector único de perfiles de energía + MUX (`bateria` / `equilibrio` / `rendimiento`) |
| `perfil-root` | Parte privilegiada de los perfiles (PPT, EPP, governor, curva de fans, dGPU) |
| `gpu-fix` | Resetea relojes de la GPU si la memoria queda anclada a 810 MHz bajo carga |
| `instalar-perfiles.sh` | Instalación única: perfil-root, regla sudoers, desactiva reaplicadores de `performance` |

## Estructura

```
Guardianes-del-home-lab/
├── scripts/     # todos los ejecutables (guardianes + apoyo)
├── systemd/     # unidades systemd --user listas para enlazar
├── README.md
├── LICENSE
└── CONTRIBUTING.md
```

## Instalación

```bash
# 1. Copiar scripts a ~/.local/bin
cp scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*

# 2. Instalar la parte privilegiada (una sola vez, como root)
sudo ~/.local/bin/instalar-perfiles.sh

# 3. Enlazar las unidades systemd de usuario
ln -sf "$PWD"/systemd/*.service ~/.config/systemd/user/
systemctl --user daemon-reload

# 4. Activar los guardianes
systemctl --user enable --now \
  guardian-cpu guardian-termico guardian-fondo guardian-perfil guardian-llm fan-guardia

# 5. Verificar
systemctl --user list-units --type=service --state=running | grep -E 'guardian|fan-guardia'
```

> Las unidades referencian rutas absolutas de `/home/gabo/.local/bin/...`.
> Ajusta `ExecStart` si tu usuario no es `gabo`.

## Curva de potencia (guardian-cpu)

| Temperatura | Potencia |
|---|---|
| 30°C | 100W |
| 40°C | 150W |
| 50°C | 200W |
| 55°C | 230W |
| 60°C | 255W |
| 65-70°C | 255W (techo) |

Si Tctl ≥ 82°C limita el PPT a 45W (salvo perfil batería). Vuelve a restaurar
cuando Tctl ≤ 65°C.

## Límites de temperatura GPU (guardian-termico)

| Temperatura | Reloj |
|---|---|
| ≥94°C | 800 MHz |
| ≥91°C | 1100 MHz |
| ≥88°C | 1400 MHz |
| ≥85°C | 1600 MHz |
| ≥82°C | 1800 MHz |
| ≤78°C | Libre (relojes automáticos) |

Entre 78 y 82°C mantiene el último escalón (histéresis).

## Parar guardianes

```bash
# uno
systemctl --user stop guardian-cpu
# o todos
systemctl --user stop guardian-cpu guardian-termico guardian-fondo \
  guardian-perfil guardian-llm fan-guardia
```

---

*Generado con OpenCode (modelo local)*