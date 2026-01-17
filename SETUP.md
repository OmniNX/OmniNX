# Setting Up OmniNX Repository on GitHub with Git LFS

## Step-by-Step Instructions

### 1. Initialize Git Repository

```bash
cd /Users/niklasfriesen/Desktop/Omni/OmniNX
git init
```

### 2. Initialize Git LFS

```bash
git lfs install
```

### 3. Add .gitattributes First (Important!)

The `.gitattributes` file must be committed BEFORE adding binary files, so Git LFS knows which files to track:

```bash
git add .gitattributes
git commit -m "Add Git LFS configuration"
```

### 4. Add All Files

```bash
git add .
```

This will automatically use Git LFS for files matching patterns in `.gitattributes`.

### 5. Verify LFS Tracking

Check which files are being tracked by LFS:

```bash
git lfs ls-files
```

You should see binary files listed (`.bin`, `.kip`, `.bmp`, etc.).

### 6. Create Initial Commit

```bash
git commit -m "Initial commit: OmniNX CFW Pack repository"
```

### 7. Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., `OmniNX`)
3. **Do NOT** initialize with README, .gitignore, or license (we already have these)
4. Copy the repository URL

### 8. Add Remote and Push

```bash
# Replace <your-username> and <repo-name> with your actual values
git remote add origin https://github.com/<your-username>/<repo-name>.git

# Push to GitHub (this will upload LFS files)
git push -u origin main
```

If your default branch is `master` instead of `main`:
```bash
git branch -M main
git push -u origin main
```

### 9. Verify LFS Files on GitHub

After pushing:
1. Go to your repository on GitHub
2. Check that binary files show "Stored with Git LFS" badge
3. Verify file sizes are reasonable (not the full binary size in Git history)

## Troubleshooting

### If LFS files aren't being tracked:

```bash
# Re-track files
git lfs migrate import --include="*.bin,*.kip,*.kipm,*.bso,*.romfs,*.pak,*.bmp" --everything
```

### If you need to check LFS quota:

GitHub doesn't show this in the web UI easily, but you can check via:
- Repository Settings → Billing (if you have access)
- Or use GitHub API: `curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user`

### If push fails due to LFS quota:

You may need to:
1. Upgrade to GitHub Pro ($4/month) for 50GB LFS storage
2. Or reduce what's tracked in LFS (edit `.gitattributes`)

## Important Notes

- **Always commit `.gitattributes` first** before adding binary files
- Git LFS files are uploaded separately from regular Git commits
- The first push may take longer due to LFS file uploads
- GitHub free accounts have 1GB LFS storage limit
