#!/bin/sh

TARGET_PATH="/usr/lib/lua/luci/view/passwall2/node_list/node_list.htm"
UNINSTALLER_PATH="/usr/bin/passwall2-urltest-uninstall"
PAYLOAD_URL="https://raw.githubusercontent.com/WhiteDuke-IOI/luci-passwall2-urltest-patch/main/payload.htm"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Функция очистки хвостов патча и кэша LuCI
cleanup_patch() {
    if [ -f "$TARGET_PATH" ]; then
        # Удаляем все варианты нашего инжектированного блока (по первичному совпадению начального и конечного тегов)
        sed -i '/<!-- INJECTED PASSWALL2 URL-TEST PATCH/,/<!-- END OF INJECTED PATCH -->/d' "$TARGET_PATH"
        rm -f "${TARGET_PATH}.bak"
    fi
    # Полный сброс кэшей интерфейса LuCI
    rm -rf /tmp/luci-indexcache /tmp/luci-modulecache /tmp/luci-sessions/* 2>/dev/null
}

# =================================================
#  УДАЛЕНИЕ ПАТЧА (UNINSTALL BLOCK)
# =================================================
if [ "$1" = "uninstall" ]; then
    echo -e "${YELLOW}Initiating PassWall2 URL-Test Patch Uninstallation...${NC}"
    
    cleanup_patch
    rm -f "$UNINSTALLER_PATH"
    
    echo -e "${GREEN}=================================================${NC}"
    echo -e "${GREEN} Patch successfully removed!${NC}"
    echo -e " LuCI cache cleared. Native files restored."
    echo -e " Please refresh your browser (Ctrl + F5 / Cmd + R)."
    echo -e "${GREEN}=================================================${NC}"
    exit 0
fi

# =================================================
#  УСТАНОВКА ПАТЧА (INSTALL BLOCK)
# =================================================
echo "Checking system compatibility..."

if [ ! -f "$TARGET_PATH" ]; then
    echo -e "${RED}Error: Target PassWall2 file not found at:${NC}"
    echo -e "       $TARGET_PATH"
    echo -e "${RED}Please check if PassWall2 is installed.${NC}"
    exit 1
fi

echo "Cleaning up any old patch traces..."
cleanup_patch

echo "Downloading latest Universal Smart Payload..."
wget --no-check-certificate -T 20 -qO /tmp/payload.htm "$PAYLOAD_URL"

if [ $? -eq 0 ] && [ -s "/tmp/payload.htm" ]; then
    echo "Injecting payload into $TARGET_PATH..."
    cat /tmp/payload.htm >> "$TARGET_PATH"
    rm -f /tmp/payload.htm
else
    echo -e "${RED}Download failed or payload is empty! No changes were made.${NC}"
    exit 1
fi

# Очищаем кэш после внедрения
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache 2>/dev/null

# Генерация оффлайн-деинсталлятора
cat << 'EOF' > "$UNINSTALLER_PATH"
#!/bin/sh
TARGET_PATH="/usr/lib/lua/luci/view/passwall2/node_list/node_list.htm"
UNINSTALLER_PATH="/usr/bin/passwall2-urltest-uninstall"

if [ -f "$TARGET_PATH" ]; then
    sed -i '/<!-- INJECTED PASSWALL2 URL-TEST PATCH/,/<!-- END OF INJECTED PATCH -->/d' "$TARGET_PATH"
    rm -f "${TARGET_PATH}.bak"
    rm -rf /tmp/luci-indexcache /tmp/luci-modulecache /tmp/luci-sessions/* 2>/dev/null
    rm -f "$UNINSTALLER_PATH"
    echo -e "\033[0;32mPassWall 2 URL-Test Patch removed successfully!\033[0m"
    echo "Please refresh your browser using Ctrl + F5."
else
    echo -e "\033[0;31mError: Target file not found!\033[0m"
fi
EOF

chmod +x "$UNINSTALLER_PATH"

echo "================================================="
echo -e "${GREEN} PassWall 2 Multi-Group Patch Applied Successfully!${NC}"
echo -e " Offline uninstaller ready: ${YELLOW}passwall2-urltest-uninstall${NC}"
echo -e " Please refresh your browser using ${YELLOW}Ctrl + F5${NC} (or Cmd + R)."
echo "================================================="