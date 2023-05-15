import os


# 读取benchmark_dir中目录信息
def readTxt():
    dir_list = []
    try:
        with open('utilities/benchmark_dir_omp', 'r') as f:
            # 按照行读取
            for line in f.readlines():
                # 去除行尾的\n
                dir = line.strip().split(",")
                dir_list.append(dir)
    except:
        pass
    return dir_list


# 进入目录中，执行相应的命令
def execute_command(dir_list):
    myPWD = os.popen('pwd').read().strip()
    for dir in dir_list:
        os.chdir(dir[0])  # 进入相应的目录
        general_arg = " -I. -I" + myPWD + "/utilities -I" + myPWD + "/utilities/polybench.c"
        time_list = []
        for i in range(5):
            time_list.append(float(os.popen('./' + dir[1]).read().strip()))
        mn, mx = min(time_list), max(time_list)
        time_list.remove(mn)
        time_list.remove(mx)
        print("  ")
        print(dir[1] + " times:" )
        print(avg(time_list))
        # 返回到原来得目录
        os.chdir(myPWD)


def avg(list):
    sum = 0
    for item in list:
        sum += item
    return sum/len(list)



if __name__ == '__main__':
    dir_list = readTxt()
    print("Compile & Run on DCU ")
    execute_command(dir_list)
