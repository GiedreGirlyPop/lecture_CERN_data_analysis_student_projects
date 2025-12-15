
import pandas as pd
from collections import Counter

# 1. LOAD DATA
# Make sure foruni.xlsx is in the SAME folder as this script
df = pd.read_excel("finalproject_data.xlsx")

print(df.head())

# 2. DATA CLEANING
numeric_columns = [
    "platform count",
    "moving count",
    "danger",
    "Enemy count"
]

for col in numeric_columns:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# 3. CALCULATE AVERAGES
avg_platform = int(df["platform count"].mean())
avg_moving = int(df["moving count"].mean())
avg_danger = int(df["danger"].mean())
avg_enemy = int(df["Enemy count"].mean())

# 4. FIND POSITION COLUMNS
position_columns = [
    col for col in df.columns
    if str(col).lower().startswith("positions") or str(col).startswith("Unnamed")
]

# Flatten values into one list
all_positions = df[position_columns].values.flatten()

# Remove empty values
all_positions = [
    p for p in all_positions
    if pd.notna(p) and str(p).strip() != ""
]

# Count frequency
position_counts = Counter(all_positions)

# Use avg_platform as number of top positions
most_common_positions = position_counts.most_common(avg_platform)

# 5. OUTPUT RESULTS
print("===== AVERAGES =====")
print(f"Average platform count: {avg_platform}")
print(f"Average moving count: {avg_moving:.2f}")
print(f"Average danger count: {avg_danger:.2f}")
print(f"Average enemy count: {avg_enemy:.2f}")

print("\n===== MOST COMMON POSITIONS =====")
for position, count in most_common_positions:
    print(f"{position}: {count}")
