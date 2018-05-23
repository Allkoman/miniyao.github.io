---
title: Algorithm
toc: 1
top: 998
date: 2017-05-09 17:03:58
tags:
- 算法
categories:
- 随笔
permalink:
---
**原因**：2017年5月9日 星期二
**说明**：思想

<!-- more -->

# 排序算法
- 为什么要学习O(n^2)的排序算法？
- 基础
- 编码简单，易于实现，是一些简单情景的首选
- 在一些特殊情况下，简单的排序算法更有效
- 简单的排序算法思想衍生出复杂的排序算法
- 排序算法总结一览：

| 排序方法 | 平均情况           | 最好情况     | 最坏情况     | 辅助空间          | 稳定性  |
| :--- | :------------- | :------- | :------- | :------------ | :--- |
| 冒泡排序 | O(n²)          | O(nlogn) | O(n²)    | O(1)          | 稳定   |
| 简单选择 | O(n²)          | O(n²)    | O(n²)    | O(1)          | 稳定   |
| 直接插入 | O(n²)          | O(n)     | O(n²)    | O(1)          | 稳定   |
| 希尔排序 | O(nlogn)~O(n²) | O(n^1.3) | O(n²)    | O(1)          | 不稳定  |
| 堆排序  | O(nlogn)       | O(nlogn) | O(nlogn) | O(1)          | 不稳定  |
| 归并排序 | O(nlogn)       | O(nlogn) | O(nlogn) | O(n)          | 不稳定  |
| 快速排序 | O(nlogn)       | O(nlogn) | O(n²)    | O(nlogn)~O(n) | 不稳定  |

## 选择排序

- 我的理解：每一轮外层循环中针对第i个位置选择出最值，将最值与第i位置的元素交换，完成排序。
- 简单选择排序（直接选择排序;基本思想：数组分成有序区和无序区，初始时整个数组都是无序区，然后每次从无序区选一个最小的元素直接放到有序区的最后，重复这样的操作，直到整个数组变成有序区。
- Python代码实现：

```
def findSmallest(arr):
    smallest = arr[0]
    smallest_index = 0
    for i in range(1,len(arr)):
        if arr[i] < smallest:
            smallest = arr[i]
            smallest_index = i
    return smallest_index


def selectSort(arr):
    newArr = []
    for i in range(len(arr)):
        smallest_index = findSmallest(arr)
        newArr.append(arr.pop(smallest_index))
    return newArr

print selectSort([5,3,6,2,10])
```

- java选择排序代码片段：

```java
public static void sort(Comparable[] arr) {
     for (int i = 0; i < arr.length; i++) {
        int minIndex = i;
         for (int j = i + 1; j < arr.length; j++) {
              if (arr[j].compareTo(arr[minIndex]) < 0)
                 minIndex = j;
          }
          swap(arr, i, minIndex);
    }
 }
```
- java泛型代码思想：数组arr[0...n]每一轮外层循环依次找出对应i位置的最小值并替换。
- [选择排序java源码地址](https://github.com/Allkoman/Algorithm/tree/master/Java/src/pers/algorithm/selectionsort)

## 随机生成算法测试用例
- 能够生成近乎接近排序的数组以及随机数组，并有测试是否排序成功的测试功能。
- [SortTestHelper源码地址](https://github.com/Allkoman/Algorithm/blob/master/Java/src/pers/algorithm/selectionsort2/SelectionSort.java)


## 插入排序
- 我的理解：从数组的第二个元素开始，每个元素和前面的所有元素进行大小对比，只要比当前元素大就进行替换（小值前移）,缺点很明显，在for循环内进行比较的同时不停地swap操作会有大量的时间开销。可以进行改进。
- 改进前java插入排序代码片段：

```java
    public static void sort(Comparable[] arr) {
        for (int i = 1; i < arr.length; i++) {
            for (int j = i; j > 0; j--) {
                if (arr[j].compareTo(arr[j-1]) < 0)
                    swap(arr, j, j-1);
                else
                    break;
            }
        }
    }
```
- 改进思想：将我要进行插入的数据提取出来，前序数据依次和其对比，比它大的元素后移即可，最后的位置插入，这样可以避免大量使用swap赋值操作，改进效果很显著。

```java
    public static void sort(Comparable[] arr) {
        for (int i = 1; i < arr.length; i++) {
            Comparable e = arr[i];
            int j;
            for (j = i; j > 0 && arr[j - 1].compareTo(e) > 0; j--)
                arr[j] = arr[j - 1];
            arr[j] = e;
        }
    }
```
[基本插入排序java源码地址](https://github.com/Allkoman/Algorithm/tree/master/Java/src/pers/algorithm/insertionsort/InsertionSort.java)
[改进插入排序java源码地址](https://github.com/Allkoman/Algorithm/blob/master/Java/src/pers/algorithm/insertionsort/InsertionSortImp.java)

# 高级排序算法
# 堆和堆排序
## 为什么要使用堆
- 优先队列；动态数据；
- 优先队列实现开销：
  ![](http://okj8snz5g.bkt.clouddn.com/blog/Screen%20Shot%202017-05-25%20at%2005.19.07.png)

## 堆的基本实现
- 二叉堆(Binary Heap)：某个节点的值总是不大于父节点的值，并且是一颗完全二叉树（最大堆）（完全二叉树指：只有最下面的一层结点度能够小于2，并且最下面一层的结点都集中在该层最左边的若干位置的二叉树）。

![](http://okj8snz5g.bkt.clouddn.com/blog/Screen%20Shot%202017-05-25%20at%2014.04.16.png)
- java构建一个空堆：
```
public class MaxHeap<Item> {
    private Item[] data;
    private int count;

    // 构造函数, 构造一个空堆, 可容纳capacity个元素
    private MaxHeap(int capacity) {
        data = (Item[]) new Object[capacity + 1];
        count = 0;
    }

    // 返回堆中的元素
    public int size() {
        return count;
    }

    // 返回一个布尔值, 表示堆中是否为空
    public boolean isEmpty() {
        return count == 0;
    }

    //测试MaxHeap
    public static void main(String[] args) {
        MaxHeap<Integer> maxHeap = new MaxHeap<Integer>(100);
        System.out.println(maxHeap.size());
    }
}
```

## ShiftUp
- 新加入元素放置到数组末尾，将其与父节点进行大小比较，最后实现ShiftUp
- 代码片段：

```java
    //插入元素
    public void insert(Item item) {
        assert count + 1 <= capacity;
        data[count + 1] = item;
        count++;
        shiftUp(count);
    }
```

```java
    private void shiftUp(int k) {
        while (k > 1 && data[k / 2].compareTo(data[k]) < 0) {
            swap(k, k / 2);
            k /= 2;
        }
    }
```

## ShiftDown
- shiftDown判断是否有右孩子，右是否大于左，j所在是否比k的data大

```java
    public Item extractMax() {
        assert count > 0;
        Item ret = data[1];

        swap(1, count);
        count--;

        shiftDown(1);

        return ret;
    }
```

```java
    private void shiftDown(int k) {
        while (2 * k <= count) {
            int j = 2 * k;  //此轮循环中data[k]与data[j]交换位置
            if (j + 1 <= count && data[j + 1].compareTo(data[j]) > 0)
                j++;
            if (data[j].compareTo(data[k]) <= 0)
                break;

            swap(j, k);
            k = j;
        }
    }
```

- 这样就可以将一个数组顺序insert，extractMax后即为基础版的HeapSort：
- [HeapSort1源码Java版](https://github.com/Allkoman/Algorithm/blob/master/Java/src/pers/heap/HeapSort1.java)

## Heapfify
- 对于一个完全二叉树来说，第一个非叶子节点的索引是元素个数/2得到的索引
- 从第一个非叶子节点开始考察，进行shiftDown。 

![](http://okj8snz5g.bkt.clouddn.com/blog/Screen%20Shot%202017-05-25%20at%2020.26.08.png)

- 与第一种排序算法不同的是，上述MaxHeap构建堆后，将数组数据一个一个insert后再extra出来，而第二种方式直接在插入数组数据的同时从count/2的节点开始构建了堆。


```java
    public MaxHeap(int capacity) {
        data = (Item[]) new Comparable[capacity + 1];
        count = 0;
        this.capacity = capacity;
    }
```

```java
    public MaxHeap(Item[] arr) {
        int n = arr.length;
        data = (Item[]) new Comparable[n + 1];
        capacity = n;
        for (int i = 0; i < n; i++)
            data[i + 1] = arr[i];
        count = n;
        for (int i = count / 2; i >= 1; i--)
            shiftDown(i);
    }
```

## 优化堆排序
- 原地堆排序，头尾交换，shiftDown。
- 不需要格外空间，空间复杂度O(1)

![](http://okj8snz5g.bkt.clouddn.com/blog/Screen%20Shot%202017-05-25%20at%2020.34.18.png)

- 最后一个非叶子节点的索引为`(count-1)/2`




# 二分搜索树
## 二分查找

## 二分搜索树
- 查找表的实现，键值对，字典数据结构，使用二分搜索树

![](http://okj8snz5g.bkt.clouddn.com/blog/Screen%20Shot%202017-05-26%20at%2003.00.39.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/Screen%20Shot%202017-05-26%20at%2003.01.21.png)
- 天然的含有递归功能

