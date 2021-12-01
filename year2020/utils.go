package utils

import (
	"bufio"
	"os"
)

// Check does the obnoxious if err != nil block
func Check(err error) {
	if err != nil {
		panic(err)
	}
}

// Data is a string slice representing read file contents
type Data []string

// ReadFile pulls text file lines into a string slice
func ReadFile(path string) Data {
	file, err := os.Open("./input.txt")
	Check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	var data []string

	for scanner.Scan() {
		data = append(data, scanner.Text())
	}

	return data
}
