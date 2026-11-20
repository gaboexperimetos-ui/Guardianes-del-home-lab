# Guardianes del Home Lab — ASUS TUF Gaming A15 FA507RM

Scripts systemd para optimización térmica y energética en un portátil gaming.

## Sistema

- **PC**: ASUS TUF Gaming A15 FA507RM (CachyOS, Hyprland)
- **GPU**: RTX 3060 Laptop (6 GB VRAM)
- **CPU**: Ryzen 7 8845H / 9800HS

## Guardianes

| Script | Función |
|---|---|
| `guardian-cpu` | Curva de potencia por temperatura: 30°C→100W, 65°C→255W |
| `guardian-termico` | Limita reloj GPU según temperatura (escalones con histéresis) |
| `guardian-fondo` | Pausa wallpaper animado en pantalla completa |
| `guardian-perfil` | Revierte perfil de energía cuando no lo elegiste tú |
| `guardian-llm` | Descarga modelo llama.cpp cuando nadie lo usa (evita core al 100%) |
| `fan-guardia` | Fuerza ventiladores máx si sube la temperatura con fans bajos |

## Instalación

```bash
# Copiar scripts a ~/.local/bin
cp *.sh ~/.local/bin/
chmod +x ~/.local/bin/*

# Crear unidades systemd
ln -sf /home/gabo/proyectos/Guardianes-del-home-lab/*.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now guardian-cpu guardian-termico guardian-fondo guardian-perfil guardian-llm fan-guardia

# Verificar
systemctl --user list-units --type=service --state=running
```

## Curva de potencia (guardian-cpu)

| Temperatura | Potencia |
|---|---|
| 30°C | 100W |
| 40°C | 150W |
| 50°C | 200W |
| 55°C | 230W |
| 60°C | 255W |
| 65-70°C | 255W (techo) |

## Limites de temperatura GPU (guardian-termico)

| Temperatura | Reloj |
|---|---|
| ≥94°C | 800 MHz |
| ≥91°C | 1100 MHz |
| ≥88°C | 1400 MHz |
| ≥85°C | 1600 MHz |
| ≥82°C | 1800 MHz |
| ≤78°C | Libre (relojes automáticos) |

## Parar guardianes

```bash
systemctl --user stop guardian-cpu
# o todos:
systemctl --user stop guardian-llm
```

---

*Generado con OpenCode (modelo local)*
