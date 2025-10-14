# 🤝 Contributing to YaniQ

<div align="center">

![Contributing](https://img.shields.io/badge/Contributions-Welcome-brightgreen?style=for-the-badge)
![Code of Conduct](https://img.shields.io/badge/Code%20of%20Conduct-Contributor%20Covenant-blue?style=for-the-badge)

**We welcome contributions from the community!**

[Getting Started](#-getting-started) •
[Development Setup](#-development-setup) •
[Contribution Workflow](#-contribution-workflow) •
[Code Standards](#-code-standards) •
[Review Process](#-review-process)

</div>

---

## 📋 Table of Contents

- [Getting Started](#-getting-started)
- [Development Setup](#-development-setup)
- [Contribution Workflow](#-contribution-workflow)
- [Code Standards](#-code-standards)
- [Testing Guidelines](#-testing-guidelines)
- [Documentation](#-documentation)
- [Pull Request Process](#-pull-request-process)
- [Code Review](#-code-review)
- [Community Guidelines](#-community-guidelines)

---

## 🚀 Getting Started

### Ways to Contribute

We appreciate all forms of contributions:

- 🐛 **Bug Reports** - Report issues you encounter
- 💡 **Feature Requests** - Suggest new features
- 📝 **Documentation** - Improve or add documentation
- 💻 **Code Contributions** - Fix bugs or implement features
- 🧪 **Testing** - Write tests or test releases
- 🌍 **Translations** - Help translate the project
- 💬 **Community Support** - Help others in discussions

### Before You Start

1. **Read the Documentation**
   - [README](./README.md)
   - [Architecture](./ARCHITECTURE.md)
   - [Getting Started Guide](./GETTING_STARTED.md)

2. **Check Existing Issues**
   - Browse [open issues](https://github.com/yaniq/yaniq-monorepo/issues)
   - Avoid duplicate work

3. **Discuss Major Changes**
   - Open an issue for discussion
   - Get feedback before implementation

---

## 💻 Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR_USERNAME/yaniq-monorepo.git
cd yaniq-monorepo

# Add upstream remote
git remote add upstream https://github.com/yaniq/yaniq-monorepo.git
```

### 2. Install Dependencies

```bash
# Java 21
java -version

# Maven 3.8+
mvn -version

# Docker
docker --version
```

### 3. Set Up Development Environment

```bash
# Copy environment file
cp example.env .env

# Edit with your local settings
nano .env

# Start infrastructure
docker-compose up -d postgres redis kafka
```

### 4. Build the Project

```bash
# Build all modules
mvn clean install

# Build specific service
cd apps/discovery-service
mvn clean install
```

### 5. Run Tests

```bash
# Run all tests
mvn test

# Run tests for specific service
cd apps/auth-service
mvn test

# Run with coverage
mvn test jacoco:report
```

---

## 🔄 Contribution Workflow

### 1. Create a Branch

```bash
# Update your fork
git fetch upstream
git checkout main
git merge upstream/main

# Create feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

### Branch Naming Convention

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/description` | `feature/add-payment-service` |
| Bug Fix | `fix/description` | `fix/cart-calculation-error` |
| Documentation | `docs/description` | `docs/update-api-guide` |
| Refactoring | `refactor/description` | `refactor/auth-service` |
| Performance | `perf/description` | `perf/optimize-queries` |
| Testing | `test/description` | `test/add-integration-tests` |

### 2. Make Changes

```bash
# Make your changes
# ... edit files ...

# Stage changes
git add .

# Commit with meaningful message
git commit -m "feat(auth): add OAuth2 support"
```

### 3. Keep Your Branch Updated

```bash
# Fetch latest changes
git fetch upstream

# Rebase your branch
git rebase upstream/main

# Force push if needed (for your feature branch)
git push origin feature/your-feature-name --force-with-lease
```

### 4. Push and Create Pull Request

```bash
# Push to your fork
git push origin feature/your-feature-name

# Go to GitHub and create a Pull Request
```

---

## 📏 Code Standards

### Java Code Style

#### Formatting

```java
// ✅ Good: Proper formatting and naming
@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService {
    
    private final ProductRepository productRepository;
    private final ProductMapper productMapper;
    
    @Transactional(readOnly = true)
    public ProductDTO getProductById(Long id) {
        log.debug("Fetching product with id: {}", id);
        
        return productRepository.findById(id)
            .map(productMapper::toDTO)
            .orElseThrow(() -> new ProductNotFoundException(id));
    }
}

// ❌ Bad: Poor formatting
@Service public class ProductService{
private ProductRepository repo;
public ProductDTO getProduct(Long id){
return repo.findById(id).map(p->new ProductDTO(p)).orElseThrow(()->new RuntimeException());
}
}
```

#### Naming Conventions

```java
// Classes: PascalCase
public class UserService {}

// Interfaces: PascalCase
public interface UserRepository {}

// Methods: camelCase
public void calculateTotal() {}

// Variables: camelCase
private String userName;

// Constants: UPPER_SNAKE_CASE
public static final int MAX_RETRIES = 3;

// Packages: lowercase
package com.yaniq.service.auth;
```

#### Documentation

```java
/**
 * Service for managing product operations.
 * 
 * <p>This service provides CRUD operations for products and integrates
 * with inventory and pricing services.</p>
 * 
 * @author YaniQ Team
 * @version 1.0.0
 * @since 1.0.0
 */
@Service
public class ProductService {
    
    /**
     * Retrieves a product by its ID.
     * 
     * @param id the product ID, must not be null
     * @return the product DTO
     * @throws ProductNotFoundException if product not found
     * @throws IllegalArgumentException if id is null
     */
    public ProductDTO getProductById(@NonNull Long id) {
        // implementation
    }
}
```

### YAML Configuration Style

```yaml
# ✅ Good: Consistent indentation and organization
spring:
  application:
    name: auth-service
  
  datasource:
    url: ${DATABASE_URL}
    username: ${POSTGRES_USER}
    password: ${POSTGRES_PASSWORD}
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

# ❌ Bad: Inconsistent indentation
spring:
 application:
   name: auth-service
  datasource:
     url: ${DATABASE_URL}
```

### Git Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Format
<type>(<scope>): <subject>

<body>

<footer>
```

#### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tools
- `ci`: CI/CD changes

#### Examples

```bash
# ✅ Good commits
feat(auth): add OAuth2 authentication support

fix(cart): resolve item quantity calculation error

docs(api): update authentication endpoints documentation

test(order): add integration tests for order creation

# ❌ Bad commits
"fixed stuff"
"update"
"changes"
```

---

## 🧪 Testing Guidelines

### Test Structure

```java
@SpringBootTest
@TestPropertySource(locations = "classpath:application-test.yml")
class ProductServiceTest {
    
    @Autowired
    private ProductService productService;
    
    @MockBean
    private ProductRepository productRepository;
    
    @BeforeEach
    void setUp() {
        // Setup test data
    }
    
    @Test
    @DisplayName("Should return product when exists")
    void shouldReturnProductWhenExists() {
        // Given
        Long productId = 1L;
        Product product = Product.builder()
            .id(productId)
            .name("Test Product")
            .build();
        when(productRepository.findById(productId))
            .thenReturn(Optional.of(product));
        
        // When
        ProductDTO result = productService.getProductById(productId);
        
        // Then
        assertNotNull(result);
        assertEquals("Test Product", result.getName());
        verify(productRepository).findById(productId);
    }
    
    @Test
    @DisplayName("Should throw exception when product not found")
    void shouldThrowExceptionWhenProductNotFound() {
        // Given
        Long productId = 999L;
        when(productRepository.findById(productId))
            .thenReturn(Optional.empty());
        
        // When & Then
        assertThrows(ProductNotFoundException.class, 
            () -> productService.getProductById(productId));
    }
}
```

### Test Coverage Requirements

- **Unit Tests**: Minimum 80% coverage
- **Integration Tests**: Critical paths covered
- **End-to-End Tests**: Main user flows

### Running Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=ProductServiceTest

# Run with coverage
mvn test jacoco:report

# View coverage report
open target/site/jacoco/index.html
```

---

## 📝 Documentation

### Code Documentation

- **JavaDoc** for all public APIs
- **Inline comments** for complex logic
- **README** in each service directory

### API Documentation

- Use **OpenAPI 3.0** annotations
- Provide **request/response examples**
- Document **error codes**

```java
@Operation(
    summary = "Get product by ID",
    description = "Retrieves a product by its unique identifier"
)
@ApiResponses(value = {
    @ApiResponse(
        responseCode = "200",
        description = "Product found",
        content = @Content(schema = @Schema(implementation = ProductDTO.class))
    ),
    @ApiResponse(
        responseCode = "404",
        description = "Product not found"
    )
})
@GetMapping("/{id}")
public ResponseEntity<ProductDTO> getProduct(@PathVariable Long id) {
    // implementation
}
```

---

## 🔍 Pull Request Process

### 1. PR Title

Follow the same format as commit messages:

```
feat(service): add new feature
fix(service): resolve specific bug
docs: update contribution guidelines
```

### 2. PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issues
Fixes #123

## Changes Made
- Added OAuth2 support
- Updated authentication flow
- Added integration tests

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

## Screenshots (if applicable)

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added and passing
- [ ] No new warnings
```

### 3. PR Size Guidelines

- **Small**: < 200 lines (preferred)
- **Medium**: 200-500 lines
- **Large**: > 500 lines (should be broken down)

### 4. Review Requirements

- **Discovery Service**: 1 approval required
- **Other Services**: 2 approvals required
- **Infrastructure Changes**: 2 approvals + security review

---

## 👀 Code Review

### As a Reviewer

#### What to Look For

✅ **Code Quality**
- Follows coding standards
- No code smells
- Proper error handling
- Efficient algorithms

✅ **Tests**
- Adequate test coverage
- Tests are meaningful
- Edge cases covered

✅ **Documentation**
- Code is well-documented
- README updated if needed
- API docs updated

✅ **Security**
- No security vulnerabilities
- Sensitive data properly handled
- Input validation present

#### Review Comments

```markdown
# ✅ Good Review Comments

## Suggestion
Consider using Optional.ofNullable() here to handle potential null values gracefully.

## Question
Could you explain the reasoning behind this approach? I'm wondering if X would be more efficient.

## Blocker
This introduces a security vulnerability. We need to sanitize user input before processing.

## Nitpick
Minor: This variable name could be more descriptive.

# ❌ Bad Review Comments

"This is wrong."
"Change this."
"I don't like this."
```

### As a Contributor

#### Responding to Reviews

- **Be receptive** to feedback
- **Ask questions** if unclear
- **Explain your reasoning** when disagreeing
- **Update promptly** based on feedback
- **Thank reviewers** for their time

---

## 🌟 Community Guidelines

### Code of Conduct

We follow the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/):

- **Be respectful** and inclusive
- **Be collaborative** and constructive
- **Be patient** with newcomers
- **Be professional** in all interactions

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and general discussion
- **Pull Requests**: Code contributions
- **Email**: danukajihansanath0408@gmail.com (for sensitive matters)

### Recognition

Contributors are recognized in:
- Project README
- Release notes
- Contributor graphs

---

## 🎯 Your First Contribution

### Good First Issues

Look for issues labeled:
- `good first issue` - Beginner-friendly
- `help wanted` - Community help needed
- `documentation` - Documentation improvements

### Step-by-Step Guide

1. **Find an Issue**
   ```bash
   # Browse good first issues
   https://github.com/yaniq/yaniq-monorepo/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22
   ```

2. **Comment on the Issue**
   ```markdown
   I'd like to work on this issue. Could you assign it to me?
   ```

3. **Follow the Workflow**
   - Fork → Branch → Code → Test → PR

4. **Ask for Help**
   - Don't hesitate to ask questions
   - We're here to help!

---

## 📚 Additional Resources

- 📖 [Architecture Guide](./ARCHITECTURE.md)
- 🚀 [Getting Started](./GETTING_STARTED.md)
- ⚙️ [Configuration Guide](./CONFIGURATION.md)
- 🚢 [Deployment Guide](./DEPLOYMENT.md)
- 🔧 [Troubleshooting](./TROUBLESHOOTING.md)

---

## 📧 Questions?

- 🐛 [Report an Issue](https://github.com/yaniq/yaniq-monorepo/issues/new)
- 💬 [Start a Discussion](https://github.com/yaniq/yaniq-monorepo/discussions/new)
- 📧 Email: danukajihansanath0408@gmail.com

---

<div align="center">

**Thank you for contributing to YaniQ!** 🎉

[⬆ Back to Top](#-contributing-to-yaniq) | [📖 Main Documentation](./README.md)

</div>

