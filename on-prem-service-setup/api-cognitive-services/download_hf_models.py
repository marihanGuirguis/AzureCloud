# === Download HF models ===
from transformers import pipeline

text = ["Hello world!"]

pipe = pipeline("text-classification", model="papluca/xlm-roberta-base-language-detection")
print(pipe(text, top_k=1, truncation=True))
# ===