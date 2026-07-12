<script>
  import { onMount } from 'svelte';

  // ==================== PROJECT: PLAY WITH COLOURS ====================
  // This project demonstrates 65-70% working implementation with TODOs for students
  // ✅ WORKING: Color validation, display, reactivity
  // ⚠️ TODO: Color picker integration, export features

  // ==================== STATE MANAGEMENT ====================
  // ✅ WORKING: Core state variables
  let colorInput = '';
  let colorsList = [
    { id: 1, hex: '#FF6347', rgb: {r: 255, g: 99, b: 71}, rgbString: 'rgb(255, 99, 71)', name: 'Tomato' },
    { id: 2, hex: '#32CD32', rgb: {r: 50, g: 205, b: 50}, rgbString: 'rgb(50, 205, 50)', name: 'LimeGreen' },
    { id: 3, hex: '#87CEEB', rgb: {r: 135, g: 206, b: 235}, rgbString: 'rgb(135, 206, 235)', name: 'SkyBlue' }
  ];
  let validationResult = null;
  let nextId = 4;
  let pickerColor = '#000000';
  let isLoaded = false;

  // Load from localStorage on mount
  onMount(() => {
    const saved = localStorage.getItem('play_colors_palette');
    if (saved) {
      try {
        colorsList = JSON.parse(saved);
        if (colorsList.length > 0) {
          nextId = Math.max(...colorsList.map(c => c.id)) + 1;
        }
      } catch (err) {
        console.error('Failed to load palette from localStorage:', err);
      }
    }
    isLoaded = true;
  });

  // Save to localStorage when colorsList changes
  $: {
    if (isLoaded && typeof window !== 'undefined') {
      localStorage.setItem('play_colors_palette', JSON.stringify(colorsList));
    }
  }

  // Reactive two-way sync from text input to picker
  $: if (isValidHex(colorInput)) {
    pickerColor = normalizeHex(colorInput);
  }


  // ==================== HELPER FUNCTIONS ====================
  // ✅ WORKING: Color validation and conversion

  /**
   * ✅ WORKING: Validates hex color format
   */
  function isValidHex(color) {
    const hexPattern = /^#?([0-9A-F]{3}){1,2}$/i;
    return hexPattern.test(color);
  }

  /**
   * ✅ WORKING: Normalizes hex colors to #RRGGBB format
   */
  function normalizeHex(color) {
    let normalized = color.replace('#', '').toUpperCase();

    // Expand 3-char format to 6-char (e.g., F90 → FF9900)
    if (normalized.length === 3) {
      normalized = normalized.split('').map(char => char + char).join('');
    }

    return '#' + normalized;
  }

  /**
   * ✅ WORKING: Converts hex to RGB object
   */
  function hexToRgb(hex) {
    const normalized = normalizeHex(hex);
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(normalized);

    return result ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16)
    } : null;
  }

  /**
   * ✅ WORKING: Calculates contrasting text color for readability
   */
  function getContrastColor(hex) {
    const rgb = hexToRgb(hex);
    if (!rgb) return '#000000';

    // Calculate luminance (human eye sensitivity to RGB)
    const luminance = (0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b) / 255;

    // Bright backgrounds need dark text, dark backgrounds need light text
    return luminance > 0.5 ? '#000000' : '#FFFFFF';
  }


  // ==================== ACTION FUNCTIONS ====================

  /**
   * ✅ WORKING: Validates color input and provides feedback
   */
  function validateColor() {
    const input = colorInput.trim();

    // Check if empty
    if (!input) {
      validationResult = {
        valid: false,
        message: 'Please enter a color code',
        color: null
      };
      return;
    }

    // Check if valid hex format
    if (!isValidHex(input)) {
      validationResult = {
        valid: false,
        message: 'Invalid hex color format. Use #RGB or #RRGGBB (e.g., #FF5733 or F90)',
        color: null
      };
      return;
    }

    // Normalize and convert
    const normalizedColor = normalizeHex(input);
    const rgb = hexToRgb(normalizedColor);

    // Check for duplicates
    if (colorsList.some(c => c.hex === normalizedColor)) {
      validationResult = {
        valid: false,
        message: 'This color is already in your palette',
        color: normalizedColor
      };
      return;
    }

    // Valid color!
    validationResult = {
      valid: true,
      message: `Valid hex color: ${normalizedColor}`,
      color: normalizedColor,
      rgb: rgb,
      rgbString: `rgb(${rgb.r}, ${rgb.g}, ${rgb.b})`
    };
  }

  /**
   * ✅ WORKING: Adds validated color to palette
   */
  function addToPalette() {
    if (validationResult && validationResult.valid) {
      // Create new array with spread operator (triggers Svelte reactivity!)
      colorsList = [...colorsList, {
        id: nextId++,
        hex: validationResult.color,
        rgb: validationResult.rgb,
        rgbString: validationResult.rgbString,
        name: colorInput.trim()
      }];

      // Clear form
      colorInput = '';
      validationResult = null;
    }
  }

  /**
   * ✅ WORKING: Removes color from palette
   */
  function removeColor(id) {
    colorsList = colorsList.filter(color => color.id !== id);
  }

  /**
   * ✅ WORKING: Clears all colors with confirmation
   */
  function clearAll() {
    if (confirm(`Are you sure you want to clear all ${colorsList.length} colors from your palette?`)) {
      colorsList = [];
      validationResult = null;
    }
  }

  /**
   * ✅ WORKING: Handles form submission
   */
  function handleSubmit(event) {
    event.preventDefault();
    validateColor();
  }

  /**
   * ✅ WORKING: Copies color to clipboard
   */
  async function copyToClipboard(text) {
    try {
      await navigator.clipboard.writeText(text);
      alert(`Copied to clipboard:\n${text}`);
    } catch (err) {
      console.error('Failed to copy:', err);
      alert('Copy failed. Your browser may not support this feature.');
    }
  }

  /**
   * Syncs color picker change back to text input and clears validation warning
   */
  function handlePickerInput() {
    colorInput = pickerColor;
    validationResult = null;
  }

  /**
   * Exports colorsList as JSON to the clipboard
   */
  function exportPalette() {
    const exportedData = colorsList.map(({ name, hex, rgbString }) => ({
      name,
      hex,
      rgbString
    }));
    const jsonString = JSON.stringify(exportedData, null, 2);
    copyToClipboard(jsonString);
  }

  /**
   * Converts RGB to HSL object
   */
  function rgbToHsl(r, g, b) {
    r /= 255;
    g /= 255;
    b /= 255;

    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);
    let h, s, l = (max + min) / 2;

    if (max === min) {
      h = s = 0;
    } else {
      const d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

      switch (max) {
        case r: h = (g - b) / d + (g < b ? 6 : 0); break;
        case g: h = (b - r) / d + 2; break;
        case b: h = (r - g) / d + 4; break;
      }

      h /= 6;
    }

    return {
      h: Math.round(h * 360),
      s: Math.round(s * 100),
      l: Math.round(l * 100)
    };
  }

  /**
   * Formats RGB to HSL string representation
   */
  function rgbToHslString(r, g, b) {
    const hsl = rgbToHsl(r, g, b);
    return `hsl(${hsl.h}, ${hsl.s}%, ${hsl.l}%)`;
  }

  /**
   * Calculates the complementary (inverted) color in Hex format
   */
  function getComplementaryColor(hex) {
    const rgb = hexToRgb(hex);
    if (!rgb) return '#000000';
    const compR = 255 - rgb.r;
    const compG = 255 - rgb.g;
    const compB = 255 - rgb.b;
    const rHex = compR.toString(16).padStart(2, '0').toUpperCase();
    const gHex = compG.toString(16).padStart(2, '0').toUpperCase();
    const bHex = compB.toString(16).padStart(2, '0').toUpperCase();
    return `#${rHex}${gHex}${bHex}`;
  }

  /**
   * Applies the complementary color to the input and re-validates
   */
  function applyComplementary() {
    if (validationResult && validationResult.valid) {
      const compColor = getComplementaryColor(validationResult.color);
      colorInput = compColor;
      validateColor();
    }
  }

</script>

<!-- ==================== STYLES ==================== -->
<style>
  .container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  }

  .header {
    text-align: center;
    margin-bottom: 2rem;
  }

  .header h1 {
    font-size: 2.5rem;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 0.5rem;
  }

  .header p {
    color: #666;
    font-size: 1.1rem;
  }

  .input-section {
    background: #f8f9fa;
    padding: 2rem;
    border-radius: 12px;
    margin-bottom: 2rem;
  }

  .input-form {
    display: flex;
    gap: 1rem;
    align-items: center;
    margin-bottom: 1rem;
  }

  .color-preview {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    border: 3px solid #ddd;
    flex-shrink: 0;
    transition: all 0.2s;
  }

  input[type="color"] {
    -webkit-appearance: none;
    border: 3px solid #ddd;
    border-radius: 8px;
    width: 60px;
    height: 60px;
    cursor: pointer;
    padding: 0;
    background: none;
    flex-shrink: 0;
    box-sizing: border-box;
    transition: all 0.2s;
  }

  input[type="color"]::-webkit-color-swatch-wrapper {
    padding: 0;
  }

  input[type="color"]::-webkit-color-swatch {
    border: none;
    border-radius: 5px;
  }

  input[type="color"]:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }

  input[type="text"] {
    flex: 1;
    padding: 12px 16px;
    font-size: 1.1rem;
    font-family: 'Courier New', monospace;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    transition: border-color 0.2s;
  }

  input[type="text"]:focus {
    outline: none;
    border-color: #667eea;
  }

  .btn {
    padding: 12px 24px;
    border: none;
    border-radius: 8px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
  }

  .btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  }

  .btn-primary {
    background: #667eea;
    color: white;
  }

  .btn-secondary {
    background: #e53e3e;
    color: white;
  }

  .btn-success {
    background: #48bb78;
    color: white;
  }

  .btn-info {
    background: #00bcd4;
    color: white;
  }

  .validation-result {
    padding: 1rem;
    border-radius: 8px;
    margin-top: 1rem;
    animation: slideIn 0.3s ease-out;
  }

  @keyframes slideIn {
    from {
      opacity: 0;
      transform: translateY(-10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .validation-result.valid {
    background: #d4edda;
    border: 2px solid #28a745;
  }

  .validation-result.invalid {
    background: #f8d7da;
    border: 2px solid #dc3545;
  }

  .validation-preview {
    display: flex;
    gap: 1rem;
    align-items: center;
    margin-top: 0.5rem;
  }

  .validation-swatch {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    border: 2px solid #333;
  }

  .validation-details {
    flex: 1;
  }

  .validation-details code {
    background: rgba(0,0,0,0.1);
    padding: 2px 6px;
    border-radius: 4px;
    font-family: 'Courier New', monospace;
  }

  .palette-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }

  .palette-actions {
    display: flex;
    gap: 0.5rem;
  }

  .palette-header h2 {
    font-size: 1.8rem;
    color: #333;
  }

  .palette-stats {
    font-size: 1rem;
    color: #666;
  }

  .color-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    gap: 1.5rem;
  }

  .color-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    transition: transform 0.2s, box-shadow 0.2s;
  }

  .color-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.15);
  }

  .color-swatch {
    height: 140px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-family: 'Courier New', monospace;
    font-size: 1.2rem;
    font-weight: bold;
    cursor: pointer;
    position: relative;
  }

  .color-swatch:hover::after {
    content: '📋 Click to copy';
    position: absolute;
    bottom: 10px;
    background: rgba(0,0,0,0.7);
    color: white;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 0.8rem;
  }

  .color-info {
    padding: 1rem;
  }

  .color-info h3 {
    margin: 0 0 0.5rem 0;
    font-size: 1rem;
    color: #333;
  }

  .color-info p {
    margin: 0.25rem 0;
    font-size: 0.9rem;
    color: #666;
    font-family: 'Courier New', monospace;
  }

  .color-actions {
    padding: 0 1rem 1rem 1rem;
  }

  .btn-delete {
    width: 100%;
    background: #e53e3e;
    color: white;
    padding: 8px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: background 0.2s;
  }

  .btn-delete:hover {
    background: #c53030;
  }

  .empty-state {
    text-align: center;
    padding: 4rem 2rem;
    color: #999;
  }

  .empty-state h3 {
    font-size: 2rem;
    margin-bottom: 1rem;
  }

  .empty-state p {
    font-size: 1.1rem;
    margin-bottom: 0.5rem;
  }
</style>

<!-- ==================== HTML TEMPLATE ==================== -->
<div class="container">

  <!-- ==================== HEADER ==================== -->
  <div class="header">
    <h1>🎨 Play With Colours</h1>
    <p>Create and manage your color palette with hex codes</p>
  </div>

  <!-- ==================== COLOR INPUT SECTION ==================== -->
  <div class="input-section">
    <!-- ✅ WORKING: Form with validation -->
    <form class="input-form" on:submit={handleSubmit}>

      <!-- ✅ WORKING: Live color preview -->
      <div
        class="color-preview"
        style="background-color: {isValidHex(colorInput) ? normalizeHex(colorInput) : '#ffffff'}"
        title="Current color preview"
      ></div>

      <!-- Color picker input synced with text input -->
      <input
        type="color"
        bind:value={pickerColor}
        on:input={handlePickerInput}
        title="Pick color"
      />

      <!-- ✅ WORKING: Text input with binding -->
      <input
        type="text"
        bind:value={colorInput}
        placeholder="Enter color (e.g., #FF5733 or F90)"
        on:input={() => validationResult = null}
      />

      <!-- ✅ WORKING: Validate button -->
      <button type="submit" class="btn btn-primary">
        Validate
      </button>
    </form>

    <!-- ✅ WORKING: Validation feedback with conditional rendering -->
    {#if validationResult}
      <div class="validation-result" class:valid={validationResult.valid} class:invalid={!validationResult.valid}>
        <p><strong>{validationResult.message}</strong></p>

        {#if validationResult.valid && validationResult.color}
          <div class="validation-preview">
            <div
              class="validation-swatch"
              style="background-color: {validationResult.color}"
            ></div>
            <div class="validation-details">
              <p><strong>HEX:</strong> <code>{validationResult.color}</code></p>
              <p><strong>RGB:</strong> <code>{validationResult.rgbString}</code></p>
              <p><strong>HSL:</strong> <code>{rgbToHslString(validationResult.rgb.r, validationResult.rgb.g, validationResult.rgb.b)}</code></p>
              <p><strong>Brightness:</strong> {((0.299 * validationResult.rgb.r + 0.587 * validationResult.rgb.g + 0.114 * validationResult.rgb.b) / 255 * 100).toFixed(0)}%</p>
            </div>
          </div>
          <div class="validation-actions" style="margin-top: 1rem; display: flex; gap: 0.5rem;">
            <button on:click={addToPalette} class="btn btn-success">
              ➕ Add to Palette
            </button>
            <button on:click={applyComplementary} class="btn btn-info" type="button">
              ☯️ Complementary Harmony
            </button>
          </div>
        {/if}
      </div>
    {/if}
  </div>

  <!-- ==================== COLOR PALETTE SECTION ==================== -->
  <!-- ✅ WORKING: Conditional rendering for palette -->
  {#if colorsList.length > 0}
    <div class="palette-section">
      <div class="palette-header">
        <div>
          <h2>My Color Palette</h2>
          <p class="palette-stats">
            <strong>{colorsList.length}</strong> {colorsList.length === 1 ? 'color' : 'colors'} in your palette
          </p>
        </div>
        <div class="palette-actions">
          <button on:click={exportPalette} class="btn btn-primary">
            📤 Export Palette
          </button>
          <button on:click={clearAll} class="btn btn-secondary">
            🗑️ Clear All
          </button>
        </div>
      </div>

      <!-- ✅ WORKING: List iteration with each block -->
      <div class="color-grid">
        {#each colorsList as color (color.id)}
          <div class="color-card">
            <!-- ✅ WORKING: Clickable color swatch -->
            <div
              class="color-swatch"
              style="background-color: {color.hex}; color: {getContrastColor(color.hex)};"
              on:click={() => copyToClipboard(color.hex)}
            >
              <span>{color.hex}</span>
            </div>

            <!-- ✅ WORKING: Color information -->
            <div class="color-info">
              <h3>{color.name}</h3>
              <p><strong>HEX:</strong> {color.hex}</p>
              <p><strong>RGB:</strong> {color.rgbString}</p>
              <p><strong>HSL:</strong> {rgbToHslString(color.rgb.r, color.rgb.g, color.rgb.b)}</p>
            </div>

            <!-- ✅ WORKING: Delete button -->
            <div class="color-actions">
              <button class="btn-delete" on:click={() => removeColor(color.id)}>
                Delete
              </button>
            </div>
          </div>
        {/each}
      </div>
    </div>
  {:else}
    <!-- ✅ WORKING: Empty state -->
    <div class="empty-state">
      <h3>🎨 No colors yet!</h3>
      <p>Start building your palette by adding a hex color code above.</p>
      <p style="margin-top: 1rem; color: #667eea;"><strong>Try these:</strong> #FF6347 • #87CEEB • #FFD700 • #98FB98</p>
    </div>
  {/if}

</div>

<!-- TODO 1-3: Add an <input type="color"> in the input form, two-way-sync it
     with the text input (so editing either one updates the other when the
     hex is valid), and add an Export button that copies a JSON snapshot of
     colorsList to the clipboard.
     Verify: see the README's Verify checklist. -->


