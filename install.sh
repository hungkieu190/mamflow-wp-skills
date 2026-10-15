#!/usr/bin/env bash
# ==============================================================================
# MAMFLOW WordPress Master Squad - Auto Installer
# Repository: https://github.com/hungkieu190/mamflow-wp-skills
# ==============================================================================

set -e

REPO_URL="https://github.com/hungkieu190/mamflow-wp-skills.git"
RAW_BASE="https://raw.githubusercontent.com/hungkieu190/mamflow-wp-skills/main"

COLOR_GREEN="\033[0;32m"
COLOR_BLUE="\033[0;34m"
COLOR_YELLOW="\033[1;33m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_BLUE}======================================================${COLOR_RESET}"
echo -e "${COLOR_GREEN}  🚀 MAMFLOW WordPress Master Squad Installer         ${COLOR_RESET}"
echo -e "${COLOR_BLUE}======================================================${COLOR_RESET}"

TARGET_DIR=".agents/skills"
IS_GLOBAL=false

for arg in "$@"; do
    case "$arg" in
        --global|-g)
            TARGET_DIR="${HOME}/.gemini/config/skills"
            IS_GLOBAL=true
            shift
            ;;
        --project|-p)
            TARGET_DIR=".agents/skills"
            IS_GLOBAL=false
            shift
            ;;
    esac
done

echo -e "📍 Target destination: ${COLOR_YELLOW}${TARGET_DIR}${COLOR_RESET}"
mkdir -p "${TARGET_DIR}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo -e "📦 Fetching skills from GitHub..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null || {
    echo -e "⚠️ Git clone failed, falling back to manual curl..."
    exit 1
}

# Copy skills
cp -r "$TMP_DIR/skills/"* "$TARGET_DIR/"

# Copy standards and guide to project root if local project
if [ "$IS_GLOBAL" = false ]; then
    cp "$TMP_DIR/WORDPRESS_CODING_STANDARDS.md" ./WORDPRESS_CODING_STANDARDS.md 2>/dev/null || true
    cp "$TMP_DIR/WP_WORKFLOW_GUIDE.md" ./WP_WORKFLOW_GUIDE.md 2>/dev/null || true
fi

echo -e "${COLOR_GREEN}✅ Successfully installed 8 WordPress Master Squad skills into:${COLOR_RESET}"
echo -e "   ${TARGET_DIR}"
echo ""
echo -e "${COLOR_BLUE}Danh sách kỹ năng đã kích hoạt:${COLOR_RESET}"
echo -e "  - agency-wp-cms-developer          (Theme, Plugin, Gutenberg Block)"
echo -e "  - agency-wp-performance-engineer   (Tối ưu Core Web Vitals & Caching)"
echo -e "  - agency-wp-woocommerce-engineer   (E-commerce WooCommerce & Checkout)"
echo -e "  - agency-wp-security-auditor       (Audit bảo mật SQLi, Nonces, Escaping)"
echo -e "  - agency-wp-seo-specialist         (SEO Kỹ thuật, Schema JSON-LD)"
echo -e "  - agency-wp-reality-checker        (Nghiệm thu khắt khe, Error logs, Mobile)"
echo -e "  - agency-wp-product-manager        (Lập PRD, CPT & Content Architecture)"
echo -e "  - agency-wp-agents-orchestrator    (Điều phối quy trình toàn diện)"
echo ""
echo -e "${COLOR_GREEN}🎉 Chúc bạn phát triển dự án WordPress thành công!${COLOR_RESET}"
