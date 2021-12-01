package main

import (
	"fmt"
	"strconv"
	"strings"

	utils "github.com/ryapric/advent-of-code-2020"
)

var data utils.Data = utils.ReadFile("./input.txt")

func part1() {
	var validPasswords int

	for _, e := range data {
		// find range of letter counts, and set the low & high freqs of those
		countRange := strings.Split(e, " ")[0]
		countLow, errLow := strconv.Atoi(strings.Split(countRange, "-")[0])
		utils.Check(errLow)
		countHigh, errHigh := strconv.Atoi(strings.Split(countRange, "-")[1])
		utils.Check(errHigh)

		// set the required letter
		letterReq := strings.Split(strings.Split(e, " ")[1], ":")[0]

		// store the password itself
		password := strings.Split(e, " ")[2]

		// check each letter of the password against the req, and increment the
		// counter if you find one
		var letterReqCount int
		for _, letter := range password {
			if string(letter) == letterReq {
				letterReqCount++
			}
		}

		// only increment if the req count is within bounds
		if letterReqCount >= countLow && letterReqCount <= countHigh {
			validPasswords++
		}
	}

	fmt.Printf("Valid passwords count: %d\n", validPasswords)
}

func part2() {
	var validPasswords int

	for _, e := range data {
		// no longer working with counts, but indices (at index-1, thank god)
		idxRange := strings.Split(e, " ")[0]
		idxLow, errLow := strconv.Atoi(strings.Split(idxRange, "-")[0])
		utils.Check(errLow)
		idxHigh, errHigh := strconv.Atoi(strings.Split(idxRange, "-")[1])
		utils.Check(errHigh)

		letterReq := strings.Split(strings.Split(e, " ")[1], ":")[0]

		password := strings.Split(e, " ")[2]

		// check each of the two indices in the password for validity, independently
		var validLetterIdx int
		if string(password[idxLow-1]) == letterReq {
			validLetterIdx++
		}
		if string(password[idxHigh-1]) == letterReq {
			validLetterIdx++
		}

		// only increment if there was exactly one correctly-positioned letter in
		// the password
		if validLetterIdx == 1 {
			validPasswords++
		}
	}

	fmt.Printf("lol jk, valid passwords count: %d\n", validPasswords)
}

func main() {
	part1()
	part2()
}
