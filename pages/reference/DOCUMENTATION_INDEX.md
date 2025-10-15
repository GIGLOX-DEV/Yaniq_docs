# 📚 Documentation Index

Welcome to the **YaniQ E-Commerce Platform** documentation! This comprehensive guide covers everything you need to know about the platform.

---

## 📖 Core Documentation

### Essential Guides

1. **[Main README](./README.md)** 📘
   - Complete platform overview
   - Key features and technology stack
   - Service status matrix
   - Quick links and resources

2. **[Architecture Overview](./ARCHITECTURE.md)** 🏗️
   - System architecture diagrams
   - Microservices patterns
   - Communication strategies
   - Data architecture
   - Security architecture
   - Observability setup

3. **[Getting Started Guide](./GETTING_STARTED.md)** 🚀
   - Prerequisites and system requirements
   - Installation methods (Local, Docker, Kubernetes)
   - Step-by-step setup instructions
   - Common issues and solutions
   - Next steps for developers and operators

4. **[Configuration Guide](./CONFIGURATION.md)** ⚙️
   - Configuration structure
   - Environment variables
   - Spring profiles
   - Service-specific configurations
   - Database, cache, and messaging setup
   - Best practices

5. **[Deployment Guide](./DEPLOYMENT.md)** 🚀
   - Pre-deployment checklist
   - Docker deployment
   - Kubernetes deployment
   - Cloud provider setup (AWS, GCP, Azure)
   - CI/CD pipeline configuration
   - Monitoring and security setup

6. **[Contributing Guide](./CONTRIBUTING.md)** 🤝
   - How to contribute
   - Development setup
   - Code standards and conventions
   - Testing guidelines
   - Pull request process
   - Community guidelines

7. **[Troubleshooting Guide](./TROUBLESHOOTING.md)** 🔧
   - Service issues
   - Infrastructure problems
   - Configuration errors
   - Performance issues
   - Security concerns
   - Docker and Kubernetes troubleshooting

---

## 🎯 Service Documentation

### ✅ Production Ready Services

- **[Discovery Service (Eureka)](./services/DISCOVERY_SERVICE.md)** - Port 8761
  - Service registry and discovery
  - Configuration details
  - High availability setup
  - Complete API reference
  - Production deployment guide

### 🚧 Services in Development

- **[Gateway Service](./services/GATEWAY_SERVICE.md)** - Port 8080
  - API Gateway with routing
  - Rate limiting and security
  - CORS configuration
  - Circuit breaker integration

- **[Auth Service](./services/AUTH_SERVICE.md)** - Port 8081
  - Authentication and authorization
  - JWT token management
  - Password management
  - Database schema

- **User Service** - Port 8082 (Documentation coming soon)
- **Product Service** - Port 8083 (Documentation coming soon)
- **Order Service** - Port 8084 (Documentation coming soon)
- **Payment Service** - Port 8085 (Documentation coming soon)
- **Cart Service** - Port 8086 (Documentation coming soon)
- **Inventory Service** - Port 8087 (Documentation coming soon)
- **Notification Service** - Port 8088 (Documentation coming soon)
- **Analytics Service** - Port 8089 (Documentation coming soon)

---

## 🌐 Web Documentation

### Interactive Documentation Portal

**[index.html](./index.html)** - Beautiful Tailwind CSS Documentation Website
- Responsive design
- Service status overview
- Technology stack showcase
- Quick navigation
- GitHub Pages ready

Access the web documentation by opening `index.html` in your browser or hosting it on GitHub Pages.

---

## 📂 Documentation Structure

```
docs/
├── README.md                      # Main documentation hub
├── ARCHITECTURE.md                # System architecture
├── GETTING_STARTED.md             # Setup guide
├── CONFIGURATION.md               # Configuration management
├── DEPLOYMENT.md                  # Deployment strategies
├── CONTRIBUTING.md                # Contribution guidelines
├── TROUBLESHOOTING.md             # Problem solving guide
├── index.html                     # Web documentation portal
└── services/                      # Service-specific docs
    ├── DISCOVERY_SERVICE.md       # ✅ Complete
    ├── GATEWAY_SERVICE.md         # 🚧 In Progress
    ├── AUTH_SERVICE.md            # 🚧 In Progress
    └── [other services...]        # 📅 Coming soon
```

---

## 🚀 Quick Start

### For New Users

1. Start with **[README.md](./README.md)** for platform overview
2. Follow **[Getting Started Guide](./GETTING_STARTED.md)** for setup
3. Review **[Architecture](./ARCHITECTURE.md)** to understand the system

### For Developers

1. Read **[Contributing Guide](./CONTRIBUTING.md)**
2. Check **[Configuration Guide](./CONFIGURATION.md)**
3. Explore service-specific documentation in `services/`

### For Operations

1. Review **[Deployment Guide](./DEPLOYMENT.md)**
2. Setup monitoring using **[Architecture - Observability](./ARCHITECTURE.md#-observability-architecture)**
3. Keep **[Troubleshooting Guide](./TROUBLESHOOTING.md)** handy

---

## 🎨 Documentation Features

### What's Included

✅ **Comprehensive Coverage**
- 7 core documentation files
- 3 service-specific guides
- 1 interactive web portal
- Architecture diagrams using Mermaid
- Code examples and configurations

✅ **Professional Styling**
- GitHub-style markdown formatting
- Tailwind CSS web interface
- Responsive design
- Icons and badges
- Easy navigation

✅ **Production Ready**
- Discovery Service documentation complete
- Deployment guides for Docker, Kubernetes, and Cloud
- Security best practices
- Troubleshooting solutions

✅ **GitHub Pages Ready**
- Beautiful HTML landing page
- Tailwind CSS styling
- No build process required
- Direct hosting support

---

## 📊 Documentation Status

| Document | Status | Completion |
|----------|--------|------------|
| Main README | ✅ Complete | 100% |
| Architecture | ✅ Complete | 100% |
| Getting Started | ✅ Complete | 100% |
| Configuration | ✅ Complete | 100% |
| Deployment | ✅ Complete | 100% |
| Contributing | ✅ Complete | 100% |
| Troubleshooting | ✅ Complete | 100% |
| Web Portal (index.html) | ✅ Complete | 100% |
| Discovery Service | ✅ Complete | 100% |
| Gateway Service | ✅ Complete | 100% |
| Auth Service | ✅ Complete | 100% |
| Other Services | 📅 Planned | 0% |

---

## 🌐 Hosting on GitHub Pages

### Setup Instructions

1. **Enable GitHub Pages**:
   - Go to repository Settings → Pages
   - Source: Deploy from a branch
   - Branch: `main` (or your default branch)
   - Folder: `/docs`
   - Click Save

2. **Access Your Documentation**:
   - URL: `https://[username].github.io/[repository]/`
   - Example: `https://yaniq.github.io/yaniq-monorepo/`

3. **Custom Domain** (Optional):
   - Add `CNAME` file in `/docs` directory
   - Configure DNS settings
   - Enable HTTPS in GitHub Pages settings

---

## 🔄 Keeping Documentation Updated

### When to Update

- ✏️ **New Features**: Document new functionality
- 🐛 **Bug Fixes**: Update troubleshooting guide
- ⚙️ **Configuration Changes**: Update configuration guide
- 🚀 **New Services**: Add service documentation
- 📊 **Architecture Changes**: Update architecture diagrams

### How to Contribute to Documentation

1. Follow the **[Contributing Guide](./CONTRIBUTING.md)**
2. Use consistent formatting and style
3. Include code examples where applicable
4. Add diagrams for complex concepts
5. Test all commands and code snippets

---

## 📞 Support

### Get Help

- 🐛 **Report Issues**: [GitHub Issues](https://github.com/yaniq/yaniq-monorepo/issues)
- 💬 **Ask Questions**: [GitHub Discussions](https://github.com/yaniq/yaniq-monorepo/discussions)
- 📧 **Email**: danukajihansanath0408@gmail.com
- 📚 **Documentation**: This site!

---

## 📝 License

This documentation is part of the YaniQ E-Commerce Platform and is licensed under the Apache License 2.0.

---

<div align="center">

**YaniQ Documentation** | Built with ❤️ by the YaniQ Team

Updated: October 14, 2025

</div>

