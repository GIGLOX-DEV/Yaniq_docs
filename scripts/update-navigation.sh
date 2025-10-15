#!/bin/bash

# Script to update all internal navigation links in documentation files
# After reorganizing the folder structure

cd /mnt/projects/yaniQ/docs

echo "🔄 Updating internal navigation links..."

# Function to update links in a file
update_links() {
    local file=$1
    
    # Update common documentation links
    sed -i 's|](GETTING_STARTED\.md)|](../getting-started/GETTING_STARTED.md)|g' "$file"
    sed -i 's|](/GETTING_STARTED\.md)|](../pages/getting-started/GETTING_STARTED.md)|g' "$file"
    sed -i 's|GETTING_STARTED\.html|pages/getting-started/GETTING_STARTED.html|g' "$file"
    
    sed -i 's|](ARCHITECTURE\.md)|](../guides/ARCHITECTURE.md)|g' "$file"
    sed -i 's|](/ARCHITECTURE\.md)|](../pages/guides/ARCHITECTURE.md)|g' "$file"
    sed -i 's|ARCHITECTURE\.html|pages/guides/ARCHITECTURE.html|g' "$file"
    
    sed -i 's|](CONFIGURATION\.md)|](../guides/CONFIGURATION.md)|g' "$file"
    sed -i 's|](/CONFIGURATION\.md)|](../pages/guides/CONFIGURATION.md)|g' "$file"
    sed -i 's|CONFIGURATION\.html|pages/guides/CONFIGURATION.html|g' "$file"
    
    sed -i 's|](DEPLOYMENT\.md)|](../guides/DEPLOYMENT.md)|g' "$file"
    sed -i 's|](/DEPLOYMENT\.md)|](../pages/guides/DEPLOYMENT.md)|g' "$file"
    sed -i 's|DEPLOYMENT\.html|pages/guides/DEPLOYMENT.html|g' "$file"
    
    sed -i 's|](TROUBLESHOOTING\.md)|](../guides/TROUBLESHOOTING.md)|g' "$file"
    sed -i 's|](/TROUBLESHOOTING\.md)|](../pages/guides/TROUBLESHOOTING.md)|g' "$file"
    sed -i 's|TROUBLESHOOTING\.html|pages/guides/TROUBLESHOOTING.html|g' "$file"
    
    sed -i 's|](CONTRIBUTING\.md)|](../contributing/CONTRIBUTING.md)|g' "$file"
    sed -i 's|](/CONTRIBUTING\.md)|](../pages/contributing/CONTRIBUTING.md)|g' "$file"
    sed -i 's|CONTRIBUTING\.html|pages/contributing/CONTRIBUTING.html|g' "$file"
    
    sed -i 's|](api-documentation\.md)|](../reference/api-documentation.md)|g' "$file"
    sed -i 's|](/api-documentation\.md)|](../pages/reference/api-documentation.md)|g' "$file"
    sed -i 's|api-documentation\.html|pages/reference/api-documentation.html|g' "$file"
    
    sed -i 's|](MESSAGING_GUIDE\.md)|](../guides/MESSAGING_GUIDE.md)|g' "$file"
    sed -i 's|](/MESSAGING_GUIDE\.md)|](../pages/guides/MESSAGING_GUIDE.md)|g' "$file"
    
    # Fix relative paths for files in subdirectories
    sed -i 's|](../services/|](../../services/|g' "$file"
    sed -i 's|](../LIBRARIES/|](../../LIBRARIES/|g' "$file"
}

# Update links in pages directory
echo "📝 Updating pages directory..."
find pages -name "*.md" -type f | while read file; do
    echo "  - $file"
    update_links "$file"
done

# Update links in services directory
echo "📝 Updating services directory..."
find services -name "*.md" -type f | while read file; do
    echo "  - $file"
    sed -i 's|](../ARCHITECTURE\.md)|](../pages/guides/ARCHITECTURE.md)|g' "$file"
    sed -i 's|](../CONFIGURATION\.md)|](../pages/guides/CONFIGURATION.md)|g' "$file"
    sed -i 's|](../DEPLOYMENT\.md)|](../pages/guides/DEPLOYMENT.md)|g' "$file"
    sed -i 's|](/ARCHITECTURE\.md)|](../pages/guides/ARCHITECTURE.md)|g' "$file"
    sed -i 's|](/CONFIGURATION\.md)|](../pages/guides/CONFIGURATION.md)|g' "$file"
    sed -i 's|](/DEPLOYMENT\.md)|](../pages/guides/DEPLOYMENT.md)|g' "$file"
done

# Update links in libraries directory
echo "📝 Updating libraries directory..."
find LIBRARIES -name "*.md" -type f | while read file; do
    echo "  - $file"
    sed -i 's|](../../ARCHITECTURE\.md)|](../../pages/guides/ARCHITECTURE.md)|g' "$file"
    sed -i 's|](../../CONFIGURATION\.md)|](../../pages/guides/CONFIGURATION.md)|g' "$file"
    sed -i 's|](../libraries\.md)|](../libraries.md)|g' "$file"
done

echo ""
echo "✅ Navigation links updated successfully!"
echo ""
echo "Updated paths:"
echo "  - GETTING_STARTED.md → pages/getting-started/GETTING_STARTED.md"
echo "  - ARCHITECTURE.md → pages/guides/ARCHITECTURE.md"
echo "  - CONFIGURATION.md → pages/guides/CONFIGURATION.md"
echo "  - DEPLOYMENT.md → pages/guides/DEPLOYMENT.md"
echo "  - TROUBLESHOOTING.md → pages/guides/TROUBLESHOOTING.md"
echo "  - CONTRIBUTING.md → pages/contributing/CONTRIBUTING.md"
echo "  - api-documentation.md → pages/reference/api-documentation.md"
echo ""
