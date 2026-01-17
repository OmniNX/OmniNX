# OmniNX CFW Pack

A comprehensive custom firmware pack for the Nintendo Switch, available in three variants: Standard, Light, and OC (Overclock).

## Variants

- **Standard**: Full-featured pack with all standard tools and applications
- **Light**: Minimal pack with essential tools only
- **OC**: Full pack with overclocking support and SaltySD integration

## Repository Structure

```
OmniNX/
├── staging/          # Shared install-stage files (bootloader, payloads, etc.)
├── standard/         # Standard variant content
├── light/            # Light variant content
├── oc/               # OC variant content
└── scripts/          # Build scripts
```

## Repository Setup

This repository uses **Git LFS (Large File Storage)** to manage binary files efficiently. Without LFS, the repository would be very large (~676MB) and would grow significantly with each update.

### Git LFS Quota Considerations

**GitHub Git LFS Limits:**
- **Free accounts**: 1 GB storage, 1 GB/month bandwidth
- **Paid accounts**: 50 GB storage, 50 GB/month bandwidth

**Important Notes:**
- Git LFS only stores **unique file content** - if you update a binary, it only stores the new version if it's different
- However, old versions remain in LFS history, so storage can accumulate over time
- With ~326MB of binaries that may update every few weeks, you may need a paid GitHub account for long-term use

**Strategies to Manage Quota:**
1. **Selective LFS**: Only use LFS for large, rarely-changing files (see `.gitattributes`)
2. **Exclude frequently-updating binaries**: Consider excluding `.nro` and `.nsp` files from LFS if they update often
3. **Regular cleanup**: Periodically create fresh releases and archive old versions
4. **Alternative storage**: For frequently-changing files, consider hosting them separately and referencing URLs in the repo

### Initial Setup (Required)

Before cloning or working with this repository, ensure Git LFS is installed:

```bash
# Install Git LFS (if not already installed)
# macOS:
brew install git-lfs

# Linux:
# Follow instructions at https://git-lfs.github.com/

# Initialize Git LFS in your repository
git lfs install
```

### Cloning the Repository

When cloning, Git LFS will automatically download the binary files:

```bash
git clone <repository-url>
cd OmniNX
```

If you've already cloned without LFS, run:
```bash
git lfs install
git lfs pull
```

## Building Packs

### Prerequisites

- Bash shell
- `zip` command-line tool
- Git LFS (for repository management)

### Build Single Variant

```bash
./scripts/build-pack.sh [standard|light|oc] [version]
```

Example:
```bash
./scripts/build-pack.sh standard 1.0.0
```

### Build All Variants

```bash
./scripts/build-all.sh [version]
```

Example:
```bash
./scripts/build-all.sh 1.0.0
```

The build scripts will:
1. Copy staging files to build directory
2. Copy variant-specific content
3. Update `manifest.ini` with the specified version
4. Create a ZIP archive ready for distribution

## Installation

1. Download the ZIP file for your desired variant
2. Extract the contents to the root of your SD card
3. Boot your Switch with the appropriate payload

## Version Management

Version information is stored in:
- `{variant}/config/omninx/manifest.ini`

The build script automatically updates this file with the specified version during the build process.

## Installer Payload

The OmniNX Installer payload binary is located at:
- `staging/bootloader/payloads/OmniNX-Installer.bin`

This binary is built from a separate repository and should be updated manually when a new installer version is released.

## License

[Add your license information here]

## Credits

[Add credits and acknowledgments here]
