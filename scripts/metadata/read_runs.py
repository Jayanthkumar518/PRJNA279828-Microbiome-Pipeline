#!/usr/bin/env python3

import pandas as pd

df = pd.read_csv("data/metadata/SraRunTable.csv")

for run in df["Run"]:
    print(run)