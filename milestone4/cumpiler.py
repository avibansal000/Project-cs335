import os


os.system("python3 run.py")
os.system("python to86.py > test.s")
os.system("gcc test.s")
os.system("./a.out")