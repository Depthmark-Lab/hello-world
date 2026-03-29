package main

import "testing"

func TestGreet(t *testing.T) {
	tests := []struct {
		name string
		input string
		want string
	}{
		{"empty name", "", "Hello, World!"},
		{"with name", "Go", "Hello, Go!"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := Greet(tt.input)
			if got != tt.want {
				t.Errorf("Greet(%q) = %q, want %q", tt.input, got, tt.want)
			}
		})
	}
}
