package main

import "fmt"

func Greet(name string) string {
	if name == "" {
		return "Hello, World!"
	}
	return fmt.Sprintf("Hello v2, %s!", name)
}

func main() {
	fmt.Println(Greet(""))
}
