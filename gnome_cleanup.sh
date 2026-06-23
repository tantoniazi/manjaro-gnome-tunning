#!/bin/bash

#############################################################################
# GNOME Cleanup & Uninstall Script
# Remove customizações, extensões e restaura configurações padrão
#############################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║    GNOME Cleanup & Uninstall Script                        ║${NC}"
echo -e "${RED}║    ⚠️  Este script irá remover customizações               ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}\n"

print_header() {
    echo -e "\n${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Confirmação de segurança
echo -e "${RED}ATENÇÃO: Este script irá:${NC}"
echo "  1. Remover todos os temas customizados"
echo "  2. Remover ícones customizados"
echo "  3. Remover extensões do GNOME Shell"
echo "  4. Resetar configurações do GNOME"
echo "  5. Reinstalar pacotes padrão do GNOME"
echo ""
echo -e "${RED}Você pode restaurar do backup antes se tiver feito:${NC}"
echo "  ~/.gnome-backup-restore.sh restore"
echo ""

read -p "Tem certeza que deseja continuar? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    print_error "Operação cancelada"
    exit 1
fi

read -p "Digite 'REMOVER TUDO' para confirmar irreversivelmente: " confirm
if [ "$confirm" != "REMOVER TUDO" ]; then
    print_error "Confirmação incorreta. Operação cancelada"
    exit 1
fi

#############################################################################
# LIMPEZA
#############################################################################

print_header "Iniciando limpeza..."

# 1. Remover diretórios de customizações
print_header "Removendo temas customizados..."
if [ -d "$HOME/.themes" ]; then
    rm -rf "$HOME/.themes"
    print_success "Temas removidos"
fi

# 2. Remover ícones
print_header "Removendo pacotes de ícones..."
if [ -d "$HOME/.local/share/icons" ]; then
    rm -rf "$HOME/.local/share/icons"
    mkdir -p "$HOME/.local/share/icons"
    print_success "Ícones removidos"
fi

# 3. Remover extensões
print_header "Removendo extensões do GNOME Shell..."
if [ -d "$HOME/.local/share/gnome-shell/extensions" ]; then
    rm -rf "$HOME/.local/share/gnome-shell/extensions"/*
    print_success "Extensões removidas"
fi

# 4. Resetar dconf
print_header "Resetando configurações do GNOME..."
echo -e "${YELLOW}Fazendo reset de todas as configurações GNOME...${NC}"
dconf reset -f /org/gnome/
print_success "Configurações resetadas"

# 5. Remover pacotes customizados (opcional)
print_header "Limpando pacotes instalados..."
read -p "Remover temas e ícones do pacman também? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "${YELLOW}Procurando por pacotes de temas/ícones...${NC}"
    
    THEME_PACKAGES=$(pacman -Qs "orchis\|dracula\|papirus" | cut -d' ' -f1 | cut -d'/' -f2)
    
    if [ -n "$THEME_PACKAGES" ]; then
        echo -e "${YELLOW}Pacotes encontrados:${NC}"
        echo "$THEME_PACKAGES"
        read -p "Desinstalar estes pacotes? (s/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            sudo pacman -R --noconfirm $THEME_PACKAGES
            print_success "Pacotes desinstalados"
        fi
    else
        print_warning "Nenhum pacote encontrado"
    fi
fi

#############################################################################
# REMOVER FONTES INSTALADAS (opcional)
#############################################################################
read -p "Remover fontes customizadas também? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    print_header "Removendo fontes..."
    rm -rf "$HOME/.local/share/fonts"/*
    sudo pacman -R --noconfirm ttf-roboto ttf-roboto-mono ttf-fira-code 2>/dev/null || true
    print_success "Fontes removidas"
fi

#############################################################################
# REINSTALAR GNOME PADRÃO
#############################################################################
print_header "Reinstalando GNOME padrão do Manjaro..."
sudo pacman -S --needed --noconfirm gnome-shell gnome-control-center
print_success "GNOME reinstalado"

#############################################################################
# LIMPEZA DO SISTEMA
#############################################################################
print_header "Limpando cache do pacman..."
sudo pacman -Sc --noconfirm
sudo pacman -Scc --noconfirm
print_success "Cache limpo"

#############################################################################
# REMOVER SCRIPTS (opcional)
#############################################################################
print_header "Removendo scripts de otimização?"
read -p "Remover gnome_optimize.sh e gnome_advanced.sh? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    rm -f "$HOME/gnome_optimize.sh"
    rm -f "$HOME/gnome_advanced.sh"
    rm -f "$HOME/gnome_cleanup.sh"
    rm -f "$HOME/GNOME_SETUP_README.md"
    rm -f "$HOME/.gnome-backup-restore.sh"
    print_success "Scripts removidos"
fi

#############################################################################
# RESUMO FINAL
#############################################################################
echo -e "\n${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Limpeza concluída!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Reiniciar GNOME:"
echo "   Alt+F2 → r → Enter"
echo ""
echo "2. Ou desconectar e conectar novamente"
echo ""
echo "3. GNOME voltará ao padrão do Manjaro"
echo ""

print_warning "Se quiser restaurar de um backup anterior:"
echo "  ~/.gnome-backup-restore.sh restore"
echo ""
echo -e "${YELLOW}Se tudo deu errado, reinstale o Manjaro com:${NC}"
echo "  sudo pacman -S manjaro-gnome-defaults-settings"
