// c d e       2,3,4
// e c d h     4,2,3,0  // 0 表示以前不存在 



// [c,d]
// [0,1] // 通过上面的两个序列，可以求出来，最终这样的结果，就可以保证某些元素不用移动


// 需要求，连续性最强的子序列 
// 贪心算法  +  二分查找

// 2 2 3 7 6

// 2 2 3 6
// 2 2 3 7

// 数
// 2 3 1 5 6 8 7 9 4 2 -> 最长递增子序列的个数是多少个

// 2  (2的前一个是null)
// 2 3 (3的前一个是2)
// 1 3 (1的前一个是null)
// 1 3 5 (5的前一个是3)
// 1 3 5 6 (6的前一个是5)
// 1 3 5 6 8 (8的前一个是6)
// 1 3 5 6 7 (7的前一个是6)
// 1 3 5 6 7 9 (9的前一个是7)
// 1 3 4 6 7 9 (4的前一个就是3)
// 1 2  4 6 7 9 (2的前一个是1)

// 树 的前驱节点



// 9 7 6  5 3  2


// 找更有潜力的 


// 2 3 7 8
// 2 3 8 9

// 组件的渲染



// 实现最长递增子序列

function getSequence(arr) {
    const result = [0];
    const p = result.slice(0); // 用于存放索引的
    let start;
    let end;
    let middle;
    const len = arr.length; // 数组长度
    for (let i = 0; i < len; i++) {
      const arrI = arr[i];
      if (arrI !== 0) {
        // 为了vue3 而处理掉数组中 0 的情况  [5,3,4,0]
        // 拿出结果集对应的的最后一项，和我当前的这一项来作比对
        let resultLastIndex = result[result.length - 1];
        if (arr[resultLastIndex] < arrI) {
          p[i] = result[result.length - 1]; // 正常放入的时候，前一个节点索引就是result中的最后一个
          result.push(i); // 直接将当前的索引放入到结果集即可

          continue;
        }
      }
      start = 0;
      end = result.length - 1;

      while (start < end) {
        middle = ((start + end) / 2) | 0;
        if (arr[result[middle]] < arrI) {
          start = middle + 1;
        } else {
          end = middle;
        }
      }
      if (arrI < arr[result[start]]) {
        p[i] = result[start - 1]; // 找到的那个节点的前一个
        result[start] = i;
      }
    }

    // p 为前驱节点的列表，需要根据最后一个节点做追溯
    let l = result.length;
    let last = result[l - 1]; // 取出最后一项
    while (l-- > 0) {
      // 倒序向前找，因为p的列表是前驱节点
      result[l] = last;
      last = p[last]; // 在数组中找到最后一个
    }
    // 需要创建一个 前驱节点，进行倒序追溯 （因为最后一项，可到是不会错的）
    return result;
  }

// [1,2,3,4,5,8,9,10] // 6   -> 4   -> 8

// [0,1,2,3,4,5]
console.log(getSequence([1,2,3,4,5,8,9,10,6] ));

// 2
// 2 3
// 1 3 
