package main

import "fmt"

func Greet(name string) string {
	if name == "" {
		return "Hello, World!"
	}
	return fmt.Sprintf("Hello Hello hello, %s!", name)
}

func main() {
	fmt.Println(Greet(""))
}
