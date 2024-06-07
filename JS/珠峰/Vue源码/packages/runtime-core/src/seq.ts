export default function getSequence(arr) {
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
