package main

import (
	"fmt"
	"strconv"

	utils "github.com/ryapric/advent-of-code-2020"
)

var data []string = utils.ReadFile("./input.txt")

func part1() {
	for _, i1 := range data {
		for _, i2 := range data {
			e1, err := strconv.Atoi(i1)
			utils.Check(err)
			e2, err := strconv.Atoi(i2)
			utils.Check(err)
			if e1+e2 == 2020 {
				fmt.Printf("PART 1: Numbers that add up to 2020: %d, %d -- Product: %d\n", e1, e2, e1*e2)
				return
			}
		}
	}
}

func part2() {
	for _, i1 := range data {
		for _, i2 := range data {
			for _, i3 := range data {
				e1, err := strconv.Atoi(i1)
				utils.Check(err)
				e2, err := strconv.Atoi(i2)
				utils.Check(err)
				e3, err := strconv.Atoi(i3)
				utils.Check(err)
				if e1+e2+e3 == 2020 {
					fmt.Printf("PART 2: Numbers that add up to 2020: %d, %d, %d -- Product: %d\n", e1, e2, e3, e1*e2*e3)
					return
				}
			}
		}
	}
}

func main() {
	part1()
	part2()
}
