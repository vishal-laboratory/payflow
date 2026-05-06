#!/usr/bin/env python3
"""
PayFlow Logo PNG Generator
This script converts the PayFlow SVG logo to PNG format suitable for splash screens and app icons.
"""

import subprocess
import os
from pathlib import Path

def generate_png_from_svg():
    """Generate PNG from SVG using ImageMagick or similar tools."""
    
    assets_dir = Path(__file__).parent / "assets"
    svg_file = assets_dir / "payflow_logo.svg"
    png_file = assets_dir / "payflow_logo.png"
    
    if not svg_file.exists():
        print(f"Error: SVG file not found at {svg_file}")
        return False
    
    try:
        # Try using ImageMagick (convert or magick)
        cmd = ["convert", str(svg_file), "-background", "white", "-gravity", "center", "-extent", "512x512", str(png_file)]
        subprocess.run(cmd, check=True)
        print(f"✓ PNG generated successfully at {png_file}")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        try:
            # Try using ffmpeg as fallback
            cmd = ["ffmpeg", "-i", str(svg_file), str(png_file)]
            subprocess.run(cmd, check=True)
            print(f"✓ PNG generated successfully at {png_file}")
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            print("Error: ImageMagick or ffmpeg not found. Please install one of them:")
            print("  Windows: choco install imagemagick")
            print("  macOS: brew install imagemagick")
            print("  Linux: sudo apt-get install imagemagick")
            return False

if __name__ == "__main__":
    print("PayFlow Logo Generator")
    print("-" * 40)
    generate_png_from_svg()
