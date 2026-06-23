# 🎨 GNOME Optimization Scripts para Manjaro

Conjunto completo de scripts para transformar seu GNOME em uma ambiente bonito, funcional e otimizado.

---

## 📋 Conteúdo

- `gnome_optimize.sh` - Script principal de otimização
- `gnome_advanced.sh` - Configurações avançadas e customizações
- `GNOME_SETUP_README.md` - Este arquivo

---

## ⚡ Quick Start

### 1. Permissões de Execução
```bash
chmod +x gnome_optimize.sh
chmod +x gnome_advanced.sh
```

### 2. Executar Script Principal
```bash
./gnome_optimize.sh
```

Este script irá:
- ✅ Atualizar o sistema
- ✅ Instalar dependências essenciais
- ✅ Baixar e instalar temas (Orchis, Dracula)
- ✅ Instalar pacotes de ícones (Papirus)
- ✅ Instalar e configurar extensões do GNOME
- ✅ Aplicar otimizações de performance
- ✅ Configurar teclado e mouse

### 3. Reiniciar GNOME
```bash
# Opção 1: Via atalho
Alt+F2
r
Enter

# Opção 2: Desconectar e reconectar
```

---

## 🎯 Extensões Instaladas

| Extensão | Descrição | Função |
|----------|-----------|--------|
| **Dash to Dock** | Dock customizável | Melhor acesso a aplicativos |
| **User Themes** | Suporte a temas custom | Habilita temas do repositório |
| **Vitals** | Monitor do sistema | CPU, RAM, temperatura em tempo real |
| **Just Perfection** | Customização avançada | Ajustar layout do shell |
| **Blur My Shell** | Efeito de blur | Visual mais moderno |
| **Extension List** | Gerenciador de extensões | Controlar extensões facilmente |

---

## 🎨 Temas e Ícones Instalados

### Temas GTK
- **Orchis Light Compact** (padrão) - Moderno, limpo, minimalista
- **Orchis Dark Compact** - Versão escura do Orchis
- **Dracula** - Dark mode popular, confortável para os olhos

### Ícones
- **Papirus** (padrão) - Pack de ícones moderno e completo

### Fontes
- Roboto (padrão)
- Fira Code (monospace, código)
- Noto Sans/Serif (múltiplos idiomas)

---

## 🛠️ Usando o Script Avançado

```bash
./gnome_advanced.sh
```

Menu interativo com opções:

1. **Dark Mode / Light Mode** - Trocar tema rapidamente
2. **Customizar Dock** - Tamanho, posição, ícones
3. **Efeito Blur** - Intensidade e brilho
4. **Atalhos de Teclado** - Super+D, Super+N, etc
5. **Remover Animações** - Para ganhar performance
6. **Maximizar Animações** - Para melhor visual
7. **Hot Corners** - Ativar/desativar canto ativo
8. **Drivers GPU** - Instalar drivers otimizados
9. **Workspaces** - Configurar espaços de trabalho
10. **Terminal Font** - Fonte customizada no terminal

---

## 📊 Configurações Aplicadas

### Performance
```
- Desabilitar notificações de atualização de extensões
- Remover arquivos antigos da lixeira automaticamente
- Limitar histórico de clipboard
- Otimizar timeout de tela
```

### Visual
```
- Tema elegante e moderno
- Ícones consistentes
- Fontes legíveis
- Blur effect nas janelas
- Dock com auto-hide
```

### Teclado/Mouse
```
- Repetição de tecla otimizada
- Aceleração de mouse ajustada
- Atalhos de teclado úteis habilitados
```

---

## 💾 Backup de Configurações

O script cria automaticamente `~/.gnome-backup-restore.sh` para salvar/restaurar configs:

```bash
# Salvar configurações atuais
~/.gnome-backup-restore.sh backup

# Restaurar de backup anterior
~/.gnome-backup-restore.sh restore
```

---

## 🔧 Customizações Manuais Úteis

### Acessar dconf-editor (configurações avançadas)
```bash
dconf-editor
```

Caminho útil: `/org/gnome/shell/extensions/`

### Usar GNOME Tweaks
```bash
gnome-tweaks
```

Áreas úteis:
- Appearance → Tema, Ícones, Fonte
- Top Bar → Mostrar/ocultar elementos
- Workspaces → Comportamento de workspaces

---

## 🚀 Dicas de Otimização

### Se o sistema está lento:
1. Desativar animações: `./gnome_advanced.sh` → opção 6
2. Desativar blur: `dconf write /org/gnome/shell/extensions/blur-my-shell/blur-sigma 0`
3. Reduzir tamanho do histórico do clipboard

### Para melhor visual:
1. Habilitar animações: `./gnome_advanced.sh` → opção 7
2. Aumentar blur sigma (20-30)
3. Usar tema Dark com blur

### Para melhor produtividade:
1. Configurar 4 workspaces: `./gnome_advanced.sh` → opção 10
2. Habilitar hot corners para overview
3. Configurar atalhos de teclado úteis

---

## 🐛 Troubleshooting

### Extensões não aparecem
```bash
# Reiniciar GNOME Shell
Alt+F2 → r → Enter

# Ou recarregar extensões
gnome-shell --replace &
```

### Tema não aplicado
```bash
# Resetar dconf do GNOME
dconf reset -f /org/gnome/desktop/interface/

# Depois re-aplicar temas manualmente no dconf-editor
```

### Terminal piscando ou lento
```bash
# Desabilitar VSCode/aplicativo de aceleração GPU
gsettings set org.gnome.settings-daemon.plugins.wayland.wacom collect-device true
```

---

## 📝 Desinstalação Segura

Se quiser reverter para o padrão:

```bash
# Remover temas customizados
rm -rf ~/.themes

# Remover ícones customizados
rm -rf ~/.local/share/icons/Papirus*

# Remover extensões
rm -rf ~/.local/share/gnome-shell/extensions/

# Resetar dconf
dconf reset -f /org/gnome/

# Reinstalar tema padrão do Manjaro
pacman -S gnome
```

---

## 🎓 Recursos Úteis

- **GNOME Shell Extensions**: https://extensions.gnome.org
- **Temas GTK**: https://www.gnome-look.org
- **Ícones**: https://www.pling.com/browse/cat/132/
- **Documentação dconf**: https://access.redhat.com/articles/3359321

---

## 📌 Notas Importantes

⚠️ **Antes de usar os scripts:**
- Fazer backup importante
- Ter acesso à internet
- Acesso sudo/root

⚠️ **Compatibilidade:**
- Testado em Manjaro com GNOME 43+
- Pode funcionar em Arch, Fedora, Ubuntu (com ajustes)
- Não compatível com Wayland em algumas extensões (use X11)

---

## 🤝 Problemas?

Se encontrar problemas:

1. Verifique se GNOME está atualizado: `sudo pacman -Syu`
2. Reinicie GNOME: `Alt+F2 → r → Enter`
3. Verifique logs: `journalctl -xe`
4. Resete uma extensão problemática no dconf-editor

---

**Versão**: 1.0  
**Última atualização**: 2024  
**Testado em**: Manjaro GNOME 43+

Aproveite seu novo GNOME! 🎨✨
