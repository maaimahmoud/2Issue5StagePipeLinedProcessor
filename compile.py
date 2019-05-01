import os
out = os.popen('compile.bat').read()
res = ""
lines = out.splitlines(True)
for line in lines:
    line = line.strip()
    if ( line[0:9] == "Errors: 0"):
        continue
    if (line[0:2] == "**"):#line[0:4] == "vcom" or 
        res += line + "\n"
    if (line[0:6] == "Errors"):
        res += line + "\n\n"

print(res)