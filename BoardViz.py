import json
import math

import numpy as np
import matplotlib.pyplot as plt

from matplotlib.patches import RegularPolygon
from matplotlib.collections import PatchCollection
from matplotlib.colors import LinearSegmentedColormap

# calculate hex-tile position
def hex_offset(radius):
    angle = 60 * math.pi / 180
    return math.sin(angle) * radius

if __name__ == '__main__':
    # read island
    with open('complete.json') as full:
        d = json.load(full)
        island  = np.array(json.loads(d['board']))
        markers = np.array(json.loads(d['markers']))

        # calculate position of tiles
        tiles = []
        radius = 1
        half_r = radius / 2
        offset = hex_offset(radius)
        x_adj = 0.05
        y_adj = 0.08
        for i, r in enumerate(island):
            for j, t in enumerate(r):
                x_row_offset = 2-i
                if i%2 == 0:
                    x = j + offset + (offset*j) + x_row_offset*offset - x_adj*j
                    y = i + (half_r*radius*i) + radius + y_adj*i
                else:
                    x = j + offset + (offset*j) + x_row_offset*offset - x_adj*j
                    y = i + (half_r*radius*i) + radius + y_adj*i
                tile = RegularPolygon((x,y), 6, radius=radius, ec=(1,1,1,1), lw=0.1)
                tiles.append(tile)
        # create collection from tiles.
        p = PatchCollection(tiles)

        # create a color map for the island
        cmap = ['white',     # water
                'tab:orange',# desert
                'brown',     # brick
                'gold',      # grain
                'limegreen', # sheep
                '0.6',       # stone
                'darkgreen'] # lumber
        cm = LinearSegmentedColormap.from_list('catan', cmap, N=7)
        colors = []
        for t in island.flatten():
            colors.append(t-1)
        p.set_array(np.array(colors))
        p.set_cmap(cm)

        # plot
        fig, ax = plt.subplots(figsize=(7.5,5))

        # hide axes
        ax.get_xaxis().set_visible(False)
        ax.get_yaxis().set_visible(False)

        ax.add_collection(p, autolim=True)
        ax.autoscale_view()
        # origin should match the array for readability
        ax.set_ylim(ax.get_ylim()[::-1])

        # number the tiles
        for i,m in enumerate(markers.flatten()):
            if m == 1 or m == 7: continue
            ax.plot(*tiles[i].xy, 'wo', markersize=23)
            ax.annotate('%d' % m, xy=tiles[i].xy, ha='center', va='center',
                        size='large', family='serif')

        plt.show()
        output = 'optimal-island.png'
        print('Island diagram saves as "%s"' % output)
        fig.savefig(output)

