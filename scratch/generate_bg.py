from PIL import Image
import math

width = 1080
height = 2400

# Center of the radial gradient (-0.8, -0.6) mapped to width and height
# Alignment(-1, -1) is top left, Alignment(0,0) is center, Alignment(1,1) is bottom right
# -0.8 means 10% from left
# -0.6 means 20% from top
cx = int(width * (1 - 0.8) / 2) # Wait: Alignment is from -1 to 1.
# Formula: x = (Alignment.x + 1) / 2 * width
cx = int(( -0.8 + 1 ) / 2 * width)
cy = int(( -0.6 + 1 ) / 2 * height)

# Radius 1.5 in Flutter Alignment means 1.5 * shortest_side / 2
# Actually in RadialGradient, radius 1.0 means it touches the shortest edge.
radius = 1.5 * min(width, height) / 2

# Colors
color_center = (30, 36, 51) # 0xFF1E2433
color_edge = (15, 17, 26)   # 0xFF0F111A

img = Image.new('RGB', (width, height))
pixels = img.load()

def lerp(c1, c2, t):
    return int(c1 + (c2 - c1) * t)

for y in range(height):
    for x in range(width):
        dist = math.sqrt((x - cx)**2 + (y - cy)**2)
        t = dist / radius
        if t > 1.0:
            t = 1.0
        
        r = lerp(color_center[0], color_edge[0], t)
        g = lerp(color_center[1], color_edge[1], t)
        b = lerp(color_center[2], color_edge[2], t)
        
        pixels[x, y] = (r, g, b)

img.save('assets/images/splash_bg.png')
