# Repository Setup Checklist

## Initial Setup

### 1. Rename Template
- [x] Update `finpilot` to `cypher` in: Containerfile, Justfile, README.md, artifacthub-repo.yml, custom/ujust/README.md, .github/workflows/clean.yml
- [x] Add "What Makes Cypher Different" section to README.md

### 2. Enable GitHub Actions
- [ ] Go to the repository "Actions" tab on GitHub
- [ ] Click "I understand my workflows, go ahead and enable them"
- [ ] Actions will automatically start building the image

**Note**: This step must be done manually through the GitHub web interface.

### 3. First Build
Once Actions are enabled, the first build will start automatically. You can monitor it in the Actions tab.

The build will:
- Build the container image
- Push to GitHub Container Registry (ghcr.io)
- Create tags: `:stable`, `:stable.YYYYMMDD`, `:YYYYMMDD`

### 4. Deploy (After Build Completes)
```bash
sudo bootc switch --transport registry ghcr.io/wipos/cypher:stable
sudo systemctl reboot
```

## Optional: Production Features

### Enable Signing (Recommended)
```bash
cosign generate-key-pair
# Add cosign.key content to GitHub Secrets as SIGNING_SECRET
# Settings → Secrets and variables → Actions → New repository secret
# Name: SIGNING_SECRET
# Value: <paste entire contents of cosign.key>
# Then uncomment signing steps in .github/workflows/build.yml
```

### Enable SBOM Generation (Recommended)
After enabling signing, uncomment SBOM steps in .github/workflows/build.yml

## Repository Information

- **Repository**: wipos/cypher
- **Image Registry**: ghcr.io/wipos/cypher
- **Base Image**: Fedora Silverblue with GNOME
- **Build Frequency**: On every push to main, daily at 10:05 UTC
- **Renovate**: Runs every 6 hours to update dependencies
- **Image Cleanup**: Deletes images older than 90 days (weekly)

