#!/usr/bin/env python3
"""Cloud-side STL export (old OpenSCAD 2021 here, no Manifold).
Walls are exported layer by layer (each layer is a single linear_extrude -> instant)
and the layers are concatenated into one STL. Same geometry as the master file;
the slicer treats the touching layers as one solid.
Usage: cloud_export.py [filter-substring ...]
"""
import subprocess, sys, os, re
from concurrent.futures import ThreadPoolExecutor

SCAD = "/home/claude/scad"
OUT = "/home/claude/stl_out"
FOLDER = {"P1S": "Bambu P1S", "GIGA": "Large Format"}
filters = sys.argv[1:]

def osc(args, out):
    r = subprocess.run(["openscad", "-o", out] + args, capture_output=True, text=True)
    return r.returncode == 0 and os.path.exists(out)

def parts(printer):
    r = subprocess.run(["openscad", "-o", "/tmp/list.csg", "-D", f'PRINTER="{printer}"', "-D", "LIST=true",
                        f"{SCAD}/Janesville_Station.scad"], capture_output=True, text=True)
    return [(m.group(1), int(m.group(2))) for m in re.finditer(r'PART\|([^|]+)\|(\d+)', r.stderr)]

def merge(files, out):
    with open(out, "w") as o:
        o.write("solid janesville\n")
        for f in files:
            for line in open(f):
                if not line.startswith(("solid", "endsolid")):
                    o.write(line)
        o.write("endsolid janesville\n")

ROOF_LAYERS = {}
def roof_layers(printer):
    if printer not in ROOF_LAYERS:
        r = subprocess.run(["openscad", "-o", "/tmp/rl.csg", "-D", f'PRINTER="{printer}"', "-D", "LIST=true",
                            f"{SCAD}/Roof/roofs.scad"], capture_output=True, text=True)
        ROOF_LAYERS[printer] = {m.group(1): int(m.group(3)) for m in re.finditer(r'RPART\|([^|]+)\|(\d+)\|(\d+)', r.stderr)}
    return ROOF_LAYERS[printer]

def job(printer, name, tile):
    group = name.split("_")[0]
    d = f"{OUT}/{FOLDER[printer]}/{group}"; os.makedirs(d, exist_ok=True)
    final = f"{d}/{name}_{printer}_part{tile + 1:02d}.stl"
    P = ["-D", f'PRINTER="{printer}"']
    RL = roof_layers(printer)
    if name in RL:
        layers = []
        for k in range(RL[name]):
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f'PART="{name}"', "-D", f"TILE={tile}", "-D", f"LAYER={k}", f"{SCAD}/Roof/roofs.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Canopy_"):
        layers = []
        for k in range(2 if name.startswith("Canopy_roof_") else 1):
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f'PART="{name}"', "-D", f"TILE={tile}", "-D", f"LAYER={k}", f"{SCAD}/Canopy/canopy.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Platform") or name == "Coach_body":
        if name == "Coach_body":
            r = subprocess.run(["openscad", "-o", "/tmp/kl.csg"] + P + ["-D", "LIST=true", f"{SCAD}/Rolling Stock/coach_1948.scad"], capture_output=True, text=True)
            ks = range(int(re.search(r'KPART\|Coach_body\|\d+\|(\d+)', r.stderr).group(1))); src = f"{SCAD}/Rolling Stock/coach_1948.scad"
        else:
            ks = [2] if name.endswith("_mortar") else [0, 1]; src = f"{SCAD}/Platform/platform.scad"
        layers = []
        for k in ks:
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f"TILE={tile}", "-D", f"LAYER={k}", src], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Track_"):
        ks = {"Track_ballast": [0, 1], "Track_ties": [2], "Track_rails": [3, 4, 5]}[name]; layers = []
        for k in ks:
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f"TILE={tile}", "-D", f"LAYER={k}", f"{SCAD}/Track/track.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Liner_"):
        lid = name[6:]; ks = [0, 1]
        if lid.endswith("_pine"): lid, ks = lid[:-5], [2, 3, 4]
        layers = []
        for k in ks:
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f'LINER="{lid}"', "-D", f"TILE={tile}", "-D", f"LAYER={k}", f"{SCAD}/Walls/wall_liners.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Floor_"):
        rm = name[6:]; ks = [0, 1]
        if rm.endswith("_dark"): rm, ks = rm[:-5], [2]
        layers = []
        for k in ks:
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f'PART="{rm}"', "-D", f"TILE={tile}", "-D", f"LAYER={k}", f"{SCAD}/Furniture/interior.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith(("Furniture_", "Light_", "Ceiling_", "Electronics_")):
        ok = osc(P + ["-D", f'PART="{name}"', "-D", f"TILE={tile}", f"{SCAD}/Furniture/interior.scad"], final)
    elif name.startswith("Window_"):
        wall, idx = name[7:].rsplit("_", 1); layers = []
        for k in range(6):
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f'WIN="{wall}|{idx}"', "-D", f"LAYER={k}", f"{SCAD}/Walls/windows.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Wall_"):
        w = name[5:]; ks = range(6)
        if w.endswith("_mortar"): w, ks = w[:-7], [6, 7]
        elif w.endswith("_stone"): w, ks = w[:-6], [8]
        layers = []
        for k in ks:
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f'WALL="{w}"', "-D", f"TILE={tile}", "-D", f"LAYER={k}", f"{SCAD}/Walls/walls.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Interior_"):
        w = name[9:]; layers = []
        for k in range(4):
            tmp = f"/tmp/lay_{printer}_{name}_{tile}_{k}.stl"
            if osc(P + ["-D", f'INT="{w}"', "-D", f"TILE={tile}", "-D", f"LAYER={k}", f"{SCAD}/Walls/interior_walls.scad"], tmp):
                layers.append(tmp)
        merge(layers, final); ok = bool(layers)
        for t in layers: os.remove(t)
    elif name.startswith("Splices_Int_"):
        ok = osc(P + ["-D", f'INT="{name[12:]}"', "-D", 'VIEW="splices"', f"{SCAD}/Walls/interior_walls.scad"], final)
    elif name.startswith("Splices_"):
        ok = osc(P + ["-D", f'WALL="{name[8:]}"', "-D", 'VIEW="splices"', f"{SCAD}/Walls/walls.scad"], final)
    else:
        ok = osc(P + ["-D", f'SHOW="{name}"', "-D", f"TILE={tile}", f"{SCAD}/Janesville_Station.scad"], final)
    print(("ok   " if ok else "FAIL ") + final, flush=True)

jobs = []
for pr in ("P1S", "GIGA"):
    for name, n in parts(pr):
        if filters and not any(f in name for f in filters): continue
        for t in range(n): jobs.append((pr, name, t))
print(len(jobs), "jobs", flush=True)
with ThreadPoolExecutor(2) as ex:
    list(ex.map(lambda j: job(*j), jobs))
