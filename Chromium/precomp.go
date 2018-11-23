package main

import "fmt"
import "sort"
import "math/rand"

type Level struct {
    index int
    height int
}

type Levels []Level


func (l Level) String() string {
  return fmt.Sprintf("(%d %d)", l.index, l.height)
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
        vsm[i] = Level{i, v}
    }
    return vsm
}

func Insert(slice []int, index, value int) []int {
    slice = slice[0 : len(slice)+1]
    copy(slice[index+1:], slice[index:])
    slice[index] = value
    return slice
}

func Remove(slice []int, index int) []int{
  length := len(slice)
  slice = append(slice[:index], slice[index+1:]...)
  return slice[:length - 1]
}

func FindIndex(target_map []int, value int) (int, bool) {

  start_index := 0
  end_index := len(target_map) - 1

  for start_index <= end_index {

    median := (start_index + end_index) / 2

    if target_map[median] < value {
      start_index = median + 1
    } else {
      end_index = median - 1
    }
  }

  if start_index == len(target_map) || target_map[start_index] != value {
    return start_index, false
  } else {
    return start_index, true
  }
}

func countStack(switches []int,height int, max int) int{
  if len(switches) == 0 {
    return max + 1 - height
  }
  left  := 1
  right := 1
  total := 1
  path  := 0
  lastHeight := height
  levels := 0
  for _, level := range switches {
    levels = level - lastHeight
    if levels == 0 {
      continue
    }
    if path == 1 {
      increase := left * levels
      path = 0
      total = (total + increase) % 1000000007
      right = (right + increase) % 1000000007
    } else {
      increase := right * levels
      path = 1
      total = (increase + total) % 1000000007
      left =  (increase + left) % 1000000007
    }
    lastHeight = level
  }
  levels = max - switches[len(switches) - 1]
  if path == 1 {
    total += (left * levels) % 1000000007
  }else {
    total += (right * levels) % 1000000007
  }
  return total
}

func Solution(A []int) int{
  preWithPIndices := WithIndices(A)
  byHeight := make(map[int]Level)
  byIndex  := make(map[int]Level)
  switches := make(map[int][]int)
  removes  := make(map[int][]int)

  sort.Sort(Levels(preWithPIndices))


  withIndices := make([]Level, len(preWithPIndices))
  for i, v := range preWithPIndices {
    withIndices[i] = Level{v.index, i + 1}
  }

  index := withIndices[0].index
  byIndex[index] = withIndices[0]

  for _, l := range withIndices[1:] {
    byHeight[l.height] = l
    byIndex[l.index] = l
    if l.index < index {
      switches[l.index] = append(switches[l.index], l.height - 1)
      removes[index]    = append(removes[index], l.height - 1)
    } else {
      switches[index]  = append(switches[index], l.height - 1)
      removes[l.index] = append(removes[l.index], l.height - 1)
    }
    index = l.index
  }

  currentSwitches  := make([]int, 50000)
  currentSwitches = currentSwitches[0:0]

  total := 0

  for i, _ := range withIndices {
    height := byIndex[i].height
    if removes, ok := removes[i]; ok{
      for _, remv := range removes {
        if index, found := FindIndex(currentSwitches, remv); found {
          currentSwitches = Remove(currentSwitches, index)
        }
      }
    }

    if switches, ok := switches[i]; ok {
      for _, swtch := range switches {
        index, _ := FindIndex(currentSwitches, swtch)
        currentSwitches = Insert(currentSwitches, index, swtch)
      }
    }

    insertIndex, found := FindIndex(currentSwitches, height)
    if found {
      insertIndex += 1
    }
    applicable := currentSwitches[insertIndex:]
    step := countStack(applicable, height, len(A))
    total = (total + step) % 1000000007
  }
  return total % 1000000007
}

func main() {
  // values := []int{1,11,5,8,7,10,3,9,6,4,2,44,36,27,81,95,41}
  values := rand.Perm(50000)
  // fmt.Printf("Values", values)
  fmt.Printf("%d", Solution(values))
}