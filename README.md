# YaniQ Documentation Site

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-success?style=for-the-badge&logo=github)](https://giglox-dev.github.io/Yaniq_docs)
[![Jekyll](https://img.shields.io/badge/Jekyll-4.3-red?style=for-the-badge&logo=jekyll)](https://jekyllrb.com/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](https://www.apache.org/licenses/LICENSE-2.0)
[![Build](https://img.shields.io/badge/Build-Passing-brightgreen?style=for-the-badge)](https://github.com/GIGLOX-DEV/Yaniq_docs/actions)

Comprehensive GitHub Pages documentation for YaniQ - A cloud-native microservices-based e-commerce platform built with Spring Boot, Spring Cloud, and modern DevOps practices.

## 🌐 Live Documentation

**[📖 View Live Documentation →](https://giglox-dev.github.io/Yaniq_docs)**

## ✨ Features

This documentation site includes:

### 📚 Complete Documentation
- **22 Microservices** - Detailed docs for all services
- **14 Shared Libraries** - Reusable component documentation
- **REST API Reference** - Complete API documentation with examples
- **Architecture Guides** - System design and patterns
- **Deployment Guides** - Docker, Kubernetes, cloud deployments
- **Configuration** - Environment and service configuration
- **Troubleshooting** - Common issues and solutions

### 🎨 Modern Features
- ✨ **Responsive Design** - Works on all devices
- 🔍 **Full-text Search** - Find anything instantly
- 🌓 **Dark/Light Mode** - Auto-switching based on preference
- 📋 **Code Highlighting** - Syntax highlighting with copy buttons
- 📊 **Mermaid Diagrams** - Interactive architecture diagrams
- 🔗 **Anchor Links** - Deep linking to any section
- ⬆️ **Back to Top** - Easy navigation
- 🚀 **Fast Loading** - Optimized performance

## 🚀 Local Development

### Prerequisites

- Ruby 2.7 or higher
- Bundler

### Setup

```bash
# Clone the repository
git clone https://github.com/GIGLOX-DEV/Yaniq_docs.git
cd Yaniq_docs

# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve

# View at http://localhost:4000
```

### Live Reload

For development with auto-reload:

```bash
bundle exec jekyll serve --livereload
```

## 📝 Contributing to Documentation

### Adding New Pages

1. Create a new Markdown file in the appropriate directory
2. Add front matter with metadata:

```yaml
---
layout: default
title: Your Page Title
nav_order: 10
parent: Parent Page (optional)
description: "Page description for SEO"
permalink: /your-page-url
---
```

3. Write your content in Markdown
4. Test locally before committing

### Documentation Structure

```
docs/
├── index.markdown              # Home page
├── GETTING_STARTED.md         # Getting started guide
├── ARCHITECTURE.md            # Architecture documentation
├── services.md                # Services overview
├── libraries.md               # Libraries overview
├── api-documentation.md       # API reference
├── CONFIGURATION.md           # Configuration guide
├── DEPLOYMENT.md              # Deployment guide
├── services/                  # Individual service docs
│   ├── AUTH_SERVICE.md
│   ├── GATEWAY_SERVICE.md
│   └── ...
├── LIBRARIES/                 # Library-specific docs
│   ├── common-messaging/
│   └── ...
├── assets/                    # Images, CSS, JS
└── _config.yml               # Jekyll configuration
```

### Writing Guidelines

- Use clear, concise language
- Include code examples where appropriate
- Add diagrams for complex concepts (Mermaid supported)
- Follow the existing style and formatting
- Test all code examples
- Use proper heading hierarchy (H1 → H2 → H3)
- Add navigation links between related pages

### Markdown Features

The documentation supports:

- **Tables** - For structured data
- **Code blocks** - With syntax highlighting
- **Mermaid diagrams** - For architecture and flow diagrams
- **Callouts** - Note, Warning, Important, Highlight boxes
- **Search** - Full-text search across all pages
- **Dark mode** - Automatic theme switching

### Callout Examples

```markdown
{: .note }
> This is a note callout

{: .warning }
> This is a warning callout

{: .important }
> This is an important callout

{: .highlight }
> This is a highlight callout
```

## 🎨 Theme

This documentation uses the [Just the Docs](https://just-the-docs.github.io/just-the-docs/) theme with custom configurations.

### Theme Features

- 📱 Responsive design
- 🔍 Built-in search
- 🌓 Dark/light mode
- 📑 Automatic navigation
- 🔗 Anchor links
- 📋 Code copy buttons
- 🎨 Customizable colors

## 🏗️ Project Structure

```
.
├── _config.yml              # Jekyll configuration
├── Gemfile                  # Ruby dependencies
├── index.markdown           # Home page
├── *.md                     # Documentation pages
├── services/                # Service documentation
├── LIBRARIES/              # Library documentation
├── assets/                 # Static assets
│   ├── images/
│   ├── css/
│   └── js/
└── _includes/              # Reusable components
```

## 🔧 Configuration

Key configuration in `_config.yml`:

- **Theme**: Just the Docs
- **Search**: Enabled with previews
- **Navigation**: Automatic from front matter
- **Plugins**: SEO, Feed, Sitemap
- **Color scheme**: Auto (respects system preference)

## 📊 Versioning

Documentation is versioned alongside the main YaniQ project:

- **Current Version**: 1.0.0
- **Java Version**: 21
- **Spring Boot**: 3.5.5
- **Spring Cloud**: 2025.0.0

## 🔄 Auto-Deployment

Documentation is automatically deployed to GitHub Pages when changes are pushed to the main branch.

### Deployment Workflow

1. Push changes to main branch
2. GitHub Actions triggers Jekyll build
3. Built site deployed to `gh-pages` branch
4. Available at https://giglox-dev.github.io/Yaniq_docs

## 🐛 Reporting Issues

Found an error or have a suggestion? Please:

1. Check [existing issues](https://github.com/GIGLOX-DEV/Yaniq_docs/issues)
2. [Create a new issue](https://github.com/GIGLOX-DEV/Yaniq_docs/issues/new) with:
   - Clear description
   - Steps to reproduce (if applicable)
   - Suggested fix (if you have one)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improve-docs`)
3. Make your changes
4. Test locally
5. Commit with clear messages
6. Push and create a Pull Request

### Contribution Guidelines

- Follow existing formatting and style
- Update navigation if adding new pages
- Test all code examples
- Run spell check
- Preview changes locally before submitting PR

## 📄 License

This documentation is licensed under the [Apache License 2.0](LICENSE).

The YaniQ platform itself is also licensed under Apache 2.0.

## 🔗 Related Links

- **Main Repository**: [GIGLOX-DEV/YaniQ](https://github.com/GIGLOX-DEV/YaniQ)
- **Documentation**: [Live Site](https://giglox-dev.github.io/Yaniq_docs)
- **Issues**: [Report Issues](https://github.com/GIGLOX-DEV/Yaniq_docs/issues)
- **Discussions**: [GitHub Discussions](https://github.com/GIGLOX-DEV/YaniQ/discussions)

## 💡 Tips

### Quick Search

Press `/` to focus the search bar quickly.

### Keyboard Navigation

- `⌘/Ctrl + K` - Open search
- Arrow keys - Navigate between pages
- `/` - Focus search

### Mobile Navigation

Tap the hamburger menu (☰) to access the full navigation on mobile devices.

## 📞 Support

For questions or support:

- 📧 Email: support@yaniq.com
- 💬 Discussions: [GitHub Discussions](https://github.com/GIGLOX-DEV/YaniQ/discussions)
- 🐛 Issues: [GitHub Issues](https://github.com/GIGLOX-DEV/Yaniq_docs/issues)

---

**Built with ❤️ by the YaniQ Team**

© 2024-2025 YaniQ Enterprise. All rights reserved.

