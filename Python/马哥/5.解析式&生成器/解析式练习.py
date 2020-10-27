# "0001.abadicddws" 是ID格式，要求ID格式是以点号分割，左边是4位从1开始的整数，右边是 10位随机小写英文字母。请依次生成前100个ID的列表
["{:04}.{}".format(i, "".join(random.choices(bytes(range(97,123)).decode, k=10))) for i in range(0, 101)] 

# 打印九九乘法表
[print("{}*{}={:<3}".format(j,i,i*j), end='\n' if i == j else '') for i in range(1,10) for j in range(1,i+1)]

# 有一个列表lst = [1,4,9,16,2,5,10,15]，生成一个新列表，要求新列表元素是lst相邻2项的和
lst = [1,4,9,16,2,5,10,15]
print([lst[i] + lst[i+1] for i in range(len(lst) - 1)])