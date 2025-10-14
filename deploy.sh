#!/bin/bash
# Deployment script for YaniQ documentation

echo "🚀 Deploying YaniQ Documentation to GitHub Pages..."

# Check if we're in the docs directory
if [ ! -f "_config.yml" ]; then
    echo "❌ Error: Must be run from the docs directory"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
bundle install

# Build the site
echo "🔨 Building Jekyll site..."
bundle exec jekyll build

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📁 Site built in _site directory"

    # Test the site locally (optional)
    echo ""
    echo "🌐 To test locally, run:"
    echo "   bundle exec jekyll serve"
    echo "   Then visit: http://localhost:4000"
else
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "✨ Documentation is ready!"
echo "📤 Push to GitHub to deploy automatically via GitHub Actions"

