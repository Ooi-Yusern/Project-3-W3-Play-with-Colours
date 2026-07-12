#!/bin/bash

# Project 3: Play with Colours - Local Development Setup
# W3 Server-Side Development & Authentication

echo "🎨 Play with Colours - SvelteKit Project Setup"
echo "==============================================="
echo ""

# Check if script is run from correct directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the project-03-colours directory"
    echo "   Expected: cd Templates/project-03-colours && ./setup.sh"
    exit 1
fi

echo "🎓 DISCOVERY LEARNING OBJECTIVES:"
echo "   • Work with conditional rendering"
echo "   • Master Svelte logic blocks ({#if}, {#each})"
echo "   • Manipulate data with JavaScript"
echo "   • Create dynamic user interfaces"
echo ""

echo "📚 Key Concepts (Lesson 11):"
echo "   → Conditional rendering with {#if}/{:else}"
echo "   → List rendering with {#each}"
echo "   → Array manipulation methods"
echo "   → Dynamic styling and classes"
echo ""

# Check for node_modules
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    echo ""
    npm install

    if [ $? -ne 0 ]; then
        echo "❌ npm install failed"
        echo "   Try running: npm install --legacy-peer-deps"
        exit 1
    fi

    echo "✅ Dependencies installed successfully!"
    echo ""
else
    echo "✅ Dependencies already installed"
    echo ""
fi

echo "📁 Project Structure:"
echo "   • Entry point: src/routes/+page.svelte"
echo "   • Color data: Implement dynamic color arrays"
echo "   • Logic blocks: {#if}, {#each} for rendering"
echo ""

echo "🚀 Starting SvelteKit development server..."
echo ""
echo "   → Server will start at: http://localhost:5173"
echo "   → Press Ctrl+C to stop the server"
echo ""
echo "==============================================="
echo ""

# Start the development server
npm run dev
