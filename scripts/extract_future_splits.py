import re
import os

files_to_parse = [
    'Developement/Task2_Archived.md',
    'Developement/Task1_Engineered.md'
]

results = []

for filepath in files_to_parse:
    if not os.path.exists(filepath):
        continue
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Split by task headings
    tasks = re.split(r'\n###\s+', content)
    for task in tasks[1:]: # skip the first block before any heading
        # Extract title
        title_match = re.search(r'^(.*)', task)
        title = title_match.group(1).replace('[x]', '').replace('[ ]', '').strip() if title_match else "Unknown Task"
        
        # Extract Future split guidance
        # Sometimes it's "**Future split guidance:**" or "**Future split guidance**:"
        guidance_match = re.search(r'\*\*Future split guidance:?\*\*\s*(.*?)(?=\n\*\*|$)', task, re.DOTALL)
        if guidance_match:
            guidance = guidance_match.group(1).strip()
            # If the guidance is not empty or "N/A"
            if guidance and "none expected" not in guidance.lower():
                results.append((title, guidance))

import json
print(json.dumps(results, indent=2))
