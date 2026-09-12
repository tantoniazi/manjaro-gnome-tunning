#!/bin/bash

#############################################################################
# GNOME Advanced Configuration Script
# Customizações adicionais e tweaks avançados
#############################################################################

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      GNOME Advanced Configuration for Manjaro             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"

#############################################################################
# MENU DE SELEÇÃO
#############################################################################

show_menu() {
    echo -e "${YELLOW}Escolha uma customização:${NC}\n"
    echo "1) Aplicar Tema Dark Mode (Dracula)"
    echo "2) Aplicar Tema Light Mode (Orchis Light)"
    echo "3) Customizar Dock (Dash to Dock)"
    echo "4) Ativar Efeito Blur avançado"
    echo "5) Configurar Atalhos de Teclado"
    echo "6) Remover Animações (performance)"
    echo "7) Maximizar Animações (visual)"
    echo "8) Configurar Corner Activities (Ativo/Inativo)"
    echo "9) Instalar Drivers GPU otimizados"
    echo "10) Criar Workspace Customizado"
    echo "11) Configurar Fonte Monospace para Terminal"
    echo "12) Ver Status das Extensões"
    echo "0) Sair"
    echo -e "\n${YELLOW}Digite o número da opção:${NC} "
}

#############################################################################
# FUNÇÃO PARA CADA OPÇÃO
#############################################################################

apply_dark_mode() {
    print_header "Aplicando Dark Mode (Dracula)..."
    dconf write /org/gnome/desktop/interface/gtk-theme "'Dracula'"
    dconf write /org/gnome/desktop/interface/prefer-dark-style true
    dconf write /org/gnome/desktop/wm/preferences/theme "'Dracula'"
    print_success "Dark Mode aplicado"
}

apply_light_mode() {
    print_header "Aplicando Light Mode (Orchis)..."
    dconf write /org/gnome/desktop/interface/gtk-theme "'Orchis-Light-Compact'"
    dconf write /org/gnome/desktop/interface/prefer-dark-style false
    dconf write /org/gnome/desktop/wm/preferences/theme "'Orchis-Light-Compact'"
    print_success "Light Mode aplicado"
}

customize_dock() {
    echo -e "\n${YELLOW}Customização do Dock:${NC}\n"
    echo "1) Tamanho pequeno (32px)"
    echo "2) Tamanho médio (48px)"
    echo "3) Tamanho grande (64px)"
    echo "4) Posição: Bottom"
    echo "5) Posição: Left"
    echo "6) Mostrar Trash no Dock"
    echo "7) Ocultar Trash no Dock"
    read -p "Escolha (1-7): " choice
    
    case $choice in
        1) dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 32 ;;
        2) dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 48 ;;
        3) dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 64 ;;
        4) dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'" ;;
        5) dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'LEFT'" ;;
        6) dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash true ;;
        7) dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash false ;;
    esac
    print_success "Dock customizado"
}

configure_blur() {
    print_header "Configurando Blur avançado..."
    echo -e "\n${YELLOW}Intensidade do Blur (0-100):${NC} "
    read blur_sigma
    dconf write /org/gnome/shell/extensions/blur-my-shell/blur-sigma $blur_sigma
    
    echo -e "${YELLOW}Brilho do Blur (0-1):${NC} "
    read blur_bright
    dconf write /org/gnome/shell/extensions/blur-my-shell/blur-brightness $blur_bright
    
    print_success "Blur configurado"
}

configure_shortcuts() {
    print_header "Atalhos de Teclado do GNOME..."
    echo -e "\nAlguns atalhos úteis configuráveis:\n"
    echo "Super+D → Mostrar Desktop"
    echo "Super+N → Novo Workspace"
    echo "Super+A → Application Grid"
    echo "Ctrl+Alt+T → Terminal (se instalado)"
    echo -e "\nPara customizar em detalhes:"
    echo "1) Abra 'Settings' → 'Keyboard Shortcuts'"
    echo "2) Ou use dconf-editor para editar /org/gnome/desktop/wm/keybindings"
    
    # Habilitar Super+D para mostrar desktop
    dconf write /org/gnome/desktop/wm/keybindings/show-desktop "['<Super>d']"
    print_success "Atalho Super+D para Desktop habilitado"
}

remove_animations() {
    print_header "Removendo animações (performance)..."
    dconf write /org/gnome/desktop/interface/enable-animations false
    dconf write /org/gnome/shell/extensions/blur-my-shell/hacks-level 0
    print_success "Animações desabilitadas"
}

maximize_animations() {
    print_header "Maximizando animações (visual)..."
    dconf write /org/gnome/desktop/interface/enable-animations true
    dconf write /org/gnome/shell/extensions/blur-my-shell/hacks-level 2
    dconf write /org/gnome/desktop/wm/preferences/action-middle-click-titlebar "'toggle-maximize'"
    print_success "Animações habilitadas ao máximo"
}

configure_corner_activities() {
    print_header "Configurando Corner Activities..."
    echo -e "\n${YELLOW}Hot Corner no canto superior esquerdo?${NC}\n"
    echo "1) Ativar"
    echo "2) Desativar"
    read -p "Escolha (1-2): " choice
    
    if [ "$choice" = "1" ]; then
        dconf write /org/gnome/shell/enable-hot-corners true
        print_success "Hot Corner ativado"
    else
        dconf write /org/gnome/shell/enable-hot-corners false
        print_success "Hot Corner desativado"
    fi
}

install_gpu_drivers() {
    print_header "Drivers de GPU..."
    echo -e "\n${YELLOW}Qual GPU você tem?${NC}\n"
    echo "1) NVIDIA (proprietary drivers)"
    echo "2) Intel (drivers open-source)"
    echo "3) AMD (drivers open-source)"
    read -p "Escolha (1-3): " choice
    
    case $choice in
        1)
            print_header "Instalando drivers NVIDIA..."
            sudo pacman -S --needed --noconfirm nvidia nvidia-utils lib32-nvidia-utils
            print_success "Drivers NVIDIA instalados"
            ;;
        2)
            print_header "Intel GPU já tem suporte nativo"
            sudo pacman -S --needed --noconfirm intel-media-driver
            print_success "Intel Media Driver instalado"
            ;;
        3)
            print_header "Instalando drivers AMD..."
            sudo pacman -S --needed --noconfirm xf86-video-amdgpu mesa lib32-mesa
            print_success "Drivers AMD instalados"
            ;;
    esac
}

create_workspace_layout() {
    print_header "Configurando Workspaces..."
    
    echo -e "\n${YELLOW}Número de Workspaces:${NC} "
    read num_workspaces
    
    # Configurar número de workspaces
    dconf write /org/gnome/desktop/wm/preferences/num-workspaces $num_workspaces
    
    # Habilitar workspace switching com mouse wheel
    dconf write /org/gnome/shell/extensions/just-perfection/workspace-switcher-should-show true
    
    print_success "Workspaces configurados para $num_workspaces"
}

configure_terminal_font() {
    print_header "Configurando fonte do Terminal..."
    
    if command -v gsettings &> /dev/null; then
        echo -e "\n${YELLOW}Fontes monospace disponíveis:${NC}\n"
        echo "1) Fira Code 11"
        echo "2) Monospace 12"
        echo "3) Source Code Pro 11"
        read -p "Escolha (1-3): " choice
        
        case $choice in
            1)
                gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:b1d06811-41ff-46d3-82eb-812994e9717d/ font 'Fira Code 11'
                ;;
            2)
                gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:b1d06811-41ff-46d3-82eb-812994e9717d/ font 'Monospace 12'
                ;;
            3)
                sudo pacman -S --needed --noconfirm adobe-source-code-pro-fonts
                gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:b1d06811-41ff-46d3-82eb-812994e9717d/ font 'Source Code Pro 11'
                ;;
        esac
        print_success "Fonte do Terminal configurada"
    fi
}

show_extensions_status() {
    print_header "Status das Extensões Instaladas..."
    
    if command -v gnome-shell &> /dev/null; then
        gnome-extensions list --enabled
        echo -e "\n${GREEN}Extensões habilitadas acima${NC}"
    else
        echo -e "${YELLOW}Abra 'Extensions' no Activities para gerenciar extensões${NC}"
    fi
}

#############################################################################
# LOOP PRINCIPAL
#############################################################################

while true; do
    show_menu
    read -r option
    
    case $option in
        1) apply_dark_mode ;;
        2) apply_light_mode ;;
        3) customize_dock ;;
        4) configure_blur ;;
        5) configure_shortcuts ;;
        6) remove_animations ;;
        7) maximize_animations ;;
        8) configure_corner_activities ;;
        9) install_gpu_drivers ;;
        10) create_workspace_layout ;;
        11) configure_terminal_font ;;
        12) show_extensions_status ;;
        0) 
            print_header "Saindo..."
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Opção inválida. Tente novamente.${NC}"
            ;;
    esac
done
