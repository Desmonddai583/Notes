# 用户输入一个十进制正整数数字
#   判断是几位数
#   打印每一位数字及其重复的次数
#   依次打印每一位数字，顺序个、十、百、千、万...位

num = ''
# 数字输入的简单判断
while True:
    num = input('Input a positive number >>> ').strip().lstrip('0')
    if num.isdigit():
        break

print("The length of {} is {}.".format(num, len(num)))

# 倒序打印1
for i in range(len(num), 0, -1):
    print(num[i-1], end=' ')
print()

# 倒序打印2
for i in reversed(num):
    print(i, end=' ')
print()

# 倒序打印3 负索引
for i in range(len(num)):
    print(num[-i-1], end=' ')
print()

for i in range(-1, -len(num)-1, -1):
    print(num[i], end=' ')
print()
print('-' * 30)

print(num[::-1])

# 判断0-9的数字在字符串中出现的次数
# 1 每一次迭代都是用count，都是O(n)问题
counter = [0] * 10
for i in range(10): # 10 * n
    counter[i] = num.count(str(i))
    if counter[i]:
        print("The count of {} is {}".format(i, counter[i]))

# 2 使用count，迭代字符串本身
counter = [0] * 10
# unique(n) * n
# 1111 时间复杂度就是O(n)
# 1234 时间复杂度就是O(4n)
for x in num:
    i = int(x)
    if counter[i] == 0:
        counter[i] = num.count(x)
        print("The count of {} is {}".format(i, counter[i]))

# 3 迭代自身每一个字符
counter = [0] * 10
for x in num: # O(n)
    i = int(x)
    counter[i] += 1

for i in range(len(counter)):
    if counter[i]:
        print("The count of {} is {}".format(i, counter[i]))

        

# 判断数字位数并排序打印
#   输入5个十进制正整数数字，打印每个数字的位数，将这些数字排序打印，要求升序打印

nums = []
while len(nums) < 5:
    num = input("Please input a number:").strip().lstrip('0')
    if not num.isdigit():
        continue
    print('The length of {} is {}'.format(num, len(num)))
    nums.append(int(num))
print(nums)

# sort方法排序
lst = nums.copy()
lst.sort() # 就地修改
print(lst)

# 冒泡法
for i in range(len(nums)):
    flag = False
    for j in range(len(nums)-i-1):
        if nums[j] > nums[j+1]:
            tmp = nums[j]
            nums[j] = nums[j+1]
            nums[j+1] = tmp
            flag = True
    if not flag:
        break
print(nums)