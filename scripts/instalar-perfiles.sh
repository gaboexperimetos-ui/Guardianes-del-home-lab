#!/bin/bash
# ============================================================================
# instalar-perfiles.sh — instalación única (requiere sudo)
#   sudo ~/.local/bin/instalar-perfiles.sh
#
# 1. Instala perfil-root en /usr/local/bin
# 2. Autoriza sudo sin contraseña SOLO para perfil-root
# 3. Desactiva los servicios que re-clavan la CPU en "performance"
# ============================================================================
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "ERROR: ejecútalo con sudo."; exit 1; }

USUARIO="${SUDO_USER:-gabo}"
ORIGEN="$(eval echo "~$USUARIO")/.local/bin/perfil-root"

echo "==> 1/3  Instalando perfil-root"
install -o root -g root -m 0755 "$ORIGEN" /usr/local/bin/perfil-root
echo "    /usr/local/bin/perfil-root instalado"

echo "==> 2/3  Regla sudoers (sin contraseña para perfil-root)"
printf '%s ALL=(root) NOPASSWD: /usr/local/bin/perfil-root\n' "$USUARIO" > /etc/sudoers.d/perfil
chmod 0440 /etc/sudoers.d/perfil
visudo -c -f /etc/sudoers.d/perfil >/dev/null && echo "    regla válida: /etc/sudoers.d/perfil"

echo "==> 3/3  Quitando los reaplicadores de 'performance'"
systemctl disable --now max-performance.timer 2>/dev/null || true
systemctl disable --now cpu-epp-performance.service 2>/dev/null || true
systemctl disable --now cpu-clock-lock.service 2>/dev/null || true
echo "    max-performance.timer / cpu-epp-performance.service desactivados"

echo "==> extra: memoria (swappiness 150 -> 100)"
echo 'vm.swappiness = 100' > /etc/sysctl.d/99-swappiness.conf
sysctl -q -w vm.swappiness=100
echo "    vm.swappiness = $(cat /proc/sys/vm/swappiness)"

echo
echo "==> LISTO. Prueba con:  perfil medio"
echo "    Para revertir el timer:  sudo systemctl enable --now max-performance.timer"
