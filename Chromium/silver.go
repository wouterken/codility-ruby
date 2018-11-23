package main

import "fmt"
import "sort"
import "math/rand"

type Level struct {
    height int
    from int
    to int
    paths int
    current int
}

type Levels []Level


func (l Level) String() string {
  return fmt.Sprintf("(%d %d)", l.from, l.height)
}

func (s Levels) Len() int {
    return len(s)
}

func (s Levels) Swap(i, j int) {
    s[i], s[j] = s[j], s[i]
}
func (s Levels) Less(i, j int) bool {
    return s[i].height < s[j].height
}

func WithIndices(vs []int) []Level {
    vsm := make([]Level, len(vs))
    for i, v := range vs {
        vsm[i] = Level{v,i,i,1,0}
    }
    return vsm
}

func Insert(slice []Level, index int, value Level) []Level {
    slice = slice[0 : len(slice)+1]
    copy(slice[index+1:], slice[index:])
    slice[index] = value
    return slice
}

func Remove(slice []Level, index int) []Level{
  length := len(slice)
  slice = append(slice[:index], slice[index+1:]...)
  return slice[:length - 1]
}

func FindIndex(target_map Levels, value Level) int {

  start_index := 0
  end_index := len(target_map) - 1

  for start_index <= end_index {

    median := (start_index + end_index) / 2

    if target_map[median].from < value.from {
      start_index = median + 1
    } else {
      end_index = median - 1
    }
  }

  return start_index
}

func Solution(A []int) int{
  preWithPIndices := WithIndices(A)
  // byHeight := make(map[int]Level)
  // byIndex  := make(map[int]Level)

  sort.Sort(Levels(preWithPIndices))


  withIndices := make([]Level, len(preWithPIndices))
  for i, v := range preWithPIndices {
    withIndices[i] = Level{i, v.from,v.to, 1,0}
  }

  cache  := make(Levels, 50000)
  cache = cache[0:0]

  toDelete  := make([]int, 100)
  toDelete = toDelete[0:0]

  total := 0
  step  := 0
  last  := -1
  dec   := false
  min, max := 0, 0
  for _, v := range withIndices {
    insertIndex := sort.Search(len(cache), func(i int) bool { return cache[i].from >= v.from })
    fmt.Printf("Insert %d at %d:%d\n", v.height, insertIndex, v.from)
    cache = Insert(cache, insertIndex, v)
    change := 1
    if last != -1 {
      if insertIndex <= last {
        dec = false
        min, max = insertIndex, last + 1
      } else {
        dec = true
        min, max = last, insertIndex
      }
    }
    min += 1
    var previous *Level
    for min < max {
      node   := cache[min]
      levels := v.height - node.height
      right  := node.current + node.paths * levels % 1000000007
      change += right - node.paths
      node.height = v.height
      if previous != nil && previous.to + 1 == node.from {
        previous.current += node.paths
        previous.paths += right
        previous.to = node.to
        toDelete = append(toDelete, min)
      } else {
        node.current = node.paths
        node.paths = right
        previous = &node
      }
      min += 1
    }

    if len(toDelete) > 0 {
      if dec {
        insertIndex -= len(toDelete)
      }
      for i := len(toDelete)-1; i >= 0; i-- {
        cache = Remove(cache, toDelete[i])
      }
      toDelete = toDelete[0:0]
    }

    step = (step + change) % 1000000007
    total = (total + step) % 1000000007
    last = insertIndex
  }
  return total % 1000000007
}

func main() {
  // values := []int{1,11,5,8,7,10,3,9,6,4,2,44,36,27,81,95,41}
  values := rand.Perm(50000)
  // fmt.Printf("Values", values)
  fmt.Printf("%d", Solution(values))
}