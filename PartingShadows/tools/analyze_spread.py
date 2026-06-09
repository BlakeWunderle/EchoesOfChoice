import json, sys, os
from collections import defaultdict

# Ultimate unlock progression thresholds by story
ULT_PROG = {1: 12, 2: 14, 3: 11}

# T2 classes (34 total) grouped by base tree
CLASS_ORDER = [
    "Knight", "Paladin", "DarkKnight",
    "Cavalry", "Dragoon", "Lancer",
    "Wizard", "Sage", "Warlock",
    "Chronomancer", "Illusionist", "Enchanter",
    "Bard", "Dancer", "Acrobat",
    "Mime", "Puppeteer", "Jester",
    "Automaton", "Alchemist", "Gunslinger",
    "Gadgeteer", "Inventor", "Saboteur",
    "Berserker", "Shapeshifter", "Beastmaster",
    "Warcrier", "Shaman", "Druid",
    "Sentinel", "Monk", "Ninja",
    "Falconer",
]

def analyze(story_num, data):
    ult_prog = ULT_PROG[story_num]
    pre = defaultdict(lambda: {"wins": 0, "total": 0})
    post = defaultdict(lambda: {"wins": 0, "total": 0})

    for stage in data["stages"]:
        prog = int(stage["progression_stage"])
        cb = stage.get("class_breakdown", {})
        bucket = post if prog >= ult_prog else pre
        for cls, stats in cb.items():
            bucket[cls]["wins"] += stats.get("wins", 0)
            bucket[cls]["total"] += stats.get("total", 0)

    return pre, post

def print_table(label, bucket):
    print(f"\n{'='*60}")
    print(f"  {label}")
    print(f"{'='*60}")

    rows = []
    for cls in bucket:
        if bucket[cls]["total"] > 0:
            wr = bucket[cls]["wins"] / bucket[cls]["total"] * 100
            n = bucket[cls]["total"]
            rows.append((cls, wr, n))

    if not rows:
        print("  (no data)")
        return

    wrs = [r[1] for r in rows]
    avg_wr = sum(wrs) / len(wrs)

    print(f"  {'Class':<18} {'WR':>7} {'Sims':>8}  {'vs Avg':>7}")
    print(f"  {'-'*18} {'-'*7} {'-'*8}  {'-'*7}")

    for cls, wr, n in sorted(rows, key=lambda x: -x[1]):
        delta = wr - avg_wr
        flag = " **" if abs(delta) > 5 else ""
        print(f"  {cls:<18} {wr:6.1f}% {n:>8}  {delta:+5.1f}pp{flag}")

    print(f"  {'-'*18} {'-'*7} {'-'*8}  {'-'*7}")
    print(f"  {'AVERAGE':<18} {avg_wr:6.1f}%")
    spread = max(wrs) - min(wrs)
    print(f"  Spread (max-min): {spread:.1f}pp")

script_dir = os.path.dirname(os.path.abspath(__file__))
project_dir = os.path.dirname(script_dir)

results = {}
for s in [1, 2, 3]:
    path = os.path.join(project_dir, f"spread_s{s}.json")
    if os.path.exists(path):
        with open(path) as f:
            data = json.load(f)
        results[s] = data

if not results:
    print("No result files found yet.")
    sys.exit(1)

for s in sorted(results.keys()):
    pre, post = analyze(s, results[s])
    print_table(f"Story {s} - PRE-ULTIMATE (prog < {ULT_PROG[s]})", pre)
    print_table(f"Story {s} - POST-ULTIMATE (prog >= {ULT_PROG[s]})", post)

# Cross-story aggregate
print("\n" + "#"*60)
print("  CROSS-STORY AGGREGATE")
print("#"*60)

agg_pre = defaultdict(lambda: {"wins": 0, "total": 0})
agg_post = defaultdict(lambda: {"wins": 0, "total": 0})

for s in sorted(results.keys()):
    pre, post = analyze(s, results[s])
    for cls in pre:
        agg_pre[cls]["wins"] += pre[cls]["wins"]
        agg_pre[cls]["total"] += pre[cls]["total"]
    for cls in post:
        agg_post[cls]["wins"] += post[cls]["wins"]
        agg_post[cls]["total"] += post[cls]["total"]

print_table("ALL STORIES - PRE-ULTIMATE", agg_pre)
print_table("ALL STORIES - POST-ULTIMATE", agg_post)
