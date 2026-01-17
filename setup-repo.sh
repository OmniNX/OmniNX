#!/bin/bash

# Helper script to set up Git repository with LFS
# Usage: ./setup-repo.sh [github-username] [repo-name]

set -e

GITHUB_USER="${1}"
REPO_NAME="${2}"

if [ -z "$GITHUB_USER" ] || [ -z "$REPO_NAME" ]; then
    echo "Usage: ./setup-repo.sh <github-username> <repo-name>"
    echo "Example: ./setup-repo.sh myusername OmniNX"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Setting up OmniNX repository with Git LFS..."
echo ""

# Check if already a git repo
if [ -d ".git" ]; then
    echo "⚠️  Git repository already initialized"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "1. Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
    echo ""
fi

# Check if LFS is installed
if ! command -v git-lfs &> /dev/null; then
    echo "❌ Git LFS is not installed!"
    echo "Install it with: brew install git-lfs"
    exit 1
fi

echo "2. Initializing Git LFS..."
git lfs install
echo "✅ Git LFS initialized"
echo ""

echo "3. Adding .gitattributes (must be first!)..."
git add .gitattributes
if [ -n "$(git status --porcelain .gitattributes)" ]; then
    git commit -m "Add Git LFS configuration"
    echo "✅ .gitattributes committed"
else
    echo "⚠️  .gitattributes already committed or no changes"
fi
echo ""

echo "4. Adding all files..."
git add .
echo "✅ Files added"
echo ""

echo "5. Checking LFS tracking..."
LFS_FILES=$(git lfs ls-files | wc -l | tr -d ' ')
if [ "$LFS_FILES" -gt 0 ]; then
    echo "✅ $LFS_FILES files tracked by Git LFS"
    echo "   Sample files:"
    git lfs ls-files | head -5
else
    echo "⚠️  No files tracked by LFS (this might be normal if no binaries match)"
fi
echo ""

echo "6. Creating initial commit..."
git commit -m "Initial commit: OmniNX CFW Pack repository"
echo "✅ Initial commit created"
echo ""

echo "7. Setting up GitHub remote..."
GITHUB_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Check if remote already exists
if git remote get-url origin &> /dev/null; then
    echo "⚠️  Remote 'origin' already exists: $(git remote get-url origin)"
    read -p "Replace with $GITHUB_URL? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin "$GITHUB_URL"
        echo "✅ Remote updated"
    fi
else
    git remote add origin "$GITHUB_URL"
    echo "✅ Remote added: $GITHUB_URL"
fi
echo ""

echo "========================================="
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Create the repository on GitHub:"
echo "   https://github.com/new"
echo "   Repository name: $REPO_NAME"
echo "   ⚠️  Do NOT initialize with README, .gitignore, or license"
echo ""
echo "2. Push to GitHub:"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "Note: The first push may take a while due to LFS file uploads."
echo "========================================="
