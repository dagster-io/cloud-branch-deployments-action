import json, os

with open("json_env", mode="w") as f:
    for k, v in json.loads(os.getenv("INPUT_LOCATION")).items():
        f.write(f"LOCATION_{k.upper()}={v}\n")
print("json_env")
