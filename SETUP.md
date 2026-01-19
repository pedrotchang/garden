# Garden Setup Guide

## Cloudflare Pages Deployment

### 1. Create Cloudflare Pages Project

```bash
# Authenticate with Cloudflare
bunx wrangler login

# Create the project (from garden directory)
cd /home/seyza/Repos/github.com/pedrotchang/garden
bun install
bun run quartz build
bunx wrangler pages project create garden

# First deployment
bunx wrangler pages deploy public --project-name=garden
```

### 2. Configure Custom Domain

1. Go to Cloudflare Dashboard → Pages → garden
2. Custom domains → Add custom domain
3. Enter: `garden.pedrotchang.dev`
4. Cloudflare will automatically configure DNS

### 3. GitHub Actions Secrets (for CI/CD)

Add these secrets to the garden repo (Settings → Secrets → Actions):

| Secret | Description |
|--------|-------------|
| `CLOUDFLARE_API_TOKEN` | Create at [API Tokens](https://dash.cloudflare.com/profile/api-tokens) with "Cloudflare Pages:Edit" permission |
| `CLOUDFLARE_ACCOUNT_ID` | Found in Cloudflare Dashboard URL or Workers & Pages overview |
| `SECONDBRAIN_PAT` | GitHub Personal Access Token with `repo` scope to access secondbrain |

### 4. Make secondbrain public OR set up PAT

Option A: Make secondbrain repo public
- GitHub → secondbrain → Settings → Change visibility

Option B: Create PAT for CI
1. GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens
2. Create token with:
   - Repository access: secondbrain only
   - Permissions: Contents (Read)
3. Add as `SECONDBRAIN_PAT` secret

## Local Development

```bash
cd /home/seyza/Repos/github.com/pedrotchang/garden
bun install
bun run quartz build --serve
```

## Manual Deploy

```bash
./deploy.sh
```
