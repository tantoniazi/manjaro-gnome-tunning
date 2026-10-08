#!/bin/bash
set -e
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          GNOME Quick Install                              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"
print_header() { echo -e "\n${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_header "Atualizando e instalando dependências..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git unzip wget
print_success "Dependências OK"
print_header "Instalando temas..."
THEMES_DIR="$HOME/.themes"
mkdir -p "$THEMES_DIR"
cd /tmp
git clone --depth 1 https://github.com/vinceliuice/Orchis-theme.git 2>/dev/null && cd Orchis-theme && ./install.sh -d "$THEMES_DIR" -t light -c compact 2>/dev/null || true
git clone --depth 1 https://github.com/dracula/gtk.git dracula-gtk 2>/dev/null && cp -r dracula-gtk/Dracula* "$THEMES_DIR/" 2>/dev/null || true
print_success "Temas OK"
print_header "Instalando ícones..."
ICONS_DIR="$HOME/.local/share/icons"
mkdir -p "$ICONS_DIR"
cd /tmp
git clone --depth 1 https://github.com/PapirusDev/papirus-icon-theme.git 2>/dev/null && cd papirus-icon-theme && ./install.sh -d "$ICONS_DIR" 2>/dev/null || true
print_success "Ícones OK"
print_header "Instalando fontes..."
sudo pacman -S --needed --noconfirm ttf-roboto ttf-roboto-mono ttf-fira-code noto-fonts noto-fonts-emoji 2>/dev/null || true
print_success "Fontes OK"
print_header "Aplicando tema..."
dconf write /org/gnome/desktop/interface/gtk-theme "'Orchis-Light-Compact'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/font-name "'Roboto 11'" 2>/dev/null || true
dconf write /org/gnome/desktop/peripherals/keyboard/delay "uint32 200" 2>/dev/null || true
print_success "Tema aplicado"
echo -e "\n${GREEN}✓ Concluído!${NC}"
echo -e "\nReinicie GNOME: Alt+F2 → r → Enter"
