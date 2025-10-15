#!/bin/bash

# Script to fix all internal links for GitHub Pages deployment
# Updates relative links to use proper baseurl

cd /mnt/projects/yaniQ/docs

echo "🔧 Fixing internal navigation links for GitHub Pages..."

# Function to update links in files
fix_links() {
    local file=$1
    
    # Skip if file doesn't exist
    [ ! -f "$file" ] && return
    
    # Fix relative_url usage - ensure proper syntax
    sed -i 's|{{ site\.baseurl }}/\([^"]*\)|{{ "/\1" | relative_url }}|g' "$file"
    sed -i 's|site\.baseurl}}/\([^"]*\)|"/\1" | relative_url }}|g' "$file"
    
    # Fix common path patterns
    sed -i 's|href="/pages/|href="{{ "/pages/|g' "$file"
    sed -i 's|href="{{ "/pages/\([^"]*\)"|href="{{ "/pages/\1" \| relative_url }}"|g' "$file"
    
    sed -i 's|href="/services/|href="{{ "/services/|g' "$file"
    sed -i 's|href="{{ "/services/\([^"]*\)"|href="{{ "/services/\1" \| relative_url }}"|g' "$file"
    
    sed -i 's|href="/LIBRARIES/|href="{{ "/LIBRARIES/|g' "$file"
    sed -i 's|href="{{ "/LIBRARIES/\([^"]*\)"|href="{{ "/LIBRARIES/\1" \| relative_url }}"|g' "$file"
    
    # Fix markdown links to use relative_url
    sed -i 's|](\/pages\/\([^)]*\))|]({{ "/pages/\1" | relative_url }})|g' "$file"
    sed -i 's|](\/services\/\([^)]*\))|]({{ "/services/\1" | relative_url }})|g' "$file"
    sed -i 's|](\/LIBRARIES\/\([^)]*\))|]({{ "/LIBRARIES/\1" | relative_url }})|g' "$file"
    
    # Fix asset paths
    sed -i 's|/assets/|{{ "/assets/|g' "$file"
    sed -i 's|{{ "/assets/\([^"]*\)"|{{ "/assets/\1" | relative_url }}|g' "$file"
}

# Fix HTML files
echo "📄 Fixing HTML files..."
find . -name "*.html" -type f | while read file; do
    echo "  - $file"
    fix_links "$file"
done

# Fix markdown files
echo "📝 Fixing markdown files..."
find . -name "*.md" -type f | while read file; do
    echo "  - $file"
    fix_links "$file"
done

# Fix includes
echo "🔧 Fixing include files..."
find _includes -name "*.html" -type f 2>/dev/null | while read file; do
    echo "  - $file"
    fix_links "$file"
done

# Fix layouts
echo "🎨 Fixing layout files..."
find _layouts -name "*.html" -type f 2>/dev/null | while read file; do
    echo "  - $file"
    fix_links "$file"
done

echo ""
echo "✅ Link fixing complete!"
echo ""
echo "Updated link patterns:"
echo "  - /pages/* → {{ '/pages/*' | relative_url }}"
echo "  - /services/* → {{ '/services/*' | relative_url }}"
echo "  - /LIBRARIES/* → {{ '/LIBRARIES/*' | relative_url }}"
echo "  - /assets/* → {{ '/assets/*' | relative_url }}"
echo ""