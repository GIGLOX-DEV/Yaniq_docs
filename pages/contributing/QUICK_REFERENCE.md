# YaniQ Documentation - Quick Reference

## 🚀 Quick Commands

### Local Development
```bash
# Navigate to docs
cd /mnt/projects/yaniQ/docs

# Install dependencies
bundle install

# Serve locally (with live reload)
bundle exec jekyll serve --livereload

# Build for production
JEKYLL_ENV=production bundle exec jekyll build

# Clean build cache
bundle exec jekyll clean
```

### Deployment
```bash
# Deploy to GitHub Pages (automatic via Actions)
git add docs/
git commit -m "Update documentation"
git push origin main

# Manual deployment
cd docs
./deploy.sh

# Regenerate service docs
./scripts/generate-docs.sh
```

## 📁 File Structure Quick Reference

```
docs/
├── _includes/              # HTML components (header, footer, etc.)
├── _layouts/               # Page templates (default, page, post, home)
├── _sass/                  # SCSS stylesheets
├── assets/                 # CSS, JS, images
│   ├── css/style.scss     # Main stylesheet
│   └── images/            # Logo, diagrams, icons
├── services/               # Service documentation (22 services)
├── LIBRARIES/              # Library documentation (14 libraries)
├── _config.yml            # Jekyll configuration
├── index.html             # Landing page
├── api-documentation.md   # API reference
├── ARCHITECTURE.md        # Architecture guide
├── CONFIGURATION.md       # Configuration guide
├── DEPLOYMENT.md          # Deployment guide
├── GETTING_STARTED.md     # Quick start
└── TROUBLESHOOTING.md     # Common issues
```

## 📝 Adding New Content

### New Service Documentation
```bash
# Use the generator script
./scripts/generate-docs.sh

# Or manually create
touch services/NEW-SERVICE.md
```

Service template:
```markdown
---
layout: default
title: Service Name
parent: Services
nav_order: X
description: "Service description"
---

# Service Name

## Overview
...
```

### New Library Documentation
```bash
mkdir -p LIBRARIES/new-library
touch LIBRARIES/new-library/index.md
```

### New Page
```markdown
---
layout: default
title: Page Title
nav_order: X
description: "Page description"
---

# Page Title

Your content here...
```

### New Blog Post
```bash
# Create in _posts/
touch _posts/2024-10-15-post-title.md
```

Post template:
```markdown
---
layout: post
title: "Post Title"
date: 2024-10-15
categories: [updates, tutorials]
author: Your Name
---

Your post content...
```

## 🎨 Styling Quick Reference

### Colors (assets/css/style.scss)
```scss
:root {
  --yaniq-primary: #2a7ae2;
  --yaniq-secondary: #00796b;
  --yaniq-accent: #ff6f00;
  --yaniq-success: #4caf50;
  --yaniq-warning: #ff9800;
  --yaniq-error: #f44336;
}
```

### Callouts
```markdown
{: .note }
> This is a note

{: .warning }
> This is a warning

{: .important }
> This is important
```

### Badges
```markdown
<span class="badge badge-java">Java 21</span>
<span class="badge badge-spring">Spring Boot</span>
<span class="badge badge-microservice">Microservice</span>
```

### API Endpoints
```markdown
<span class="api-method method-get">GET</span> `/api/v1/resource`
<span class="api-method method-post">POST</span> `/api/v1/resource`
<span class="api-method method-put">PUT</span> `/api/v1/resource/{id}`
<span class="api-method method-delete">DELETE</span> `/api/v1/resource/{id}`
```

## 📊 Front Matter Options

### Page Configuration
```yaml
---
layout: default          # Layout template
title: Page Title        # Page title
nav_order: 5            # Navigation order
parent: Parent Page     # Parent in navigation
has_children: true      # Has child pages
description: "..."      # SEO description
permalink: /custom-url  # Custom URL
---
```

### Post Configuration
```yaml
---
layout: post
title: "Post Title"
date: 2024-10-15
categories: [category1, category2]
tags: [tag1, tag2]
author: Author Name
---
```

## 🔧 Configuration Quick Reference

### _config.yml Key Settings
```yaml
title: YaniQ Documentation
description: Platform documentation
baseurl: "/Yaniq_docs"
url: "https://giglox-dev.github.io"
remote_theme: just-the-docs/just-the-docs

# Search
search_enabled: true

# Navigation
back_to_top: true
heading_anchors: true

# Code
enable_copy_code_button: true
```

## 🐛 Common Issues

### Jekyll Build Fails
```bash
# Clear cache
rm -rf _site .jekyll-cache
bundle exec jekyll clean

# Reinstall dependencies
rm Gemfile.lock
bundle install

# Build with verbose output
bundle exec jekyll build --verbose
```

### Port Already in Use
```bash
# Kill existing Jekyll process
pkill -f jekyll

# Or use different port
bundle exec jekyll serve --port 4001
```

### GitHub Pages Not Updating
1. Check GitHub Actions tab for errors
2. Verify gh-pages branch exists
3. Check Pages settings in repository
4. Clear browser cache

## 📚 Useful Links

- **Jekyll Docs:** https://jekyllrb.com/docs/
- **Just the Docs Theme:** https://just-the-docs.github.io/
- **Markdown Guide:** https://www.markdownguide.org/
- **Liquid Syntax:** https://shopify.github.io/liquid/
- **GitHub Pages:** https://docs.github.com/en/pages
- **Mermaid Diagrams:** https://mermaid.js.org/

## 🎯 Navigation Keyboard Shortcuts

- `/` - Focus search
- `⌘/Ctrl + K` - Open search
- Arrow keys - Navigate between pages

## 📖 Writing Tips

1. **Use descriptive headings** - Clear hierarchy with #, ##, ###
2. **Add code examples** - Show, don't just tell
3. **Include diagrams** - Visual aids improve understanding
4. **Link related content** - Help users discover more
5. **Keep it concise** - Short paragraphs, bullet points
6. **Test locally** - Always preview before pushing

## 🔄 Update Workflow

1. Make changes to markdown files
2. Test locally: `bundle exec jekyll serve`
3. Review at http://localhost:4000
4. Commit: `git commit -m "Update docs"`
5. Push: `git push origin main`
6. GitHub Actions deploys automatically
7. Check live site in ~2 minutes

## 📦 Dependencies

```ruby
# Gemfile essentials
gem "jekyll", "~> 4.3.0"
gem "just-the-docs", "0.8.0"
gem "jekyll-feed"
gem "jekyll-seo-tag"
gem "jekyll-sitemap"
```

## 🎨 Theme Customization

```scss
// Override in assets/css/style.scss
@import "minima";

.custom-class {
  // Your custom styles
}
```

## 🔐 GitHub Pages Setup

1. Go to **Settings** > **Pages**
2. Source: **Deploy from a branch**
3. Branch: **gh-pages** / **(root)**
4. Click **Save**
5. Wait for deployment
6. Visit your site!

---

## 💡 Pro Tips

- Use `bundle exec jekyll serve --drafts` to preview draft posts
- Add `published: false` to front matter to hide pages
- Use `{% include file.html %}` to reuse HTML components
- Test responsive design with browser dev tools
- Use relative URLs: `{{ '/page' | relative_url }}`
- Enable verbose logging: `--verbose` flag

---

**Last Updated:** 2024-10-15
**Version:** 1.0.0
