#!/bin/bash

#############################################################################
# GNOME Optimization Script for Manjaro
# Instala temas bonitos, extensões úteis e otimiza performance
#############################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        GNOME Optimization Script for Manjaro              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"

# Função para imprimir headers
print_header() {
    echo -e "\n${BLUE}▶ $1${NC}"
}

# Função para imprimir sucesso
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Função para imprimir warning
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Verificar se está rodando em Manjaro
if ! grep -i "manjaro" /etc/os-release > /dev/null; then
    print_warning "Este script foi otimizado para Manjaro. Continuando mesmo assim..."
fi

# Verificar permissões sudo
if ! sudo -n true 2>/dev/null; then
    print_header "Autenticação necessária"
    sudo -v
fi

#############################################################################
# 1. ATUALIZAR SISTEMA
#############################################################################
print_header "Atualizando sistema..."
sudo pacman -Syu --noconfirm
print_success "Sistema atualizado"

#############################################################################
# 2. INSTALAR DEPENDÊNCIAS
#############################################################################
print_header "Instalando dependências essenciais..."
sudo pacman -S --needed --noconfirm \
    gnome-shell \
    gnome-control-center \
    gnome-tweaks \
    dconf-editor \
    git \
    wget \
    curl \
    base-devel

print_success "Dependências instaladas"

#############################################################################
# 3. INSTALAR TEMAS
#############################################################################
print_header "Instalando temas visuais..."

THEMES_DIR="$HOME/.themes"
mkdir -p "$THEMES_DIR"

# Tema Orchis (moderno e bonito)
if [ ! -d "$THEMES_DIR/Orchis" ]; then
    print_warning "Instalando tema Orchis..."
    cd /tmp
    rm -rf Orchis-theme
    git clone https://github.com/vinceliuice/Orchis-theme.git
    cd Orchis-theme
    ./install.sh -d "$THEMES_DIR" -c compact  # Remove '-t light' se não for necessário
    cd - > /dev/null
    print_success "Tema Orchis instalado"
else
    print_success "Tema Orchis já existe"
fi

# Tema Dracula (alternativa escura)
if [ ! -d "$THEMES_DIR/Dracula" ]; then
    print_warning "Instalando tema Dracula..."
    cd /tmp
    rm -rf dracula-gtk
    git clone https://github.com/dracula/gtk.git dracula-gtk
    cp -r dracula-gtk/Dracula* "$THEMES_DIR/"
    rm -rf dracula-gtk
    print_success "Tema Dracula instalado"
else
    print_success "Tema Dracula já existe"
fi

#############################################################################
# 4. INSTALAR ÍCONES
#############################################################################
print_header "Instalando pacotes de ícones..."

ICONS_DIR="$HOME/.local/share/icons"
mkdir -p "$ICONS_DIR"

# Papirus Icons
if [ ! -d "$ICONS_DIR/Papirus" ]; then
    print_warning "Instalando ícones Papirus..."
    cd /tmp
    rm -rf papirus-icon-theme
    git clone https://github.com/PapirusDev/papirus-icon-theme.git
    cd papirus-icon-theme
    ./install.sh -d "$ICONS_DIR"
    cd - > /dev/null
    print_success "Ícones Papirus instalados"
else
    print_success "Ícones Papirus já existem"
fi

#############################################################################
# 5. INSTALAR FONTES
#############################################################################
print_header "Instalando fontes..."
sudo pacman -S --needed --noconfirm \
    ttf-roboto \
    ttf-roboto-mono \
    ttf-fira-code \
    noto-fonts \
    noto-fonts-emoji

mkdir -p "$HOME/.local/share/fonts"
print_success "Fontes instaladas"

#############################################################################
# 6. APLICAR CONFIGURAÇÕES DE TEMA
#############################################################################
print_header "Aplicando configurações visuais..."

# Configurações base do GNOME
dconf write /org/gnome/desktop/interface/gtk-theme "'Orchis-Light-Compact'"
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus'"
dconf write /org/gnome/desktop/interface/font-name "'Roboto 11'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'Fira Code 10'"
dconf write /org/gnome/desktop/interface/document-font-name "'Roboto 11'"

# Variante escura para aplicações
dconf write /org/gnome/desktop/interface/prefer-dark-style false

# Button Layout (padrão GTK moderno)
dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,maximize,close'"

print_success "Tema aplicado"

#############################################################################
# 7. INSTALAR EXTENSÕES DO GNOME
#############################################################################
print_header "Instalando extensões do GNOME..."

EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$EXTENSIONS_DIR"

install_gnome_extension() {
    local ext_name=$1
    local ext_uuid=$2
    local ext_url=$3
    
    if [ ! -d "$EXTENSIONS_DIR/$ext_uuid" ]; then
        print_warning "Instalando $ext_name..."
        cd /tmp
        rm -rf "$ext_uuid.zip"
        wget -q "$ext_url" -O "$ext_uuid.zip"
        unzip -q "$ext_uuid.zip" -d "$EXTENSIONS_DIR/$ext_uuid"
        rm "$ext_uuid.zip"
        print_success "$ext_name instalada"
    else
        print_success "$ext_name já existe"
    fi
}

# Dash to Dock - dock customizável
install_gnome_extension "Dash to Dock" "dash-to-dock@micxjo.github.com" \
    "https://github.com/micxjo/dash-to-dock/releases/download/v86/dash-to-dock@micxjo.github.com.zip"

# User Themes - permite usar temas customizados
install_gnome_extension "User Themes" "user-theme@gnome-shell-extensions.gcr.iolabs.com" \
    "https://github.com/GNOME/gnome-shell-extensions/releases/download/43.0/user-theme@gnome-shell-extensions.gcr.io.zip"

# Vitals - monitor de CPU, RAM, temperatura
install_gnome_extension "Vitals" "Vitals@CoreCoding.com" \
    "https://github.com/corecoding/Vitals/releases/download/v45/Vitals@CoreCoding.com.zip"

# Just Perfection - customização avançada do shell
install_gnome_extension "Just Perfection" "just-perfection-desktop@just-perfection.com" \
    "https://github.com/JustPerfection-ge/just-perfection-desktop/releases/download/v18/just-perfection-desktop@just-perfection.com.zip"

# Blur My Shell - efeito de blur bonito
install_gnome_extension "Blur My Shell" "blur-my-shell@aunetx" \
    "https://github.com/aunetx/blur-my-shell/releases/download/v68/blur-my-shell@aunetx.zip"

# Extension List - gerenciar extensões
install_gnome_extension "Extension List" "extension-list@feoresm.github.com" \
    "https://github.com/feoresm/gnome-shell-extension-list/releases/download/v12/extension-list@feoresm.github.com.zip"

print_success "Extensões instaladas"

#############################################################################
# 8. CONFIGURAR EXTENSÕES
#############################################################################
print_header "Configurando extensões..."

# Dash to Dock
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/autohide true
dconf write /org/gnome/shell/extensions/dash-to-dock/icon-size-fixed false
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 48
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'FIXED'"
dconf write /org/gnome/shell/extensions/dash-to-dock/background-opacity 0.6

# Blur My Shell
dconf write /org/gnome/shell/extensions/blur-my-shell/blur-brightness 0.6
dconf write /org/gnome/shell/extensions/blur-my-shell/blur-sigma 20

# Just Perfection
dconf write /org/gnome/shell/extensions/just-perfection/animation 1
dconf write /org/gnome/shell/extensions/just-perfection/startup-status 1

print_success "Extensões configuradas"

#############################################################################
# 9. OTIMIZAÇÕES DE PERFORMANCE
#############################################################################
print_header "Aplicando otimizações de performance..."

# Desabilitar animações pesadas em sessões remotas
dconf write /org/gnome/desktop/interface/enable-animations true

# Reduzir consumo de memória do daemon
dconf write /org/gnome/shell/disable-extension-update-notification true

# Mover arquivos antigos da lixeira
dconf write /org/gnome/desktop/privacy/remove-old-trash-files true
dconf write /org/gnome/desktop/privacy/old-files-age "uint32 30"

# Manter histórico de clipboard menor
dconf write /org/gnome/shell/extensions/clipboard-indicator/history-size 50

# Otimizar comportamento de pausa na tela
dconf write /org/gnome/desktop/session/idle-delay "uint32 900"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout 900

print_success "Otimizações aplicadas"

#############################################################################
# 10. CONFIGURAÇÕES DE TECLADO E MOUSE
#############################################################################
print_header "Configurando entrada (teclado e mouse)..."

# Repetição de tecla mais rápida
dconf write /org/gnome/desktop/peripherals/keyboard/delay "uint32 200"
dconf write /org/gnome/desktop/peripherals/keyboard/repeat-interval "uint32 25"

# Mouse
dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'default'"

print_success "Entrada configurada"

#############################################################################
# 11. CRIAR SCRIPT DE CONFIGURAÇÃO FUTURA
#############################################################################
print_header "Criando script de backup de configurações..."

cat > "$HOME/.gnome-backup-restore.sh" << 'EOF'
#!/bin/bash

# Script para backup/restore de configurações do GNOME

if [ "$1" = "backup" ]; then
    dconf dump /org/gnome/ > "$HOME/.config/dconf-backup.txt"
    echo "✓ Backup de configurações salvo em ~/.config/dconf-backup.txt"
elif [ "$1" = "restore" ]; then
    if [ -f "$HOME/.config/dconf-backup.txt" ]; then
        dconf load /org/gnome/ < "$HOME/.config/dconf-backup.txt"
        echo "✓ Configurações restauradas"
    else
        echo "✗ Arquivo de backup não encontrado"
    fi
else
    echo "Uso: $0 [backup|restore]"
fi
EOF

chmod +x "$HOME/.gnome-backup-restore.sh"
print_success "Script de backup criado em ~/.gnome-backup-restore.sh"

#############################################################################
# 12. INFORMAÇÕES FINAIS
#############################################################################
print_header "Próximos passos"

echo -e "${YELLOW}1. REINICIAR O GNOME:${NC}"
echo "   Alt+F2 → r → Enter"
echo "   (ou simplesmente desconecte e conecte novamente)"

echo -e "\n${YELLOW}2. HABILITAR EXTENSÕES:${NC}"
echo "   - Abra 'Extensions' no Activities"
echo "   - Ative as extensões instaladas"

echo -e "\n${YELLOW}3. CUSTOMIZAÇÕES ADICIONAIS:${NC}"
echo "   - Abra 'GNOME Tweaks' para ajustes finos"
echo "   - Acesse 'dconf Editor' para configs avançadas"

echo -e "\n${YELLOW}4. TEMAS ALTERNATIVOS DISPONÍVEIS:${NC}"
echo "   - Orchis (Light/Dark Compact) - atual"
echo "   - Dracula"
echo "   - Para mudar: Tweaks → Appearance"

echo -e "\n${YELLOW}5. ÍCONES ALTERNATIVOS:${NC}"
echo "   - Papirus (atual)"
echo "   - Para mudar: Tweaks → Appearance"

echo -e "\n${YELLOW}6. BACKUP DE CONFIGURAÇÕES:${NC}"
echo "   ~/.gnome-backup-restore.sh backup  # para salvar"
echo "   ~/.gnome-backup-restore.sh restore # para restaurar"

echo -e "\n${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Otimização concluída com sucesso!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}\n"
