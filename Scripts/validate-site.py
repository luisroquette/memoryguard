#!/usr/bin/env python3
from html.parser import HTMLParser
from pathlib import Path


class SiteParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.h1_count = 0
        self.ids = []
        self.references = []

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if tag == "h1":
            self.h1_count += 1
        if "id" in attributes:
            self.ids.append(attributes["id"])
        for key in ("href", "src"):
            if key in attributes:
                self.references.append(attributes[key])


root = Path(__file__).resolve().parents[1]
docs = root / "docs"
html = (docs / "index.html").read_text(encoding="utf-8")
parser = SiteParser()
parser.feed(html)

assert parser.h1_count == 1, f"expected exactly one H1, found {parser.h1_count}"
assert len(parser.ids) == len(set(parser.ids)), "duplicate HTML ids found"
assert 'data-pressure-lab' in html, "pressure lab is missing"
assert html.count('data-lab-state=') == 3, "pressure lab must expose three states"
assert 'aria-live="polite"' in html, "interactive decision state must be announced"

missing = []
for reference in parser.references:
    if reference.startswith(("http://", "https://", "#", "mailto:")):
        continue
    target = docs / reference.split("?", 1)[0].split("#", 1)[0]
    if not target.exists():
        missing.append(reference)

assert not missing, f"missing local site assets: {missing}"
print(f"Site validation passed: 1 H1, {len(parser.ids)} unique IDs, 0 missing assets, pressure lab present")
