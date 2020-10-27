// set和map 数组的去重

// set唯一的功能
let set = new Set([1,2,3,4,5,5,4,3,2,1]);
set.add('100');
set.delete(2);
console.log(set.has(1));
console.log(set);
// set只能放单个

// map可以放键值对 {key:value}
let map = new Map();
map.set('js',[1,2,3]);
map.set('js',[4,5,6]);
console.log(map.has('js'));
console.log(map);